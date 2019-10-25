//
//  ByteSequenceShaper.swift
//  ProteanSwift
//
//  Created by Adelita Schule on 8/10/18.
//

import Foundation
import Datable

/// An obfuscator that injects byte sequences.
public class ByteSequenceShaper
{
    /**
     Sequence models where the Sequences have been decoded as []bytes. This is used internally by the ByteSequenceShaper.
     
     - index: Int8, Index of the packet into the stream.
     - offset: Int16, Offset of the Sequence in the packet.
     - sequence: Data, Byte Sequence.
     - length: Int16
     */
    public struct SequenceModel
    {
        /// Index of the packet into the stream.
        var index: UInt
        
        /// Offset of the Sequence in the packet.
        var offset: UInt
        
        /// Byte Sequence.
        var sequence: Data
        
        ///FIXME: Target packet Length.
        var length: UInt
        /**
         ByteSequenceShaper creates a packet and inserts it at the given index.
         If the length is greater than the sequence provided,
         filler data is generated and inserted before (if offset > 0) and after the sequence
         until the packet is the correct length.
         - parameters:
             - index: The index where the packet should be inserted into the overall stream
             - offset: The offset within the packet that the sequence should be insert
             - sequence: The specific data to insert into the packet.
             - length: The size the new inserted packet should be. Length must be no larger than 1440 bytes
         */
       
        public init?(index: UInt, offset: UInt, sequence: Data, length: UInt)
        {
            ///Length must be no larger than 1440 bytes
            if length == 0 || length > 1440
            {
                print("\nByteSequenceShaper initialization failed: target length was either 0 or larger than 1440\n")
                return nil
            }
            
            /// Offset + Sequence count cannot be grater than the length
            guard offset + UInt(sequence.count) <= length
            else
            {
                print("\nByteSequenceShaper initialization failed: Offset + sequence count is greater than the target length provided.\n")
                return nil
            }
            
            
            self.index = index
            self.offset = offset
            self.sequence = sequence
            self.length = length
        }
    }
    
    /**
     Accepted in serialised form by Configure().
     
     - addSequences: SerializedSequenceModel, Sequences that should be added to the outgoing packet stream.
     - removeSequences: SerializedSequenceModel, Sequences that should be removed from the incoming packet stream.
     */
    public struct Config
    {
        /// Sequences that should be added to the outgoing packet stream.
        var addSequences: [SequenceModel]
        
        /// Sequences that should be removed from the incoming packet stream.
        var removeSequences: [SequenceModel]
        
        public init(addSequences: [SequenceModel], removeSequences: [SequenceModel])
        {
            self.addSequences = addSequences
            self.removeSequences = removeSequences
        }
    }
    
    var config: ByteSequenceShaper.Config
    
    /// Index of the first packet to be injected into the stream.
    var firstIndex: UInt
    
    /// Index of the last packet to be injected into the stream.
    var lastIndex: UInt
    
    /// Current Index into the output stream.
    /// This starts at zero and is incremented every time a packet is output.
    /// The OutputIndex is compared to the SequenceModel Index.
    /// When they are equal, a byte Sequence packet is injected into the output.
    var outputIndex: UInt

    /**
     Returns an obfuscator that injects byte sequences.
     - parameters:
         - config: ByteSequenceShaper.Config, contains the sequences that should be added to the outgoing and removed from the incoming packet streams.
         - firstIndex: Int8, Index of the first packet to be injected into the stream.
         - lastIndex: Int8, Index of the last packet to be injected into the stream.
         - outputIndex: Int8, Current Index into the output stream.
     */
    public init?(config: ByteSequenceShaper.Config)
    {
        guard let firstSequence = config.addSequences.first
        else
        {
            return nil
        }
        
        guard let lastSequence = config.addSequences.last
        else
        {
            return nil
        }
        
        // Check to make sure that add sequences do not have the same indices, do the same for remove sequences
        let addSeqGroupedByIndex = Dictionary(grouping: config.addSequences) { $0.index }
        for index in addSeqGroupedByIndex
        {
            if index.value.count > 1
            {
                return nil
            }
        }
        
        let removeSeqGroupedByIndex = Dictionary(grouping: config.removeSequences) { $0.index }
        for index in removeSeqGroupedByIndex
        {
            if index.value.count > 1
            {
                return nil
            }
        }
        
        self.config = config
        self.firstIndex = firstSequence.index
        self.lastIndex = lastSequence.index
        self.outputIndex = 0
    }
    
    /// Inject packets
    func inject(results: [Data]) -> [Data]
    {
        var nextPacket = config.addSequences.first(where: {(sequence) in sequence.index == outputIndex})
        var newResults = results
        
        while nextPacket != nil
        {
            guard let newPacket = makePacket(model: nextPacket!)
            else
            {
                break
            }
            
            newResults.append(newPacket)
            outputIndex += 1
            nextPacket = config.addSequences.first(where: {(sequence) in sequence.index == outputIndex})
        }
        
        return newResults
    }
    
    /// For a byte Sequence, see if there is a matching Sequence to remove.
    func findMatchingPacket(sequence: Data) -> Bool
    {
        for index in 0 ..< config.removeSequences.count
        {
            let sequenceModel = config.removeSequences[index]
            let index1 = Int(sequenceModel.offset)
            let index2 = index1 + sequenceModel.sequence.count
            
            if sequence.count >= index2
            {
                let source = Data(sequence[index1 ..< index2])
                
                if source.bytes == sequenceModel.sequence.bytes
                {
                    //Remove matched packet so that it's not matched again
                    config.removeSequences.remove(at: index)
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    /// With a Sequence model, generate a packet to inject into the stream.
    func makePacket(model: SequenceModel) -> Data?
    {
        var result = Data()
        
        // Add the bytes before the Sequence.
        if model.offset > 0
        {
            var randomBytes = [UInt8](repeating: 0, count: Int(model.offset))
            let status = SecRandomCopyBytes(kSecRandomDefault, Int(model.offset), &randomBytes)
            if status == errSecSuccess
            {
                result.append(Data(bytes: randomBytes))
            }
            else
            {
                return nil
            }
        }
        
        // Add the Sequence
        result.append(model.sequence)
        
        // Add the bytes after the sequence
        if result.count < model.length
        {
            let length = Int(model.length) - result.count
            
            var randomBytes = [UInt8](repeating: 0, count: length)
            let status = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)
            if status == errSecSuccess
            {
                result.append(Data(bytes: randomBytes))
            }
            else
            {
                return nil
            }
        }
        
        return result
    }
}

extension ByteSequenceShaper: Transformer
{
    /// Inject header.
    public func transform(buffer: Data) -> [Data]
    {
        var results: [Data] = []

        // Check if the current Index into the packet stream is within the range where a packet injection could possibly occur.
        if outputIndex <= lastIndex
        {
            // Injection has not finished, but may not have started yet.
            if Int(outputIndex) >= Int(firstIndex) - 1
            {
                // Injection has started and has not finished, so check to see if it is time to inject a packet.
                // Inject fake packets before the real packet
                results = inject(results: results)
                
                // Inject the real packet
                results.append(buffer)
                outputIndex += 1
                
                //Inject fake packets after the real packet
                results = inject(results: results)
            }
            else
            {
                // Injection has not started yet. Keep track of the Index.
                results = [buffer]
                outputIndex += 1
            }
            
            return results
        }
        else
        {
            // Injection has finished and will not occur again. Take the fast path and just return the buffer.
            return [buffer]
        }
    }
    
    /// Remove injected packets.
    public func restore(buffer: Data) -> [Data]
    {
        if findMatchingPacket(sequence: buffer)
        {
            return []
        }
        else
        {
            return [buffer]
        }
    }
}

/// Creates a sample (non-random) config, suitable for testing.
public func sampleSequenceConfig() -> ByteSequenceShaper.Config?
{
    let sequence = Data(string: "OH HELLO")
    
    guard let sequenceModel = ByteSequenceShaper.SequenceModel(index: 0, offset: 0, sequence: sequence, length: 256)
        else
    {
        return nil
    }
    
    return ByteSequenceShaper.Config(addSequences: [sequenceModel], removeSequences: [sequenceModel])
}







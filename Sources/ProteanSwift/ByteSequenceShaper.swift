//
//  ByteSequenceShaper.swift
//  ProteanSwift
//
//  Created by Adelita Schule on 8/10/18.
//

import Foundation

/**
 Accepted in serialised form by Configure().
 
- addSequences: SerializedSequenceModel, Sequences that should be added to the outgoing packet stream.
- removeSequences: SerializedSequenceModel, Sequences that should be removed from the incoming packet stream.
 */
struct SequenceConfig
{
    var addSequences: SerializedSequenceModel
    var removeSequences: SerializedSequenceModel
}

/**
 Sequence models where the Sequences have been encoded as strings.
 This is used by the SequenceConfig argument passed to Configure().
 
 - index: Int8, Index of the packet into the Sequence.
 - offset: Int16, Offset of the Sequence in the packet.
 - sequence: String, Byte Sequence encoded as a string.
 - length: Int16, Target packet Length.
 */
struct SerializedSequenceModel
{
    ///Index of the packet into the Sequence.
    var index: Int8
    
    ///Offset of the Sequence in the packet.
    var offset: Int16
    
    ///Byte Sequence encoded as a string.
    var sequence: String
    
    /// Target packet Length.
    var length: Int16
}

/**
 Sequence models where the Sequences have been decoded as []bytes. This is used internally by the ByteSequenceShaper.
 
 - index: Int8, Index of the packet into the stream.
 - offset: Int16, Offset of the Sequence in the packet.
 - sequence: Data, Byte Sequence.
 - length: Int16
 */
struct SequenceModel
{
    var index: Int8
    
    /// Offset of the Sequence in the packet.
    var offset: Int16
    
    /// Byte Sequence.
    var sequence: Data
    
    /// Target packet Length.
    var length: Int16
}

/// Creates a sample (non-random) config, suitable for testing.
func sampleSequenceConfig() -> SequenceConfig?
{
    /*
     var bytes = []byte("OH HELLO")
     hexSequence := hex.EncodeToString(bytes)
     sequenceModel := SerializedSequenceModel{Index: 0, Offset: 0, Sequence: hexSequence, Length: 256}
     return SequenceConfig{AddSequences: []SerializedSequenceModel{sequenceModel}, RemoveSequences: []SerializedSequenceModel{sequenceModel}}
     */
    
    let data = Data(string: "OH HELLO")
    
    guard let sequenceString = String(bytes: data, encoding: .utf16)
    else
    {
        return nil
    }
    
    let sequenceModel = SerializedSequenceModel(index: 0, offset: 0, sequence: sequenceString, length: 256)
    return SequenceConfig(addSequences: sequenceModel, removeSequences: sequenceModel)
}

/**
 An obfuscator that injects byte sequences.
 
 - addSequences: SequenceModel, Sequences that should be added to the outgoing packet stream.
 - removeSequences: SequenceModel, Sequences that should be removed from the incoming packet stream.
 - firstIndex: Int8, Index of the first packet to be injected into the stream.
 - lastIndex: Int8, Index of the last packet to be injected into the stream.
 - outputIndex: Int8, Current Index into the output stream.
 */
struct ByteSequenceShaper
{
    /// Sequences that should be added to the outgoing packet stream.
    var addSequences: SequenceModel
    
    /// Sequences that should be removed from the incoming packet stream.
    var removeSequences: SequenceModel
    
    /// Index of the first packet to be injected into the stream.
    var firstIndex: Int8
    
    /// Index of the last packet to be injected into the stream.
    var lastIndex: Int8
    
    /// Current Index into the output stream.
    /// This starts at zero and is incremented every time a packet is output.
    /// The OutputIndex is compared to the SequenceModel Index.
    /// When they are equal, a byte Sequence packet is injected into the output.
    var outputIndex: Int8
    

    //TODO: init
    /*
     func NewByteSequenceShaper() *ByteSequenceShaper {
     shaper := &ByteSequenceShaper{}
     config := sampleSequenceConfig()
     jsonConfig, err := json.Marshal(config)
     if err != nil {
     return nil
     }
     
     shaper.Configure(string(jsonConfig))
     return shaper
     }
     */
    
    /// This method is required to implement the Transformer API.
    /// @param {[]byte} key Key to set, not used by this class.
    func setKey(key: Data)
    {
        
    }
    
    /// Configure the Transformer with the headers to inject and the headers to remove.
    func configure(jsonConfig: String)
    {
        /*
         var config SequenceConfig
         err := json.Unmarshal([]byte(jsonConfig), &config)
         if err != nil {
         fmt.Println("Encryption shaper requires key parameter")
         }
         
         shaper.ConfigureStruct(config)
         */
    }
    
    func configureStruct(config: SequenceConfig)
    {
        /*
         shaper.AddSequences, shaper.RemoveSequences = deserializeByteSequenceConfig(config)
         
         // Make a note of the Index of the first packet to inject
         shaper.FirstIndex = shaper.AddSequences[0].Index
         
         // Make a note of the Index of the last packet to inject
         shaper.LastIndex = shaper.AddSequences[len(shaper.AddSequences)-1].Index
         */
    }
    
    /// Decode the key from string in the config information
    func deserializeByteSequenceConfig(config: SequenceConfig) -> (addSequence: SequenceModel, removeSequence: SequenceModel)?
    {
        /*
         func deserializeByteSequenceConfig(config SequenceConfig) ([]*SequenceModel, []*SequenceModel) {
         adds := make([]*SequenceModel, len(config.AddSequences))
         rems := make([]*SequenceModel, len(config.RemoveSequences))
         
         for x, seq := range config.AddSequences {
         adds[x] = deserializeByteSequenceModel(seq)
         }
         
         for x, seq := range config.RemoveSequences {
         rems[x] = deserializeByteSequenceModel(seq)
         }
         
         return adds, rems
         }
         */
        
        return nil
    }
    
    /// Decode the header from a string in the header model
    func deserializeByteSequenceModel(model: SerializedSequenceModel) -> SequenceModel?
    {
        /*
         sequence, err := hex.DecodeString(model.Sequence)
         if err != nil {
         return nil
         }
         
         return &SequenceModel{Index: model.Index, Offset: model.Offset, Sequence: sequence, Length: model.Length}
         */
        
        return nil
    }
    
    /// Inject header.
    mutating func transform(buffer: Data) -> [Data]
    {
        /*
         func (shaper *ByteSequenceShaper) Transform(buffer []byte) [][]byte {
         var results [][]byte
         
         // Check if the current Index into the packet stream is within the range
         // where a packet injection could possibly occur.
         if shaper.OutputIndex <= shaper.LastIndex {
         // Injection has not finished, but may not have started yet.
         if shaper.OutputIndex >= shaper.FirstIndex {
         // Injection has started and has not finished, so check to see if it is
         // time to inject a packet.
         
         // Inject fake packets before the real packet
         results = shaper.Inject(results)
         
         // Inject the real packet
         results = shaper.OutputAndIncrement(results, buffer)
         
         //Inject fake packets after the real packet
         results = shaper.Inject(results)
         } else {
         // Injection has not started yet. Keep track of the Index.
         results = shaper.OutputAndIncrement(results, buffer)
         }
         
         return results
         } else {
         // Injection has finished and will not occur again. Take the fast path and
         // just return the buffer.
         return [][]byte{buffer}
         }
         }
         */
        
        var results = [Data()]
        
        // Check if the current Index into the packet stream is within the range
        // where a packet injection could possibly occur.
        if self.outputIndex <= self.lastIndex
        {
            // Injection has not finished, but may not have started yet.
            if self.outputIndex >= self.firstIndex
            {
                // Injection has started and has not finished, so check to see if it is
                // time to inject a packet.
                
                // Inject fake packets before the real packet
                results = self.inject(results: results)
                
                // Inject the real packet
                results = self.outputAndIncrement(results: results, result: buffer)
                
                //Inject fake packets after the real packet
                results = self.inject(results: results)
            }
            else
            {
                // Injection has not started yet. Keep track of the Index.
                results = self.outputAndIncrement(results: results, result: buffer)
            }
            
            return results
        }
        else
        {
            // Injection has finished and will not occur again.
            //FIXME: Take the fast path and just return the buffer.
            return [buffer]
        }
    }
    
    /// Remove injected packets.
    func restore(buffer: Data) -> [Data]
    {
        /*
         match := shaper.findMatchingPacket(buffer)
         if match != nil {
         return [][]byte{}
         } else {
         return [][]byte{buffer}
         }
         */
        
        let match = findMatchingPacket(sequence: buffer)
        
        if match != nil
        {
            return [Data()]
        }
        else
        {
            return [buffer]
        }
    }
    
    /// No-op (we have no state or any resources to Dispose).
    func dispose() {
    }
    
    /// Inject packets
    mutating func inject(results: [Data]) -> [Data]
    {
        /*
         func (shaper *ByteSequenceShaper) Inject(results [][]byte) [][]byte {
         nextPacket := shaper.findNextPacket(shaper.OutputIndex)
         for nextPacket != nil {
         results = shaper.OutputAndIncrement(results, shaper.makePacket(nextPacket))
         nextPacket = shaper.findNextPacket(shaper.OutputIndex)
         }
         
         return results
         }
         */
        
        var nextPacket = findNextPacket(index: outputIndex)
        var newResults = results
        while nextPacket != nil
        {
            guard let newPacket = makePacket(model: nextPacket!)
            else
            {
                break
            }
            
            newResults = outputAndIncrement(results: newResults, result: newPacket)
            nextPacket = findNextPacket(index: outputIndex)
        }
        
        return newResults
    }
    
    mutating func outputAndIncrement(results: [Data], result: Data) -> [Data]
    {
        /*
         results = append(results, result)
         shaper.OutputIndex = shaper.OutputIndex + 1
         return results
         */
        
        var newResults = results
        newResults.append(result)
        outputIndex += 1
        
        return newResults
    }
    
    /// For an Index into the packet stream, see if there is a Sequence to inject.
    func findNextPacket(index: Int8) -> SequenceModel?
    {
        /*
         for _, sequence := range shaper.AddSequences
         {
             if index == sequence.Index
             {
             return sequence
             }
         }
         
         return nil
         */
        
        return nil
    }
    
    /// For a byte Sequence, see if there is a matching Sequence to remove.
    func findMatchingPacket(sequence: Data) -> SequenceModel?
    {
        /*
         for i, model := range shaper.RemoveSequences
         {
             target := model.Sequence
             source := sequence[int(model.Offset) : int(model.Offset)+len(target)]
             if bytes.Equal(source, target)
             {
                 // Remove matched packet so that it's not matched again
                 shaper.RemoveSequences = append(shaper.RemoveSequences[:i], shaper.RemoveSequences[i+1:]...)
         
                 // Return matched packet
                 return model
             }
         }
         
         return nil
         */
        
        return nil
    }
    
    /// With a Sequence model, generate a packet to inject into the stream.
    func makePacket(model: SequenceModel) -> Data?
    {
        /*
         var result []byte
         
         // Add the bytes before the Sequence.
         if model.Offset > 0
         {
             length := model.Offset
             randomBytes := make([]byte, length)
             rand.Read(randomBytes)
             result = append(result, randomBytes...)
         }
         
         // Add the Sequence
         result = append(result, model.Sequence...)
         
         // Add the bytes after the sequnece
         if model.Offset < model.Length
         {
             length := int(model.Length) - (int(model.Offset) + len(model.Sequence))
             randomBytes := make([]byte, length)
             rand.Read(randomBytes)
             result = append(result, randomBytes...)
         }
         
         return result
         */
        
        var result: Data?
        
        // Add the bytes before the Sequence.
        if model.offset > 0
        {
            let length = model.offset
            var randomBytes = [UInt8](repeating: 0, count: Int(length))
            let status = SecRandomCopyBytes(kSecRandomDefault, Int(length), &randomBytes)
            if status == errSecSuccess
            {
                
                // rand.Read(randomBytes)
                result = Data(bytes: randomBytes)
            }
            else
            {
                return nil
            }

        }
        
        // Add the Sequence
        result?.append(model.sequence)
        
        // Add the bytes after the sequence
        if model.offset > model.length
        {
            let length = Int(model.length) - (Int(model.offset) + model.sequence.count)
//            randomBytes := make([]byte, length)
//            rand.Read(randomBytes)
            
            var randomBytes = [UInt8](repeating: 0, count: length)
            let status = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)
            if status == errSecSuccess
            {
                
                // rand.Read(randomBytes)
                result?.append(Data(bytes: randomBytes))
            }
            else
            {
                return nil
            }
        }
        
        return result
    }
    
}









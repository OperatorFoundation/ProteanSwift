import XCTest
import Foundation

@testable import ProteanSwift

final class ProteanSwiftTests: XCTestCase
{
    func testHeaderTransform()
    {
        let testData = Data(bytes: [12, 1, 42, 17])
        guard let headerShaper = HeaderShaper(config: sampleHeaderConfig())
        else
        {
            XCTFail()
            return
        }
        
        let transformResult = headerShaper.transform(buffer: testData)
        let restoreResult = headerShaper.restore(buffer: transformResult[0])
        
        XCTAssertNotEqual(testData, transformResult[0])
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    func testEncryptionShaper()
    {
        let testData = Data(bytes: [12, 1, 42, 17, 88, 75, 1, 1, 1, 0])
        let encryptionShaper = EncryptionShaper(config: sampleEncryptionConfig())
        
        XCTAssertNotNil(encryptionShaper)
        
        let transformResult = encryptionShaper!.transform(buffer: testData)
        if transformResult.isEmpty
        {
            XCTFail()
        }
        
        XCTAssertNotEqual(testData, transformResult.first)
        
        let restoreResult = encryptionShaper!.restore(buffer: transformResult[0])
        
        XCTAssertEqual(testData, restoreResult.first)
    }
    
    let sequence1 = Data(string: "OH HELLO")
    let sequence2 = Data(string: "You say hello, and I say goodbye.")
    let testData = Data(string: "I don't know why you say 'Goodbye', I say 'Hello'.")
    
    //Offsets is 0, sequence is at index 0
    func testOneSequenceNoOffsetFirst()
    {
        guard let sequenceModel1 = ByteSequenceShaper.SequenceModel(index: 0,
                                                                    offset: 0,
                                                                    sequence: sequence1,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        let config = ByteSequenceShaper.Config(addSequences: [sequenceModel1], removeSequences: [sequenceModel1])
        
        guard let sequenceShaper = ByteSequenceShaper(config: config)
            else
        {
            XCTFail()
            return
        }
        
        let transformResult = sequenceShaper.transform(buffer: testData)
        let restoreResult = transformResult.flatMap(sequenceShaper.restore)
        
        XCTAssertNotEqual(testData.bytes, transformResult[0].bytes)
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    //Offsets is > 0, sequence is at index 0
    func testOneSequenceOffsetFirst()
    {
        guard let sequenceModel1 = ByteSequenceShaper.SequenceModel(index: 0,
                                                                    offset: 3,
                                                                    sequence: sequence1,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        let config = ByteSequenceShaper.Config(addSequences: [sequenceModel1], removeSequences: [sequenceModel1])
        
        guard let sequenceShaper = ByteSequenceShaper(config: config)
            else
        {
            XCTFail()
            return
        }
        
        let transformResult = sequenceShaper.transform(buffer: testData)
        let restoreResult = transformResult.flatMap(sequenceShaper.restore)
        
        XCTAssertNotEqual(testData.bytes, transformResult[0].bytes)
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    //Offsets is 0, sequence is at index > 0
    func testOneSequenceNoOffsetNotFirst()
    {
        guard let sequenceModel1 = ByteSequenceShaper.SequenceModel(index: 3,
                                                                    offset: 3,
                                                                    sequence: sequence1,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        let config = ByteSequenceShaper.Config(addSequences: [sequenceModel1], removeSequences: [sequenceModel1])
        
        guard let sequenceShaper = ByteSequenceShaper(config: config)
            else
        {
            XCTFail()
            return
        }
        
        let transformResult = sequenceShaper.transform(buffer: testData)
        let restoreResult = transformResult.flatMap(sequenceShaper.restore)
        
        XCTAssertNotEqual(testData.bytes, transformResult[0].bytes)
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    //Offsets is > 0, sequence is at index > 0
    func testOneSequenceOffsetNotFirst()
    {
        guard let sequenceModel1 = ByteSequenceShaper.SequenceModel(index: 20,
                                                                    offset: 2,
                                                                    sequence: sequence1,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        let config = ByteSequenceShaper.Config(addSequences: [sequenceModel1], removeSequences: [sequenceModel1])
        
        guard let sequenceShaper = ByteSequenceShaper(config: config)
            else
        {
            XCTFail()
            return
        }
        
        let transformResult = sequenceShaper.transform(buffer: testData)
        let restoreResult = transformResult.flatMap(sequenceShaper.restore)
        
        XCTAssertNotEqual(testData.bytes, transformResult[0].bytes)
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    
    //Offsets are both 0 one sequence is at index 0
    func testTwoSequenceNoOffsetFirst()
    {
        guard let sequenceModel1 = ByteSequenceShaper.SequenceModel(index: 0,
                                                                    offset: 0,
                                                                    sequence: sequence1,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        guard let sequenceModel2 = ByteSequenceShaper.SequenceModel(index: 3,
                                                                   offset: 0,
                                                                   sequence: sequence2,
                                                                   length: 256)
        else
        {
            XCTFail()
            return
        }
        
        let config = ByteSequenceShaper.Config(addSequences: [sequenceModel1, sequenceModel2], removeSequences: [sequenceModel1, sequenceModel2])
        
        guard let sequenceShaper = ByteSequenceShaper(config: config)
        else
        {
            XCTFail()
            return
        }
        
        let transformResult = sequenceShaper.transform(buffer: testData)
        let restoreResult = transformResult.flatMap(sequenceShaper.restore)
        
        XCTAssertNotEqual(testData.bytes, transformResult[0].bytes)
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    //Offsets are both 0 indices are both > 0
    func testTwoSequenceNoOffsetNotFirst()
    {
        
        
        guard let sequenceModel1 = ByteSequenceShaper.SequenceModel(index: 5,
                                                                    offset: 0,
                                                                    sequence: sequence1,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        guard let sequenceModel2 = ByteSequenceShaper.SequenceModel(index: 100,
                                                                    offset: 0,
                                                                    sequence: sequence2,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        let config = ByteSequenceShaper.Config(addSequences: [sequenceModel1, sequenceModel2], removeSequences: [sequenceModel1, sequenceModel2])
        
        guard let sequenceShaper = ByteSequenceShaper(config: config)
            else
        {
            XCTFail()
            return
        }
        
        let transformResult = sequenceShaper.transform(buffer: testData)
        let restoreResult = transformResult.flatMap(sequenceShaper.restore)
        
        XCTAssertNotEqual(testData.bytes, transformResult[0].bytes)
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    //Offsets are both > 0 indices are both > 0
    func testTwoSequenceWithOffsetNotFirst()
    {
        
        
        guard let sequenceModel1 = ByteSequenceShaper.SequenceModel(index: 5,
                                                                    offset: 2,
                                                                    sequence: sequence1,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        guard let sequenceModel2 = ByteSequenceShaper.SequenceModel(index: 100,
                                                                    offset: 1,
                                                                    sequence: sequence2,
                                                                    length: 256)
            else
        {
            XCTFail()
            return
        }
        
        let config = ByteSequenceShaper.Config(addSequences: [sequenceModel1, sequenceModel2], removeSequences: [sequenceModel1, sequenceModel2])
        
        guard let sequenceShaper = ByteSequenceShaper(config: config)
            else
        {
            XCTFail()
            return
        }
        
        let transformResult = sequenceShaper.transform(buffer: testData)
        let restoreResult = transformResult.flatMap(sequenceShaper.restore)
        
        XCTAssertNotEqual(testData.bytes, transformResult[0].bytes)
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    func testOneSequenceNoOffset()
    {
        let testData = Data(bytes: [12, 1, 42, 17, 88, 75, 1, 1, 1, 0])
        
        guard let sampleSeqConfig = sampleSequenceConfig()
        else
        {
            XCTFail()
            return
        }
        
        let sequenceShaper = ByteSequenceShaper(config: sampleSeqConfig)
        
        XCTAssertNotNil(sequenceShaper)
        
        let transformResult = sequenceShaper!.transform(buffer: testData)
        let restoreResult = transformResult.flatMap(sequenceShaper!.restore)
        
        XCTAssertNotEqual(testData.bytes, transformResult[0].bytes)
        XCTAssertEqual(testData, restoreResult[0])
    }
    
    func testProtean()
    {
        let testData = Data(bytes: [12, 1, 42, 17, 88, 75, 1, 1, 1, 0])
        let protean = Protean(config: sampleProteanConfig())
        let transformResults = protean.transform(buffer: testData)
        
        guard let firstResult = transformResults.first
        else
        {
            print("Protean transform returned an empty array")
            XCTFail()
            return
        }
        
        XCTAssertNotEqual(testData, firstResult)
        
        let restoreResults = protean.restore(buffer: firstResult)
        
        guard let firstRestoreResult = restoreResults.first
        else
        {
            print("Protean restore returned an empty array")
            XCTFail()
            return
        }
        
        XCTAssertEqual(testData, firstRestoreResult)
    }
}

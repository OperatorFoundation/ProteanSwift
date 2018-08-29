import XCTest
import Foundation

@testable import ProteanSwift

final class ProteanSwiftTests: XCTestCase
{
    func testHeaderTransform()
    {
        let testData = Data(bytes: [12, 1, 42, 17])
        let headerShaper = HeaderShaper(config: sampleHeaderConfig())
        
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
    
    func testByteSeqenceShaper()
    {
        let testData = Data(bytes: [12, 1, 42, 17, 88, 75, 1, 1, 1, 0])
//        let sequence1 = Data(bytes: [2, 3, 2, 2, 4, 1, 0])
//        let sequence2 = Data(bytes: [1,1,1,1,1,1,1,1])
//
//        let sequenceModel1 = ByteSequenceShaper.SequenceModel(index: 0,
//                                                             offset: 1,
//                                                             sequence: sequence1,
//                                                             length: 256)
//        XCTAssertNotNil(sequenceModel1)
//
//        let sequenceModel2 = ByteSequenceShaper.SequenceModel(index: 3,
//                                                             offset: 1,
//                                                             sequence: sequence2,
//                                                             length: 256)
//        XCTAssertNotNil(sequenceModel2)
//
//        let sequenceConfig = ByteSequenceShaper.Config(addSequences: [sequenceModel2!], removeSequences: [sequenceModel2!])
        
        //let sequenceConfig = ByteSequenceShaper.Config(addSequences: [sequenceModel1!, sequenceModel2!], removeSequences: [sequenceModel1!, sequenceModel2!])
        
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
        //let restoreResult = sequenceShaper!.restore(buffer: transformResult[0])
        
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

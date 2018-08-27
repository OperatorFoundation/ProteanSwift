import Foundation

public struct Protean
{
    public struct Config
    {
        var byteSequenceConfig: ByteSequenceShaper.Config?
        var encryptionConfig: EncryptionShaper.Config?
        var headerConfig: HeaderShaper.Config?
    }
    
    public var config: Protean.Config
    var byteSequenceShaper: ByteSequenceShaper?
    var encryptionShaper: EncryptionShaper?
    var headerShaper: HeaderShaper?
    
    public init(config: Protean.Config)
    {
        if let byteSequenceConfig = config.byteSequenceConfig
        {
            byteSequenceShaper = ByteSequenceShaper(config: byteSequenceConfig)
        }
        
        if let encryptionConfig = config.encryptionConfig
        {
            encryptionShaper = EncryptionShaper(config: encryptionConfig)
        }
        
        if let headerConfig = config.headerConfig
        {
            headerShaper = HeaderShaper(config: headerConfig)
        }
        
        self.config = config
    }
    
    func metaTransform(data: Data, transforms: [(Data)->[Data]]) -> [Data]
    {
        var result = [data]

        transforms.forEach
        {
            (transform) in
            
            result = result.flatMap(transform)
        }

        return result
    }
    
    
}

extension Protean: Transformer
{
    /**
    Apply the following Transformations, assuming a config was supplied for each:
     - Encrypt using AES
     - Inject headers into packets
     - Inject packets with byte sequences
     */
    public func transform(buffer: Data) -> [Data]
    {
        /// 🤖 -> 🚚
        var transformers = [(Data)->[Data]]()
        
        // Encryption
        if let eShaper = encryptionShaper
        {
            transformers.append(eShaper.transform)
        }
        
        // Headers
        if let hShaper = headerShaper
        {
            transformers.append(hShaper.transform)
        }
        
        // Byte Sequences
        if let sShaper = byteSequenceShaper
        {
            transformers.append(sShaper.transform)
        }
        
        if !transformers.isEmpty
        {
            return metaTransform(data: buffer, transforms: transformers)
        }
        
        
        return []
        
    }
    
/**
 Apply the following Transformations:
     - Discard injected packets
     - Discard injected headers
     - Decrypt with AES
 */
    public func restore(buffer: Data) -> [Data]
    {
        /// 🚚 -> 🤖
        var transformers = [(Data)->[Data]]()
        
        // Byte Sequnces
        if let sShaper = byteSequenceShaper
        {
            transformers.append(sShaper.restore)
        }
        
        // Headers
        if let hShaper = headerShaper
        {
            transformers.append(hShaper.restore)
        }
        
        // Decryption
        if let eShaper = encryptionShaper
        {
            transformers.append(eShaper.restore)
        }
        
        if !transformers.isEmpty
        {
            return metaTransform(data: buffer, transforms: transformers)
        }
        
        return []
    }
}

func sampleProteanConfig() -> Protean.Config
{
    //FIXME: sampleSequenceConfig
    return Protean.Config(byteSequenceConfig: nil,
                          encryptionConfig: sampleEncryptionConfig(),
                          headerConfig: sampleHeaderConfig())
}

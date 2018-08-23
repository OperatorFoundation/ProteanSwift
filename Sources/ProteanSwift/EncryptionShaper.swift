//
//  EncryptionShaper.swift
//  ProteanSwift
//
//  Created by Adelita Schule on 8/10/18.
//

import Foundation
import Security
import CryptoSwift

// A packet shaper that encrypts the packets with AES CBC.
public struct EncryptionShaper
{
    /// Required to create EncryptionSHaper instance
    /// - key: AES-256, needs to be 32 bytes
    public struct Config
    {
        ///AES-256: needs to be 32 bytes
        var key: Data
    }
    
    var iv = Data(count: AES.blockSize)
    var config: EncryptionShaper.Config
    
    /// Required to create EncryptionSHaper instance
    /// - parameter key: AES-256, needs to be 32 bytes
    public init?(config: EncryptionShaper.Config)
    {
        if config.key.count != 32
        {
            return nil
        }
        
        self.config = config
    }
    
    func encrypt(buffer: Data) -> Data?
    {
        do
        {
            let ctr = CTR(iv: iv.bytes)
            let aes = try AES(key: config.key.bytes, blockMode: ctr, padding: .noPadding)
            let encrypted = try aes.encrypt(buffer.bytes)
            
            return Data(bytes: encrypted)
        }
        catch(let error)
        {
            print("\nFailed to encode buffer with provided key.")
            print("\(error)\n")
            return nil
        }
    }
    
    func decrypt(cipherText: Data) -> Data?
    {
        do
        {
            let ctr = CTR(iv: iv.bytes)
            let aes = try AES(key: config.key.bytes, blockMode: ctr, padding: .noPadding)
            let decrypted = try aes.decrypt(cipherText.bytes)
            return Data(bytes: decrypted)
        }
        catch
        {
            print("Unable to decrypt cipher text.")
            return nil
        }
    }
    
}

extension EncryptionShaper: Transformer
{
    /// Encrypt the packet contents with the symmetric key
    public func transform(buffer: Data) -> [Data]
    {
        if let transformed = encrypt(buffer: buffer)
        {
            return [transformed]
        }
        else
        {
            return []
        }
    }
    
    /// Decrypts the encrypted packet contents with the symmetric key
    public func restore(buffer: Data) -> [Data]
    {
        if let restored = decrypt(cipherText: buffer)
        {
            return [restored]
        }
        else
        {
            return []
        }
    }
    
    
}


/// Creates a sample (non-random) config, suitable for testing.
public func sampleEncryptionConfig() -> EncryptionShaper.Config
{
    let bytes = Data(count: 32)
    
    return EncryptionShaper.Config(key: bytes)
}







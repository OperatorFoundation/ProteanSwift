//
//  EncryptionShaper.swift
//  ProteanSwift
//
//  Created by Adelita Schule on 8/10/18.
//

import Foundation
import Security

let chunkSize = 16
let ivSize = 16

/// Accepted in serialised form by Configure().
struct EncryptionConfig
{
    var key: String
}

/// Creates a sample (non-random) config, suitable for testing.
func sampleEncryptionConfig() -> EncryptionConfig?
{
    /*
     var bytes = []byte{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
     hexHeader := hex.EncodeToString(bytes)
     return EncryptionConfig{Key: hexHeader}
     */
    
    let bytes = Data(bytes: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    
    guard let hexHeader = String(bytes: bytes, encoding: .utf16)
    else
    {
        return nil
    }
    
    return EncryptionConfig(key: hexHeader)
}

// A packet shaper that encrypts the packets with AES CBC.
struct EncryptionShaper
{
    var key = Data()
    
    init()
    {
        /*
        shaper := &EncryptionShaper{}
        config := sampleEncryptionConfig()
        jsonConfig, err := json.Marshal(config)
        if err != nil {
            return nil
        }
        
        shaper.Configure(string(jsonConfig))
        return shaper
        */
    }
    
    /** This method is required to implement the Transformer API.
    @param {[]byte} key Key to set, not used by this class.*/
    func setKey(key: Data)
    {
        
    }
    
    ///Configure the Transformer with the headers to inject and the headers to remove
    func configure(jsonConfig: String)
    {
        /*
         var config EncryptionConfig
         err := json.Unmarshal([]byte(jsonConfig), &config)
         if err != nil {
         fmt.Println("Encryption shaper requires key parameter")
         }
         
         shaper.ConfigureStruct(config)
         */
        
        /*
         func (shaper *EncryptionShaper) ConfigureStruct(config EncryptionConfig) {
         shaper.key = deserializeEncryptionConfig(config)
         }
         */
        
        var config: EncryptionConfig
    }
    
    /// Decode the key from string in the config information
    func decodeKey(from config: EncryptionConfig) -> Data
    {
        return deserializeEncryptionModel(model: config.key)
    }
    
    /// Decode the header from a string in the header model
    func deserializeEncryptionModel(model: String) -> Data
    {
        /*
         config, _ := hex.DecodeString(model)
         return config
         */
        
        let config = Data(string: model)
        return config
    }
    
    /// Inject header.
    /// This Transform performs the following steps:
    /// - Generate a new random CHUNK_SIZE-byte IV for every packet
    /// - Encrypt the packet contents with the random IV and symmetric key
    /// - Concatenate the IV and encrypted packet contents
    func transform(buffer: Data) -> [Data]
    {
        /*
         var iv = buffer[0:IV_SIZE]
         var ciphertext = buffer[IV_SIZE:]
         return [][]byte{decrypt(shaper.key, iv, ciphertext)}
         */
        
        var iv = buffer[0..<ivSize]
        var cipherText = buffer[ivSize...]
        
        //FIXME: Returns empty Data
        return [Data()]
    }
    
    /// No-op (we have no state or any resources to Dispose).
    func dispose()
    {
        
    }
    
}

func makeIV() -> Data?
{
    /*
     var randomBytes = make([]byte, IV_SIZE)
     rand.Read(randomBytes)
     return randomBytes
     */
    var bytes = [UInt8](repeating: 0, count: ivSize)
    let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
    if status == errSecSuccess
    {
        
        return Data(bytes: bytes)
    }
    else
    {
        return nil
    }
}

func encrypt(key: Data, iv: Data, buffer: Data) -> Data?
{
    /*
     var length []byte = encodeShort(uint16(len(buffer)))
     var remainder = (len(length) + len(buffer)) % CHUNK_SIZE
     var plaintext []byte
     if remainder == 0 {
     plaintext = append(length, buffer...)
     } else {
     var padding = make([]byte, CHUNK_SIZE-remainder)
     rand.Read(padding)
     plaintext = append(length, buffer...)
     plaintext = append(plaintext, padding...)
     }
     
     block, err := aes.NewCipher(key)
     if err != nil {
     return nil
     }
     
     var enc = cipher.NewCBCEncrypter(block, iv)
     
     var ciphertext []byte
     
     for x := 0; x < (len(plaintext) / CHUNK_SIZE); x++ {
     plainChunk := plaintext[x*CHUNK_SIZE : (x+1)*CHUNK_SIZE]
     cipherChunk := make([]byte, len(plainChunk))
     enc.CryptBlocks(cipherChunk, plainChunk)
     ciphertext = append(ciphertext, cipherChunk...)
     }
     
     return ciphertext
     */
    
    return nil
}

func decrypt(key: Data, iv: Data, cipherText: Data) -> Data?
{
    /*
     block, err := aes.NewCipher(key)
     if err != nil
     {
        return nil
     }
     
     var dec = cipher.NewCBCDecrypter(block, iv)
     var plaintext []byte
     
     for x := 0; x < (len(ciphertext) / CHUNK_SIZE); x++
     {
         cipherChunk := ciphertext[x*CHUNK_SIZE : (x+1)*CHUNK_SIZE]
         plainChunk := make([]byte, len(cipherChunk))
         dec.CryptBlocks(plainChunk, cipherChunk)
         plaintext = append(plaintext, plainChunk...)
     }
     
     lengthBytes := plaintext[0:2]
     length := decodeShort(lengthBytes)
     rest := plaintext[2:]
     
     if len(rest) > int(length)
     {
        return rest[0:length]
     }
     else
     {
        return rest
     }
     */
    
    return nil
}

func encodeShort(value: uint16) -> Data?
{
    /*
     buf := new(bytes.Buffer)
     err := binary.Write(buf, binary.BigEndian, value)
     if err != nil {
     fmt.Println("binary.Write failed:", err)
     }
     fmt.Printf("% x", buf.Bytes())
     
     return buf.Bytes()
     */
    
    return nil
}

func decodeShort(d: Data) -> uint16?
{
    /*
     var value uint16
     reader := bytes.NewReader(b)
     err := binary.Read(reader, binary.BigEndian, &value)
     if err != nil {
     fmt.Println("binary.Read failed:", err)
     }
     
     return value
     */
    
    return nil
}










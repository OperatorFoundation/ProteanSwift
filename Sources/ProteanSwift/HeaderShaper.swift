//
//  HeaderShaper.swift
//  ProteanSwift
//
//  Created by Adelita Schule on 8/10/18.
//

import Foundation
import Datable

// Creates a sample (non-random) config, suitable for testing.
func sampleHeaderConfig() -> HeaderConfig
{
    let buffer = Data(bytes: [139, 210, 37])
    let stringHeader = String(data: buffer, encoding: String.Encoding.utf16)
    let header = SerializedHeaderModel(header: stringHeader!)
    
    return HeaderConfig(addHeader: header, removHeader: header)
}

func newHeaderShaper() -> HeaderShaper?
{
    /*
     headerShaper := &HeaderShaper{}
     config := sampleHeaderConfig()
     jsonConfig, err := json.Marshal(config)
     if err != nil {
     return nil
     }
     
     headerShaper.Configure(string(jsonConfig))
     return headerShaper
     */
    
    let config = sampleHeaderConfig()
    return nil
}

/// Decode the header from a string in the header model
func deserializeModel(model: SerializedHeaderModel) -> HeaderModel?
{
    /*
     config, _ := hex.DecodeString(string(model.Header))
     return HeaderModel{Header: config}
     */
    guard let header = Data(base64Encoded: model.header)
    else
    {
        return nil
    }
    
    return HeaderModel(header: header)
}

/// Decode the headers from strings in the config information
func deserializeConfig(config: HeaderConfig) -> (addHeader: HeaderModel?, removeHeader: HeaderModel?)
{
    return(deserializeModel(model: config.addHeader), deserializeModel(model: config.removHeader))
}

/** Header models where the headers have been encoded as strings.
 This is used by the HeaderConfig argument passed to Configure().*/
struct SerializedHeaderModel
{
    /// Header encoded as a string.
    var header: String
}

/** Header models where the headers have been decoded as []bytes.
 This is used internally by the HeaderShaper.*/
struct HeaderModel
{
    var header: Data
}

/// Accepted in serialised form by Configure().
struct HeaderConfig
{
    /// Header that should be added to the beginning of each outgoing packet.
    var addHeader: SerializedHeaderModel
    
    /// Header that should be removed from each incoming packet.
    var removHeader: SerializedHeaderModel
}

/// An obfuscator that injects headers.
struct HeaderShaper
{
    /// Headers that should be added to the outgoing packet stream.
    var addHeader: HeaderModel
    
    /// Headers that should be removed from the incoming packet stream.
    var removeHeader: HeaderModel
    
    /// Configure the Transformer with the headers to inject and the headers to remove.
    func configure(jsonConfig: String)
    {
        /*
         var config HeaderConfig
         err := json.Unmarshal([]byte(jsonConfig), &config)
         if err != nil {
         fmt.Println("Header shaper requires addHeader and removeHeader parameters")
         }
         
         headerShaper.ConfigureStruct(config)
         */
    }
    
    func configureStruct(config: HeaderConfig)
    {
        //headerShaper.AddHeader, headerShaper.RemoveHeader = deserializeConfig(config)
    }
    
    /// Inject header.
    func transform(buffer: Data) -> Data
    {
        /*
         //    log.debug('->', arraybuffers.arrayBufferToHexString(buffer))
         //    log.debug('>>', arraybuffers.arrayBufferToHexString(
         //      arraybuffers.concat([this.addHeader_.header, buffer])
         //    ))
         return [][]byte{append(headerShaper.AddHeader.Header, buffer...)}
         */
        
        return self.addHeader.header
    }
    
    /// Remove injected header.
    func restore(buffer: Data) -> Data
    {
        /*
         //    log.debug('<-', arraybuffers.arrayBufferToHexString(buffer))
         headerLength := len(headerShaper.RemoveHeader.Header)
         header := buffer[0:headerLength]
         payload := buffer[headerLength:]
         
         if bytes.Equal(header, headerShaper.RemoveHeader.Header) {
         // Remove the injected header.
         //      log.debug('<<', arraybuffers.arrayBufferToHexString(payload))
         return [][]byte{payload}
         } else {
         // Injected header not found, so return the unmodified packet.
         //      log.debug('Header not found')
         return [][]byte{buffer}
         }
         */
        
        return buffer
    }
    
    /** This method is required to implement the Transformer API.
    @param {[]byte} key Key to set, not used by this class. */
    func setKey(key: Data)
    {
        //
    }
    
    /// No-op (we have no state or any resources to Dispose).
    func dispose()
    {
        //
    }
}










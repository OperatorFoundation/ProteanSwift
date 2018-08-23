//
//  HeaderShaper.swift
//  ProteanSwift
//
//  Created by Adelita Schule on 8/10/18.
//

import Foundation
import Datable

/// An obfuscator that injects headers.
public struct HeaderShaper
{
    /// Accepted in serialised form by Configure().
    public struct Config
    {
        /// Header that should be added to the beginning of each outgoing packet.
        var addHeader: Data
        
        /// Header that should be removed from each incoming packet.
        var removHeader: Data
    }
    
    var config: HeaderShaper.Config
    
    public init(config: HeaderShaper.Config)
    {
        self.config = config
    }

}


extension HeaderShaper: Transformer
{
    /// Inject header.
    public func transform(buffer: Data) -> [Data]
    {
        var newData = Data()
        newData.append(config.addHeader)
        newData.append(buffer)
        
        return [newData]
    }
    
    /// Remove injected header.
    public func restore(buffer: Data) -> [Data]
    {
        let headerLength = config.removHeader.count
        let header = Data(buffer[0..<headerLength])
        let payload = Data(buffer[headerLength...])
        
        if header == config.removHeader
        {
            // Remove the injected header.
            return [payload]
        }
        else
        {
            // Injected header not found, so return the unmodified packet.
            return [buffer]
        }
    }
}


func sampleHeaderConfig() -> HeaderShaper.Config
{
    // Creates a sample (non-random) config, suitable for testing.
    let header = Data(bytes: [139, 210, 37])
    let config = HeaderShaper.Config(addHeader: header, removHeader: header)
    
    return config
}







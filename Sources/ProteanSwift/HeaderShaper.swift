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
    /// One or both headers must not be nil.
    public struct Config
    {
        /// Header that should be added to the beginning of each outgoing packet.
        var addHeader: Data?
        
        /// Header that should be removed from each incoming packet.
        var removHeader: Data?
        
        public init(addHeader: Data?, removeHeader: Data?)
        {
            self.addHeader = addHeader
            self.removHeader = removeHeader
        }
    }
    
    public var config: HeaderShaper.Config
    
    public init?(config: HeaderShaper.Config)
    {
        guard config.addHeader != nil || config.removHeader != nil
        else
        {
            print("Received an empty header config.")
            return nil
        }
        
        self.config = config
    }

}


extension HeaderShaper: Transformer
{
    /// Inject header.
    public func transform(buffer: Data) -> [Data]
    {
        guard config.addHeader != nil
        else
        {
            // There is no header to add just return the unchanged buffer.
            return [buffer]
        }
        
        var newData = Data()
        newData.append(config.addHeader!)
        newData.append(buffer)
        
        return [newData]
    }
    
    /// Remove the injected header.
    public func restore(buffer: Data) -> [Data]
    {
        guard config.removHeader != nil
        else
        {
            // There is no header to remove, just return the unchanged buffer
            return [buffer]
        }
        
        let headerLength = config.removHeader!.count
        let header = Data(buffer[0..<headerLength])
        let payload = Data(buffer[headerLength...])
        
        guard header == config.removHeader
        else
        {
            // Injected header not found, so return the
            return [buffer]
        }
        
        // Return the payload without the injected header.
        return [payload]
    }
}


public func sampleHeaderConfig() -> HeaderShaper.Config
{
    // Creates a sample (non-random) config, suitable for testing.
    let header = Data(bytes: [139, 210, 37])
    let config = HeaderShaper.Config(addHeader: header, removeHeader: header)
    
    return config
}







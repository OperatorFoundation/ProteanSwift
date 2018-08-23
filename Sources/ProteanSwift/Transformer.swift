//
//  Transformer.swift
//  ProteanSwift
//
//  Created by Adelita Schule on 8/15/18.
//

import Foundation

protocol Transformer
{
    func transform(buffer: Data) -> [Data]
    
    func restore(buffer: Data) -> [Data]
}

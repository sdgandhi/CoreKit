//
//  Encodable+EncodeJson.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 14..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation


public extension Encodable {

    /**
     Converts an Encodable object to json data

     - returns: Data
     */
    public func encodeJson(dateStrategy: JSONEncoder.DateEncodingStrategy = .iso8601,
                           dataStrategy: JSONEncoder.DataEncodingStrategy = .base64,
                           floatStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .throw,
                           outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = dateStrategy
        encoder.dataEncodingStrategy = dataStrategy
        encoder.nonConformingFloatEncodingStrategy = floatStrategy
        encoder.outputFormatting = outputFormatting
        return try encoder.encode(self)
    }
}

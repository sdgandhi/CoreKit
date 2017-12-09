//
//  Data+DecodeJson.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
public extension Data {

    /**
     Converts a data object to a Decodable type.

     - returns: T: Decodable
     */
    public func decodeJson<T: Decodable>(dateStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
                                         dataStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                         floatStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateStrategy
        decoder.dataDecodingStrategy = dataStrategy
        decoder.nonConformingFloatDecodingStrategy = floatStrategy
        return try decoder.decode(T.self, from: self)
    }
}

//
//  Data+String.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation

public extension Data {

    /**
     Converts a data object to an utf8 string.

     - returns: The utf8 string or nil
     */
    public var utf8String: String {
        return String(decoding: self, as: UTF8.self)
    }
}

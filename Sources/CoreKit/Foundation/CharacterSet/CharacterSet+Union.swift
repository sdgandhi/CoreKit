//
//  CharacterSet+Union.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation

public extension CharacterSet {

    public static func + (lhs: CharacterSet, rhs: CharacterSet) -> CharacterSet {
        var charset = CharacterSet()
        charset.formUnion(lhs)
        charset.formUnion(rhs)
        return charset
    }
}

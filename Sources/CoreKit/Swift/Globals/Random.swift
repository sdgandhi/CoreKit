//
//  Random.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 12. 09..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
    import Darwin
#endif
#if os(Linux)
    import Glibc
#endif

public func rndm(to max: Int, from min: Int = 0) -> Int {
    #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    #endif
    #if os(Linux)
        let scaled = Double(rand()) / Double(RAND_MAX)
        return Int(Double(max - min + 1) * scaled) + min
    #endif
}

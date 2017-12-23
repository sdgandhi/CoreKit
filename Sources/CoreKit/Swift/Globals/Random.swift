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
        let scale = Double(arc4random()) / Double(UInt32.max)
    #endif
    #if os(Linux)
        let scale = Double(rand()) / Double(RAND_MAX)
    #endif
    var value = max - min
    let maximum = value.addingReportingOverflow(1)
    if maximum.overflow {
        value = Int.max
    }
    else {
        value = maximum.partialValue
    }
    let partial = Int(Double(value) * scale)
    let result = partial.addingReportingOverflow(min)
    if result.overflow {
        return partial
    }
    return result.partialValue
}

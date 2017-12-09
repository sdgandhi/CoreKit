//
//  FloatingPoint+ReduceAngle.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
    import Darwin
#endif
#if os(Linux)
    import Glibc
#endif

public extension FloatingPoint {

    // Reduce angle to within 0..360 degrees
    public var reduceAngle: Self {
        return self - 360 * floor(self / 360) as Self
    }

    // Reduce angle to within -180..+180 degrees
    public var reduceAngle180: Self {
        return self - 360 * floor(self / 360 + 1 / 2)
    }
}

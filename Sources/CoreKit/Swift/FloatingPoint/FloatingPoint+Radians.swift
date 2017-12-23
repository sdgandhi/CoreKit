//
//  FloatingPoint+Radians.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

public extension FloatingPoint {

    public var radians: Self {
        return self * .pi / 180
    }

    public var degrees: Self {
        return self * 180 / .pi
    }
}

//
//  FloatingPoint+Meters.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//


public extension FloatingPoint {

    public var metersToLatitude: Self {
        return self / 6_373_000
    }

    public var metersToLongitude: Self {
        return self / 5_602_900
    }
}

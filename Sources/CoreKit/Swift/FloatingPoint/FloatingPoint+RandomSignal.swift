//
//  FloatingPoint+RandomSignal.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//


public extension FloatingPoint {

    /**
     Randomly returns either 1.0 or -1.0.
     */
    public static var randomSignal: Self {
        return ((rndm(to: 1) == 1) ? 1.0 : -1.0) as! Self // swiftlint:disable:this force_cast
    }
}

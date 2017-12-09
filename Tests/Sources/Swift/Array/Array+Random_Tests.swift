//
//  Array+RandomTests.swift
//  CoreKit-iOS-Tests
//
//  Created by Tibor Bödecs on 2017. 09. 26..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import XCTest
@testable import CoreKit

class ArrayRandomTests: XCTestCase {
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
    func test() {
        let sample1: [String] = ["a", "b"]
        let sample2: [String] = []
        let random = sample1.random

        XCTAssert(random != nil)
        XCTAssert(sample2.random == nil)
        XCTAssert(random == Optional("a") || random == Optional("b"))
    }
#endif
}

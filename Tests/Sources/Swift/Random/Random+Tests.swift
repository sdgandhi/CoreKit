//
//  Random+Tests.swift
//  CoreKit-Tests
//
//  Created by Tibor Bödecs on 2017. 12. 09..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import XCTest
@testable import CoreKit


class RandomTests: XCTestCase {

    func testExample() {
        let max = 6
        let min = 1
        for _ in stride(from: 0, to: 100, by: 1) {
            let value = rndm(to: max, from: min)
            XCTAssert(value <= max && value >= min)
        }
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}

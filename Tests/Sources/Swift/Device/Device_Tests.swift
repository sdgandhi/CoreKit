//
//  DeviceTests.swift
//  CoreKit-Tests
//
//  Created by Tibor Bödecs on 2017. 09. 26..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import XCTest
@testable import CoreKit

class DeviceTests: XCTestCase {

    func test() {

        XCTAssert(Device.architecture == Device.Architecture.arch64)
    }
}

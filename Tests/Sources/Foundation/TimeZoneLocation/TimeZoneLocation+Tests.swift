//
//  TimeZoneLocation+Tests.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 14..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import XCTest
@testable import CoreKit

class TimeZoneLocationTests: XCTestCase {

#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
    func test() {

//        let s1 = Set(TimeZoneLocation.supportedLocations.map({ $0.identifier }))
//        let s2 = Set(TimeZone.knownTimeZoneIdentifiers)
//        print(s1.count)
//        print(s2.count)
//        print(s2.subtracting(s1))
//        print(s1.subtracting(s2))
//        print(TimeZone.abbreviationDictionary.keys)
//        print(TimeZone.knownTimeZoneIdentifiers.map { TimeZone(identifier: $0)!.abbreviation() })

        XCTAssert(true)
    }
#endif

}

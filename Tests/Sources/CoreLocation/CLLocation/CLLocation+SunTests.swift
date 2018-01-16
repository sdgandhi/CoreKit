//
//  CLLocation+SunTests.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 01. 16..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import XCTest
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
    import CoreLocation
#endif
@testable import CoreKit

class CLLocationSunTests: XCTestCase {

    #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
    func test() {

        let date = Date()
        let zone = TimeZoneLocation.local
        let location = CLLocation(latitude: zone.latitude, longitude: zone.longitude)

        print("------------")

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Budapest")
        formatter.dateStyle = .long
        formatter.timeStyle = .long

        for (key, value) in location.sunTimes(for: date) {
            print(key + ": " + formatter.string(from: value))
        }

        print("------------")

        XCTAssert(true)
    }
    #endif

}

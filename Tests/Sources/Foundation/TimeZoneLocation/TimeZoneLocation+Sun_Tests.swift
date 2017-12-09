//
//  TimeZoneLocation+SunTests.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 14..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import XCTest
@testable import CoreKit

class TimeZoneLocationSunTests: XCTestCase {
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
    func test() {
        // swiftlint:disable force_unwrapping
        let date = Date()
        let zone = TimeZoneLocation.local
        let sun = zone.sunData(date: date)

        let time = String(format: "%02d:%02d:%02d", date.hour, date.minute, date.second)
        let sunrise = String(format: "%02d:%02d:%02d",
                             sun.localSunrise.hour!,
                             sun.localSunrise.minute!,
                             sun.localSunrise.second!)
        let sunset = String(format: "%02d:%02d:%02d",
                            sun.localSunset.hour!,
                            sun.localSunset.minute!,
                            sun.localSunset.second!)

        print("------------")
        //print(TimeZone.knownTimeZoneIdentifiers.map { TimeZone(identifier: $0)!.abbreviation() })
        print(time)
        print(sunrise)
        print(sunset)
        print("------------")

        XCTAssert(true)
    }
#endif
}

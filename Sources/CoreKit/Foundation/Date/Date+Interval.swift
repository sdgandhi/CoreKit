//
//  Date+Interval.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation


public extension Date {

    public func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else {
            return 0
        }
        return end - start
    }
}

//
//  CLLocation+Bearing.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)

    import CoreLocation.CLLocation

    public extension CLLocation {

        // returns in radians
        public func bearing(to location: CLLocation) -> Double {

            let lat1 = self.coordinate.latitude.radians
            let lon1 = self.coordinate.longitude.radians
            let lat2 = location.coordinate.latitude.radians
            let lon2 = location.coordinate.longitude.radians

            let dLon = lon2 - lon1
            let y = sin(dLon) * cos(lat2)
            let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
            return atan2(y, x)
        }

    }
#endif

//
//  CLLocation+Sun.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 01. 16..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import CoreLocation

/**
 See
 http://stjarnhimlen.se/english.html
 https://github.com/erndev/EDSunriseSet
 https://github.com/braindrizzlestudio/BDAstroCalc
 
 https://en.wikipedia.org/wiki/Lists_of_time_zones
 https://www.timeanddate.com/sun/hungary/budapest
 https://www.timeanddate.com/time/zones/
 */
// moon rise / set
// moon phase %
// https://www.codeproject.com/Articles/100174/Calculate-and-Draw-Moon-Phase
// https://gist.github.com/Sahnil/1366421

//struct DateElement {
//    let year: Int
//    let month: Int
//    let day: Int
//
//    init(year: Int, month: Int, day: Int) {
//        self.year = year
//        self.month = month
//        self.day = day
//    }
//}

public extension CLLocation {

    /*
     signal:
     0 = sun rises/sets this day, times stored at rise and set
     +1 = sun above the specified "horizon" 24 hours
     rise set to time when the sun is at south,
     minus 12 hours while set is set to the south
     time plus 12 hours. "Day" length = 24 hours
     -1 = sun is below the specified "horizon" 24 hours
     "Day" length = 0 hours, rise and set are
     both set to the time when the sun is at south.
     */
    private struct SunData {
        let rise: Double
        let set: Double
        let signal: Int
    }

    //    /// Used for generating several of the possible sunrise / sunset times
    //    fileprivate enum Zenith: Double {
    //        case official = 90.83
    //        case civil = 96
    //        case nautical = 102
    //        case astronimical = 108
    //    }

    private func daysSince2000Jan0(_ y: Int, _ m: Int, _ d: Int) -> Int {
        return (367 * y - ((7 * (y + ((m + 9) / 12))) / 4) + (275 * m / 9) + d - 730_530)
    }

    private func GMST0(_ d: Double) -> Double {
        return ((180.0 + 356.047_0 + 282.940_4) + (0.985_600_258_5 + 4.70935e-5) * d).reduceAngle
    }

    private func sunposAtDay(_ d: Double, lon: inout Double, r: inout Double) {
        let M = (356.047_0 + 0.985_600_258_5 * d).reduceAngle
        let w = 282.940_4 + 4.70935e-5 * d
        let e = 0.016_709 - 1.151e-9 * d

        let E = M + e.degrees * sin(M.radians) * (1.0 + e * cos(M.radians))
        let x = cos(E.radians) - e
        let y = sqrt(1.0 - e * e) * sin(E.radians)
        r = sqrt(x * x + y * y)
        let v = atan2(y, x).degrees
        lon = v + w
        if lon >= 360.0 {
            lon -= 360.0
        }
    }

    private func sun_RA_decAtDay(_ d: Double, RA: inout Double, dec: inout Double, r: inout Double) {
        var lon: Double = 0

        self.sunposAtDay(d, lon: &lon, r: &r)

        let xs = r * cos(lon.radians)
        let ys = r * sin(lon.radians)
        let obl_ecl = 23.439_3 - 3.563E-7 * d
        let xe = xs
        let ye = ys * cos(obl_ecl.radians)
        let ze = ys * sin(obl_ecl.radians)
        RA = atan2(ye, xe).degrees
        dec = atan2(ze, sqrt(xe * xe + ye * ye)).degrees
    }

    private func calc(year: Int, month: Int, day: Int, lat: Double, lon: Double, altit: Double, upper_limb: Int) -> SunData {
        var rc = 0
        var sRA: Double = 0
        var sdec: Double = 0
        var sr: Double = 0
        var t: Double = 0
        let d = Double(self.daysSince2000Jan0(year, month, day)) + 0.5 - lon / 360.0
        let sidtime = (self.GMST0(d) + 180.0 + lon).reduceAngle

        self.sun_RA_decAtDay(d, RA: &sRA, dec: &sdec, r: &sr)

        let tsouth = 12.0 - (sidtime - sRA).reduceAngle180 / 15.0
        let sradius = 0.266_6 / sr

        var alt = altit
        if upper_limb == 1 {
            alt -= sradius
        }

        let cost = (sin(alt.radians) - sin(lat.radians) * sin(sdec.radians)) / (cos(lat.radians) * cos(sdec.radians))
        if cost >= 1.0 {
            rc = -1
            t = 0.0
        }
        else if cost <= -1.0 {
            rc = +1
            t = 12.0
        }
        else {
            t = acos(cost).degrees / 15.0
        }

        return SunData(rise: tsouth - t, set: tsouth + t, signal: rc)
    }

    // utc time
    public func sunTimes(for date: Date) -> [String: Date] {
        let lat = self.coordinate.latitude
        let lon = self.coordinate.longitude

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbrevation: .utc)

        let dcs = calendar.dateComponents([.year, .month, .day], from: date)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let newDate = calendar.date(from: dcs)! //swiftlint:disable:this force_unwrapping

        let official = self.calc(year: year, month: month, day: day, lat: lat, lon: lon, altit: (-35.0 / 60.0), upper_limb: 1)
        let officialRise = newDate.addingTimeInterval(official.rise * .hour)
        let officialSet = newDate.addingTimeInterval(official.set * .hour)

        let civil = self.calc(year: year, month: month, day: day, lat: lat, lon: lon, altit: -6.0, upper_limb: 0)
        let civilRise = newDate.addingTimeInterval(civil.rise * .hour)
        let civilSet = newDate.addingTimeInterval(civil.set * .hour)

        let nautical = self.calc(year: year, month: month, day: day, lat: lat, lon: lon, altit: -12.0, upper_limb: 0)
        let nauticalRise = newDate.addingTimeInterval(nautical.rise * .hour)
        let nauticalSet = newDate.addingTimeInterval(nautical.set * .hour)

        let astronomical = self.calc(year: year, month: month, day: day, lat: lat, lon: lon, altit: -18.0, upper_limb: 0)
        let astronomicalRise = newDate.addingTimeInterval(astronomical.rise * .hour)
        let astronomicalSet = newDate.addingTimeInterval(astronomical.set * .hour)

        return [
            "official-sunrise": officialRise,
            "official-sunset": officialSet,
            "civil-sunrise": civilRise,
            "civil-sunset": civilSet,
            "nautical-sunrise": nauticalRise,
            "nautical-sunset": nauticalSet,
            "astronomical-sunrise": astronomicalRise,
            "astronomical-sunset": astronomicalSet
        ]
    }
}
#endif

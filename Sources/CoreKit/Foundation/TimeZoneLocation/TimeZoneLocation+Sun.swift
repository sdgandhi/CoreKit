//
//  TimeZoneLocation+Sun.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation

public extension TimeZone {

    public static var utc: TimeZone {
        return TimeZone(abbreviation: "UTC")! // swiftlint:disable:this force_unwrapping
    }
}

public extension TimeZoneLocation {

    public func sunData(date: Date) -> SunriseSunsetData {
        return SunriseSunsetData(date: date, timeZoneLocation: self)
    }
}

/**
 See
 http://stjarnhimlen.se/english.html
 https://github.com/erndev/EDSunriseSet
 https://github.com/braindrizzlestudio/BDAstroCalc
 https://github.com/FriskyElectrocat/FESSolarCalculator
 https://github.com/ceek/solar
 https://en.wikipedia.org/wiki/Julian_day
 https://www.timeanddate.com/time/zones/
 https://en.wikipedia.org/wiki/Lists_of_time_zones
 https://www.timeanddate.com/sun/hungary/budapest
 */
public class SunriseSunsetData {

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
    struct SunData {
        let rise: Double
        let set: Double
        let signal: Int
    }

    private let date: Date
    private let timeZoneLocation: TimeZoneLocation

    public var sunset: Date!
    public var sunrise: Date!
    public var civilTwilightStart: Date!
    public var civilTwilightEnd: Date!
    public var nauticalTwilightStart: Date!
    public var nauticalTwilightEnd: Date!
    public var astronomicalTwilightStart: Date!
    public var astronomicalTwilightEnd: Date!

    public var localSunrise: DateComponents!
    public var localSunset: DateComponents!
    public var localCivilTwilightStart: DateComponents!
    public var localCivilTwilightEnd: DateComponents!
    public var localNauticalTwilightStart: DateComponents!
    public var localNauticalTwilightEnd: DateComponents!
    public var localAstronomicalTwilightStart: DateComponents!
    public var localAstronomicalTwilightEnd: DateComponents!

    public init(date: Date, timeZoneLocation: TimeZoneLocation) {
        self.date = date
        self.timeZoneLocation = timeZoneLocation

        self.calculate()
    }

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

    func calc(year: Int, month: Int, day: Int, lat: Double, lon: Double, altit: Double, upper_limb: Int) -> SunData {
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

    func basic(year: Int, month: Int, day: Int, lat: Double, lon: Double) -> SunData {
        return self.calc(year: year, month: month, day: day, lat: lat, lon: lon, altit: (-35.0 / 60.0), upper_limb: 1)
    }

    func civil(year: Int, month: Int, day: Int, lat: Double, lon: Double) -> SunData {
        return self.calc(year: year, month: month, day: day, lat: lat, lon: lon, altit: -6.0, upper_limb: 0)
    }

    func nautical(year: Int, month: Int, day: Int, lat: Double, lon: Double) -> SunData {
        return self.calc(year: year, month: month, day: day, lat: lat, lon: lon, altit: -12.0, upper_limb: 0)
    }

    func astronomical(year: Int, month: Int, day: Int, lat: Double, lon: Double) -> SunData {
        return self.calc(year: year, month: month, day: day, lat: lat, lon: lon, altit: -18.0, upper_limb: 0)
    }

    private func utcTime(_ dateComponents: DateComponents, interval: TimeInterval) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = .utc
        // swiftlint:disable:next force_unwrapping
        return calendar.date(from: dateComponents)!.addingTimeInterval(interval)
    }

    private func localTime(_ fromDate: Date) -> DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = self.timeZoneLocation.timezone
        return calendar.dateComponents([.hour, .minute, .second], from: fromDate)
    }

    private func calculate() {
        var calendar = Calendar.current
        calendar.timeZone = self.timeZoneLocation.timezone

        let dcs = calendar.dateComponents([.year, .month, .day], from: self.date)
        let year = dcs.year! // swiftlint:disable:this force_unwrapping
        let month = dcs.month! // swiftlint:disable:this force_unwrapping
        let day = dcs.day! // swiftlint:disable:this force_unwrapping

        let basic = self.basic(year: year,
                               month: month,
                               day: day,
                               lat: self.timeZoneLocation.latitude,
                               lon: self.timeZoneLocation.longitude)

        self.sunrise = self.utcTime(dcs, interval: basic.rise * TimeInterval.hour)
        self.sunset = self.utcTime(dcs, interval: basic.set * TimeInterval.hour)
        self.localSunrise = self.localTime(self.sunrise)
        self.localSunset = self.localTime(self.sunset)

        let civil = self.civil(year: year,
                               month: month,
                               day: day,
                               lat: self.timeZoneLocation.latitude,
                               lon: self.timeZoneLocation.longitude)

        self.civilTwilightStart = self.utcTime(dcs, interval: civil.rise * TimeInterval.hour)
        self.civilTwilightEnd = self.utcTime(dcs, interval: civil.set * TimeInterval.hour)
        self.localCivilTwilightStart = self.localTime(self.civilTwilightStart)
        self.localCivilTwilightEnd = self.localTime(self.civilTwilightEnd)

        let nautical = self.nautical(year: year,
                                     month: month,
                                     day: day,
                                     lat: self.timeZoneLocation.latitude,
                                     lon: self.timeZoneLocation.longitude)

        self.nauticalTwilightStart = self.utcTime(dcs, interval: nautical.rise * TimeInterval.hour)
        self.nauticalTwilightEnd = self.utcTime(dcs, interval: nautical.set * TimeInterval.hour)
        self.localNauticalTwilightStart = self.localTime(self.nauticalTwilightStart)
        self.localNauticalTwilightEnd = self.localTime(self.nauticalTwilightEnd)

        let astronomical = self.astronomical(year: year,
                                             month: month,
                                             day: day,
                                             lat: self.timeZoneLocation.latitude,
                                             lon: self.timeZoneLocation.longitude)

        self.astronomicalTwilightStart = self.utcTime(dcs, interval: astronomical.rise * TimeInterval.hour)
        self.astronomicalTwilightEnd = self.utcTime(dcs, interval: astronomical.set * TimeInterval.hour)
        self.localAstronomicalTwilightStart = self.localTime(self.astronomicalTwilightStart)
        self.localAstronomicalTwilightEnd = self.localTime(self.astronomicalTwilightEnd)
    }
}

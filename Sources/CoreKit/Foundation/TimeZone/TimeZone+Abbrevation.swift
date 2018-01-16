//
//  TimeZone+Abbrevation.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 01. 16..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import Foundation

public extension TimeZone {

    public enum Abbrevation: String {
        case cest
        case cdt
        case eet
        case cet
        case kst
        case clt
        case hst
        case cst
        case cat
        case brt
        case jst
        case gst
        case pht
        case bst
        case pst
        case art
        case wat
        case est
        case bdt
        case trt
        case clst
        case akst
        case pkt
        case ict
        case msk
        case eat
        case west
        case brst
        case eest
        case msd
        case mst
        case nzdt
        case pet
        case nst
        case ndt
        case mdt
        case nzst
        case cot
        case wet
        case sgt
        case ist
        case hkt
        case utc
        case edt
        case wit
        case irst
        case akdt
        case pdt
        case adt
        case ast
        case gmt
    }

    public init(abbrevation: TimeZone.Abbrevation) {
        self.init(abbreviation: abbrevation.rawValue.uppercased())! //swiftlint:disable:this force_unwrapping
    }
}

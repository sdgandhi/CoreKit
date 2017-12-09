//
//  String+JsonMinifiedTests.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 14..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import XCTest
@testable import CoreKit

class StringJsonMinifiedTests: XCTestCase {

#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)

    func test1() {

        let str1 = """
            // this is a JSON file with comments
            {
                "foo": "bar",    // this is cool
                "bar": [
                "baz", "bum", "zam"
                ],
                /* the rest of this document is just fluff
                 in case you are interested. */
                "something": 10,
                "else": 20
            }

            /* NOTE: You can easily strip the whitespace and comments
             from such a file with the JSON.minify() project hosted
             here on github at http://github.com/getify/JSON.minify
             */
            """

        let res1 = """
            {"foo":"bar","bar":["baz","bum","zam"],"something":10,"else":20}
            """

        XCTAssert(str1.jsonMinified == res1)
    }

    func test2() {
        let str2 = """
            {"/*":"*/","//":"",/*"//"*/"/*/"://
                "//"}
            """

        let res2 = """
            {"/*":"*/","//":"","/*/":"//"}
            """

        XCTAssert(str2.jsonMinified == res2)
    }

    func test3() {
        let str3 = """
            /*
             this is a
             multi line comment */{

                "foo"
                :
                "bar/*"// something
                ,    "b\\"az":/*
                 something else */"blah"

            }
            """

        let res3 = """
            {"foo":"bar/*","b\\"az":"blah"}
            """

        XCTAssert(str3.jsonMinified == res3)
    }

    func test4() {
        let str4 = """
            {"foo": "ba\\"r//", "bar\\\\": "b\\\\\\"a/*z",
                "baz\\\\\\\\": /* yay */ "fo\\\\\\\\\\"*/o"
            }
            """

        let res4 = """
            {"foo":"ba\\"r//","bar\\\\":"b\\\\\\"a/*z","baz\\\\\\\\":"fo\\\\\\\\\\"*/o"}
            """

        XCTAssert(str4.jsonMinified == res4)

        let str5 = ""
        let res5 = ""

        XCTAssert(str5.jsonMinified == res5)
    }

#endif
}

//
//  String+JsonMinified.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 14..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation

/**
 http://github.com/getify/JSON.minify
 */
public extension String {
    // swiftlint:disable force_unwrapping
    public var jsonMinified: String {

        var result: [String]  = []
        var inString = false
        var inComment = false
        var inLineComment = false
        var index = 0
        var right = ""
        // swiftlint:disable:next force_try
        let backslash = try! NSRegularExpression(pattern: "(\\\\)*$", options: [.caseInsensitive])
        // swiftlint:disable:next force_try
        let tokenizer = try! NSRegularExpression(pattern: "\"|(\\/\\*)|(\\*\\/)|(\\/\\/)|\n|\r",
                                                 options: [.caseInsensitive]) //strings, comments, newlines
        let matches = tokenizer.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))

        guard !matches.isEmpty else {
            return self
        }

        for match in matches {
            let range = match.range
            let token = self.substring(with: range)!

            let lastIndex = range.location + range.length

            let left = self.substring(with: NSRange(location: 0, length: range.location))!
            right = self.substring(with: NSRange(location: lastIndex, length: self.count - lastIndex))!

            if !inComment && !inLineComment {
                var tmp2 = left.substring(with: NSRange(location: index, length: left.count - index))!

                if !inString {
                    let words = tmp2.components(separatedBy: .whitespacesAndNewlines)
                    tmp2 = words.joined()
                }
                result.append(tmp2)
            }
            index = lastIndex

            if token.hasPrefix("\"") && !inComment && !inLineComment {
                //swiftlint:disable:next line_length
                let _matches = backslash.matches(in: left, options: [], range: NSRange(location: 0, length: left.count))
                if !_matches.isEmpty && ( !inString || _matches.first!.range.length % 2 == 0 ) {
                    inString = !inString
                }
                index -= 1
                right = self.substring(with: NSRange(location: index, length: self.count - index))!

            }
            else if token.hasPrefix("/*") && !inString && !inComment && !inLineComment {
                inComment = true
            }
            else if token.hasPrefix("*/") && !inString && inComment && !inLineComment {
                inComment = false
            }
            else if token.hasPrefix("//") && !inString && !inComment && !inLineComment {
                inLineComment = true
            }
            else if (token.hasPrefix("\n") || token.hasPrefix("\r")) && !inString && !inComment && inLineComment {
                inLineComment = false
            }
            else if !inComment && !inLineComment {
                result.append(token.components(separatedBy: .newlines).joined())
            }
        }

        result.append(right)

        return result.joined()
    }
}

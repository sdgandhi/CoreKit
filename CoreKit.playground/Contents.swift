//: Playground - noun: a place where people can play

import Foundation
import ObjectiveC

let str = "Hello, playground"
let index = str.index(str.startIndex, offsetBy: 1)
let newStr = str[index..<str.endIndex]
let newStr2 = str[..<index]

let s = "e\u{301}galite\u{301}"           // "égalité"
let i = Array(s.unicodeScalars.indices)

s[i[1]...]
s[..<i.last!]
s[i[1]]
s[i[1]..<i[4]]


extension RawRepresentable where Self.RawValue: Hashable {
    
    static var allValues: [Self] {
        let sequence = AnySequence { () -> AnyIterator<Self> in
            var index = 0
            return AnyIterator {
                let current = withUnsafePointer(to: &index) { unsafePointer in
                    unsafePointer.withMemoryRebound(to: Self.self, capacity: 1) { unsafePointer in
                        unsafePointer.pointee
                    }
                }
                guard current.rawValue.hashValue == index else {
                    return nil
                }
                index += 1
                return current
            }
        }
        return Array(sequence)
    }
}

enum HEHE: Int {
    case a,b,c,d
    
}

HEHE.allValues

enum HAHA: String {
    
    case a,b,c,d
}

HAHA.allValues

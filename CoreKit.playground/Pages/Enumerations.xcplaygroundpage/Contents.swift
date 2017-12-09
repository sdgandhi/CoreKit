//: [Previous](@previous)

enum Test {
    case a, b, c
}

let mr = Mirror(reflecting: Test.a)

mr.superclassMirror?.description
mr.children.flatMap { $0.label }
mr.description
mr.displayStyle
mr.subjectType

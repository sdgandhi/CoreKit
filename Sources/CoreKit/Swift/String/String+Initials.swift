//
//  String+Initials.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

public extension String {

    /**
     Returns the initials from a given string (first letter from the first and last words)

     - returns: The initials from the string
     */
    public var initials: String {
        // swiftlint:disable:next force_unwrapping
        return self.split(separator: " ").map { String($0.first!) }.joined()
    }

}

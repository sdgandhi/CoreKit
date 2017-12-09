//
//  String+Substring.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 14..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation


public extension String {

    public func substring(with range: NSRange) -> String? {
        guard let range = Range(range, in: self) else {
            return nil
        }
        return String(self[range])
    }
}

//
//  String+Data.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 30..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation

public extension String {

    public var utf8Data: Data {
        return Data(self.utf8)
    }
}

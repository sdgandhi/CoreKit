//
//  Array+Random.swift
//  CoreKit-iOS
//
//  Created by Tibor Bödecs on 2017. 09. 26..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

public extension Array {

    /**
     Returns a random element from the array

     - returns: Random element from the array or nil if the array is empty
     */
    public var random: Element? {
        guard !self.isEmpty else {
            return nil
        }
        return self[rndm(to: self.count - 1)]
    }
}

//
//  CGFloat+EvenRounded.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 03. 15..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    
    import CoreGraphics

    extension CGFloat {

        public var evenRounded: CGFloat {
            var newValue = self.rounded(.towardZero)
            if newValue.truncatingRemainder(dividingBy: 2) == 1 {
                newValue -= 1
            }
            return newValue
        }
    }

#endif


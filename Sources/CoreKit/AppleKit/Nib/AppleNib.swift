//
//  AppleNib.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//


#if os(macOS) || os(iOS) || os(tvOS)
    
    #if os(macOS)
        import AppKit.NSNib
        public typealias AppleNib = NSNib
    #else
        import UIKit.UINib
        public typealias AppleNib = UINib
    #endif

#endif

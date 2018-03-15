//
//  AppleEdgeInsets+Setters.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 03. 15..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//


#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    
    import CoreGraphics
    
    public extension AppleEdgeInsets {
                
        public mutating func setAll(_ size: CGFloat) {
            self.top = size
            self.left = size
            self.bottom = size
            self.right = size
        }
        
        public mutating func setVertical(_ size: CGFloat) {
            self.top = size
            self.bottom = size
        }
        
        public mutating func setHorizontal(_ size: CGFloat) {
            self.left = size
            self.right = size
        }
    }
    
#endif

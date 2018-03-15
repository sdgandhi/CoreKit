//
//  AppleEdgeInsets+Init.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)

    import CoreGraphics

    public extension AppleEdgeInsets {

        public static func top(_ size: CGFloat) -> AppleEdgeInsets {
            return AppleEdgeInsets(top: size, left: 0, bottom: 0, right: 0)
        }

        public static func left(_ size: CGFloat) -> AppleEdgeInsets {
            return AppleEdgeInsets(top: 0, left: size, bottom: 0, right: 0)
        }

        public static func bottom(_ size: CGFloat) -> AppleEdgeInsets {
            return AppleEdgeInsets(top: 0, left: 0, bottom: size, right: 0)
        }

        public static func right(_ size: CGFloat) -> AppleEdgeInsets {
            return AppleEdgeInsets(top: 0, left: 0, bottom: 0, right: size)
        }

        public static func vertical(_ size: CGFloat) -> AppleEdgeInsets {
            return AppleEdgeInsets(top: size, left: 0, bottom: size, right: 0)
        }

        public static func horizontal(_ size: CGFloat) -> AppleEdgeInsets {
            return AppleEdgeInsets(top: 0, left: size, bottom: 0, right: size)
        }

        public static func all(_ size: CGFloat) -> AppleEdgeInsets {
            return AppleEdgeInsets(top: size, left: size, bottom: size, right: size)
        }
        
        #if os(macOS)
        public static var zero: AppleEdgeInsets {
            return AppleEdgeInsets.all(0)
        }
        #endif
    }
    
    

#endif

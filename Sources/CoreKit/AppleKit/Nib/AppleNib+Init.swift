//
//  AppleNib+Init.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 12..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS)

    /**
     Common init for both platforms
     */
    public extension AppleNib {

        convenience init(nib: AppleNib.Identifier, bundle: AppleBundle? = .main) {
            #if os(macOS)
                // swiftlint:disable:next force_unwrapping
                self.init(nibNamed: nib.rawValue, bundle: bundle)!
            #else
                self.init(nibName: nib.rawValue, bundle: bundle)
            #endif
        }
    }

    /**
     Nib protocol for loading nibs
     */
    public protocol Nib {
        static var nib: AppleNib? { get }
    }
    /**
     Default implementation for loading nibs.
     */
    extension Nib where Self: UniqueIdentifier {
        public static var nib: AppleNib? { return AppleNib(nib: AppleNib.Identifier(self)) }
    }

    /**
     Now let's do a really "interesting" thing... maybe this should only apply for views & controllers?
     */
    extension AppleObject: Nib {}

#endif

//
//  AppleView+Init.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 28..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS)

    /**
     AppleView extension to easily create views supporting autolayout
     */
    public extension AppleView {

        /**
         Convenience init method
         
         - parameter autolayout: autoresizing masks will be disabled if true
         - returns: An initialized view object
         */
        public convenience init(autolayout: Bool) {
            self.init(frame: .zero)

            self.translatesAutoresizingMaskIntoConstraints = !autolayout
        }

        /**
         It creates a new view object
         
         - parameter autolayout: autoresizing masks will be disabled if true
         - returns: An initialized view object
         */
        public static func create(autolayout: Bool = true) -> Self {
            let _self = self.init()
            let view = _self as AppleView
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return _self
        }

        /**
         It creates a new view object from a nib file
         
         - parameter owner: The owner of the nib 
         - parameter options: Options for loading the nib
         - returns: An initialized view object
         */
        public static func createFromNib(owner: Any? = nil, options: [AnyHashable: Any]? = nil) -> AppleView {
            let name = String(describing: self)
            // swiftlint:disable:next force_cast
            return AppleBundle.main.loadNibNamed(name, owner: owner, options: options)?.last as! AppleView
        }

    }

#endif

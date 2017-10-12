//
//  AppleViewController+Init.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 12..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS)
    
    public extension AppleViewController {

        public convenience init(nib: AppleNib.Identifier, bundle: AppleBundle = .main) {
            self.init(nibName: nib.rawValue, bundle: bundle)
        }
    }

#endif

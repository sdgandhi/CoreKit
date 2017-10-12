//
//  AppleNib+Identifier.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 12..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS)
 
    public extension AppleNib {
        
        public enum Identifier: RawRepresentable {
            case custom(RawValue)
            
            #if os(macOS)
            public typealias RawValue = AppleNib.Name
            #else
            public typealias RawValue = String
            #endif
            
            public init(_ object: UniqueIdentifier.Type) {
                #if os(macOS)
                    self.init(rawValue: AppleNib.Name(rawValue: object.uniqueIdentifier))!
                #else
                    self.init(rawValue: object.uniqueIdentifier)!
                #endif
            }
            
            public init?(rawValue: RawValue) {
                self = .custom(rawValue)
            }
            
            public var rawValue: RawValue {
                switch self {
                case .custom(let object): return object
                }
            }
        }
    }

#endif


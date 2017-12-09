//
//  AppleCollectionViewItem+Kind.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 12..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS)

    /**
     Kind
     */
    public extension AppleCollectionViewItem {

        public enum Kind: RawRepresentable {
            #if os(macOS)
            public typealias RawValue = AppleCollectionView.SupplementaryElementKind
            #else
            public typealias RawValue = String
            #endif

            case header
            case footer
            case custom(String)

            #if os(macOS)
            public init?(rawValue: RawValue) {
                switch rawValue {
                case AppleCollectionView.SupplementaryElementKind.sectionHeader:
                    self = .header
                case AppleCollectionView.SupplementaryElementKind.sectionFooter:
                    self = .footer
                default:
                    self = .custom(rawValue.rawValue)
                }
            }

            public var rawValue: RawValue {
                switch self {
                case .header:
                    return AppleCollectionView.SupplementaryElementKind.sectionHeader
                case .footer:
                    return AppleCollectionView.SupplementaryElementKind.sectionFooter
                case .custom(let string):
                    return AppleCollectionView.SupplementaryElementKind(rawValue: string)
                }
            }
            #else
            public init?(rawValue: RawValue) {
                switch rawValue {
                case AppleCollectionElementKindSectionHeader:
                    self = .header
                case AppleCollectionElementKindSectionFooter:
                    self = .footer
                default:
                    self = .custom(rawValue)
                }
            }

            public var rawValue: RawValue {
                switch self {
                case .header:
                    return AppleCollectionElementKindSectionHeader
                case .footer:
                    return AppleCollectionElementKindSectionFooter
                case .custom(let string):
                    return string
                }
            }
            #endif
        }
    }
#endif

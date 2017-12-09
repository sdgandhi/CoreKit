//
//  AppleFont+Family.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 28..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)

    #if os(macOS)
    import AppKit.NSFontManager
    #endif

    public extension AppleFont {

        public static var availableFamilies: [String] {
            #if os(macOS)
            return NSFontManager.shared.availableFontFamilies
            #else
            return AppleFont.familyNames
            #endif
        }

        public static func availableFonts(forFamilyName family: String) -> [String] {
            #if os(macOS)
            var names: [String] = []
            for member in NSFontManager.shared.availableMembers(ofFontFamily: family) ?? [] {
                if let name = member.first as? String {
                    names.append(name)
                }
            }
            return names
            #else
            return AppleFont.fontNames(forFamilyName: family)
            #endif
        }

        public static var availableFonts: [String] {
            return AppleFont.availableFamilies.flatMap { AppleFont.availableFonts(forFamilyName: $0) }
        }
    }

#endif

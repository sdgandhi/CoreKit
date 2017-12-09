//
//  SKNode+Unarchive.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)

    import SpriteKit.SKNode

    public extension SKNode {

        public static func unarchiveNode(file: String) -> SKNode? {

            guard
                let url = Bundle.main.url(forResource: file, withExtension: "sks"),
                let sceneData = try? Data(contentsOf: url, options: .mappedIfSafe)
                else {
                    return nil
            }

            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            // swiftlint:disable:next force_cast
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene

        }
    }
#endif

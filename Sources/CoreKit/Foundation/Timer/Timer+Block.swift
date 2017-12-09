//
//  Timer+Block.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)

    import Foundation.NSTimer

    public extension Timer {

        @discardableResult
        public static func scheduled(interval: TimeInterval, repeats: Bool, block: @escaping VoidBlock) -> Timer {
            let target = BlockOperation(block: block)
            let selector = #selector(BlockOperation.main)
            return Timer.scheduledTimer(timeInterval: interval,
                                        target: target,
                                        selector: selector,
                                        userInfo: nil,
                                        repeats: repeats)
        }

        @discardableResult
        public static func timeout(interval: TimeInterval, block: @escaping VoidBlock) -> Timer {
            return Timer.scheduled(interval: interval, repeats: false, block: block)
        }

        @discardableResult
        public static func interval(interval: TimeInterval, block: @escaping VoidBlock) -> Timer {
            return Timer.scheduled(interval: interval, repeats: true, block: block)
        }

    }
#endif

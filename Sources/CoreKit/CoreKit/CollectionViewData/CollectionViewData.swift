//
//  CollectionViewData.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 29..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS)

    import CoreGraphics.CGGeometry

    public protocol CollectionViewDataProtocol {

        var item: CollectionViewItem.Type { get }
        var value: Any { get }

        func config(item: CollectionViewItem, data: Any, indexPath: AppleIndexPath, grid: Grid)
        func size(data: Any, indexPath: AppleIndexPath, grid: Grid, view: AppleView) -> CGSize
        func callback(data: Any, indexPath: AppleIndexPath) -> Bool
    }

    open class CollectionViewData<Item, Data>: CollectionViewDataProtocol where Item: CollectionViewItem, Data: Any {

        public typealias ConfigBlock = (Item, Data, AppleIndexPath, Grid) -> Void
        public typealias SizeBlock = (Data, AppleIndexPath, Grid, AppleView) -> CGSize
        public typealias CallbackBlock = (Data, AppleIndexPath) -> Bool

        public var item: CollectionViewItem.Type { return Item.self }
        public var value: Any { return self.data }

        public var data: Data
        public var configBlock: ConfigBlock?
        public var sizeBlock: SizeBlock?
        public var callbackBlock: CallbackBlock?

        public init(_ data: Data, config: ConfigBlock? = nil, size: SizeBlock? = nil, callback: CallbackBlock? = nil) {
            self.data = data
            self.configBlock = config
            self.sizeBlock = size
            self.callbackBlock = callback

            self.initialize()
        }
        
        open func initialize() {

        }

        public func config(item: CollectionViewItem, data: Any, indexPath: AppleIndexPath, grid: Grid) {
            guard let data = data as? Data, let item = item as? Item else {
                return
            }
            if let config = self.configBlock {
                return config(item, data, indexPath, grid)
            }
            return self.config(item: item, data: data, indexPath: indexPath, grid: grid)
        }

        open func config(item: Item, data: Data, indexPath: AppleIndexPath, grid: Grid) {

        }

        public func size(data: Any, indexPath: AppleIndexPath, grid: Grid, view: AppleView) -> CGSize {
            guard let data = data as? Data else {
                return .zero
            }
            if let callback = self.sizeBlock {
                return callback(data, indexPath, grid, view)
            }
            return self.size(data: data, indexPath: indexPath, grid: grid, view: view)
        }

        open func size(data: Data, indexPath: AppleIndexPath, grid: Grid, view: AppleView) -> CGSize {
            return .zero
        }

        public func callback(data: Any, indexPath: AppleIndexPath) -> Bool {
            guard let data = data as? Data else {
                return false
            }
            if let callback = self.callbackBlock {
                return callback(data, indexPath)
            }
            return self.callback(data: data, indexPath: indexPath)
        }

        open func callback(data: Data, indexPath: AppleIndexPath) -> Bool {
            return false
        }
    }

#endif

//
//  TableViewData.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 01. 28..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

#if os(iOS)
    import Foundation
    import UIKit
    
    public protocol TableViewDataProtocol {
        var item: UITableViewCell.Type { get }
        var value: Any { get }
        
        func config(item: UITableViewCell, data: Any, indexPath: IndexPath)
        func callback(data: Any, indexPath: IndexPath)
        func height(data: Any, indexPath: IndexPath) -> CGFloat
    }
    
    open class TableViewData<Item, Data>: TableViewDataProtocol where Item: UITableViewCell, Data: Any {
        
        public var item: UITableViewCell.Type { return Item.self }
        public var value: Any { return self.data }
        
        public var data: Data
        
        
        public init(data: Data) {
            self.data = data
        }
        
        public func config(item: UITableViewCell, data: Any, indexPath: IndexPath) {
            guard let item = item as? Item, let data = data as? Data else {
                return
            }
            self.config(item: item , data: data, indexPath: indexPath)
        }
        
        open func config(item: Item, data: Data, indexPath: IndexPath) {
            
        }
        
        public func callback(data: Any, indexPath: IndexPath) {
            guard let data = data as? Data else {
                return
            }
            self.callback(data: data, indexPath: indexPath)
        }
        
        open func callback(data: Data, indexPath: IndexPath) {
            
        }
        
        public func height(data: Any, indexPath: IndexPath) -> CGFloat {
            guard let data = data as? Data else {
                return 44
            }
            return self.height(data: data, indexPath: indexPath)
        }
        
        open func height(data: Data, indexPath: IndexPath) -> CGFloat {
            return 44
        }
    }
    
#endif


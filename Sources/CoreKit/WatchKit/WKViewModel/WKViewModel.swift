//
//  WKViewModel.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 01. 28..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

#if os(watchOS)

    import Foundation

    public protocol WKViewModelProtocol {
        var type: String { get }
        func configure(item: Any)
        func callback(index: Int)
    }

    open class ViewModel<View, Model>: WKViewModelProtocol where View: WKInterfaceTableItem, Model: Any {
        
        public var type: String { return View.objectName }
        public var view: View.Type { return View.self }
        public var model: Model
        public var callbackBlock: ((Int, Model) -> Void)?

        public init(_ model: Model, callback: ((Int, Model) -> Void)? = nil) {
            self.model = model
            self.callbackBlock = callback
        }
        
        public func configure(item: Any) {
            guard let cell = item as? View else {
                return
                
            }
            self.configure(view: cell, model: self.model)
        }
        
        open func configure(view: View, model: Model) {
            
        }
        
        public func callback(index: Int) {
            self.callback(index: index, model: self.model)
        }
        
        open func callback(index: Int, model: Model) {
            self.callbackBlock?(index, model)
        }
    }

#endif

//
//  WKInterfaceTableDataSource.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 01. 28..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

#if os(watchOS)

    import Foundation
    import WatchKit
 
    open class WKInterfaceTableDataSource {

        open var viewModels: [WKViewModelProtocol]
        public weak var table: WKInterfaceTable?
        
        public init(_ table: WKInterfaceTable, viewModels: [WKViewModelProtocol] = []) {
            self.table = table
            self.viewModels = viewModels
            
            self.initialize()
        }
        
        open func initialize() {
            
        }

        public func reloadData() {
            self.table?.setRowTypes(self.viewModels.map { $0.type })
            for (index, data) in self.viewModels.enumerated() {
                if let row = self.table?.rowController(at: index) {
                    data.configure(item: row)
                }
            }
        }

        public func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
            let viewModel = self.viewModels[rowIndex]
            viewModel.callback(index: rowIndex)
        }
    }

#endif

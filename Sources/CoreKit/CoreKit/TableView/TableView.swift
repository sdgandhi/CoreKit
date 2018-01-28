//
//  TableView.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 01. 28..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

#if os(iOS)
    import Foundation
    import UIKit

    open class TableView: UITableView {
        
        var source: TableViewSource! {
            didSet {
                self.source.register(tableView: self)
                
                self.dataSource = self.source
                self.delegate = self.source
            }
        }
        
        public override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame: frame, style: style)
        }
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }

#endif

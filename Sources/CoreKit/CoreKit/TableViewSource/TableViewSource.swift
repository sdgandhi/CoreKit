//
//  TableViewSource.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 01. 28..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

#if os(iOS)
    import Foundation
    import UIKit
    
    class TableViewSource: NSObject {
        var sections: [TableViewSection] = []
        
        func register(tableView: UITableView) {
            for section in self.sections {
                for item in section.items {
                    tableView.register(item.item, forCellReuseIdentifier: String(describing: item.item))
                }
            }
        }
    }
    
    extension TableViewSource: UITableViewDataSource {
        
        public func numberOfSections(in tableView: UITableView) -> Int {
            return self.sections.count
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let section = self.sections[section]
            return section.items.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let section = self.sections[indexPath.section]
            let item = section.items[indexPath.row]
            let id = String(describing: item.item)
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            item.config(item: cell, data: item.value, indexPath: indexPath)
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let section = self.sections[indexPath.section]
            let item = section.items[indexPath.row]
            return item.height(data: item.value, indexPath: indexPath)
        }
    }
    
    extension TableViewSource: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let section = self.sections[indexPath.section]
            let item = section.items[indexPath.row]
            item.callback(data: item.value, indexPath: indexPath)
        }
    }
#endif

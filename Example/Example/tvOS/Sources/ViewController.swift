//
//  ViewController.swift
//  Example-tvOS
//
//  Created by Tibor Bödecs on 2017. 09. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import UIKit
import CoreKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: CollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let grid = Grid(view: self.collectionView)
        let source = CollectionViewSource(grid: grid)
        let section = CollectionViewSection()

        section.header = StringData("header")
        section.footer = StringData("footer")

        for i in stride(from: 0, to: 100, by: 1) {
            let data = StringData("item \(i)")

            section.items.append(data)
        }

        source.sections.append(section)

        self.collectionView.source = source

        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

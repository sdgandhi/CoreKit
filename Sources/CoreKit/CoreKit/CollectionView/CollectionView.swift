//
//  CollectionView.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 29..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS)

    open class CollectionView: AppleCollectionView {

        #if os(iOS)
        open var scrollViewDelegate: AppleScrollViewDelegate?
        #endif
        
        open var source: CollectionViewSource? = nil {
            didSet {
                self.source?.register(itemsFor: self)

                self.dataSource = self.source
                self.delegate = self.source
            }
        }
        #if os(iOS)

        open var showsScrollIndicators: Bool {
            get {
                return self.showsHorizontalScrollIndicator || self.showsVerticalScrollIndicator
            }
            set {
                self.showsHorizontalScrollIndicator = newValue
                self.showsVerticalScrollIndicator = newValue
            }
        }
        #endif
    }

#endif

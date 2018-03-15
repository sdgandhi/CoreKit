//
//  CollectionViewSource.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 29..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS)

    import CoreGraphics.CGGeometry

    open class CollectionViewSource: AppleObject {

        private var indexPathSelected = false

        open var selectionThreshold: Double = 0.5
        open var grid: Grid
        open var sections: [CollectionViewSection] = []
        open var callback: CollectionViewCallback?

        public init(grid: Grid) {
            self.grid = grid

            super.init()
        }
    }

    public extension CollectionViewSource {

        public var sectionIndexes: AppleIndexSet? {
            if self.sections.isEmpty {
                return nil
            }
            if self.sections.count == 1 {
                return AppleIndexSet(integer: 0)
            }
            return AppleIndexSet(integersIn: 0..<self.sections.count - 1)
        }
    }

    public extension CollectionViewSource {

        public func itemAt(_ section: Int) -> CollectionViewSection? {
            return self.sections.element(at: section)
        }

        public func itemAt(_ indexPath: AppleIndexPath) -> CollectionViewDataProtocol? {
            return self.itemAt(indexPath.section)?.items.element(at: indexPath.item)
        }
    }

    public extension CollectionViewSource {

        public func register(itemsFor collectionView: CollectionView) {

            for sectionData in self.sections {
                if let view = sectionData.header?.item {
                    view.register(itemFor: collectionView, kind: .header)
                }
                if let view = sectionData.footer?.item {
                    view.register(itemFor: collectionView, kind: .footer)
                }
                for view in sectionData.items.map({ $0.item }) {
                    view.register(itemFor: collectionView)
                }
            }
        }
    }

    extension CollectionViewSource: AppleCollectionViewSource {

        public func numberOfSections(in collectionView: AppleCollectionView) -> Int {
            return self.sections.count
        }

        public func collectionView(_ collectionView: AppleCollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.itemAt(section)?.items.count ?? 0
        }

        private func collectionView(_ collectionView: AppleCollectionView,
                                    itemForIndexPath indexPath: AppleIndexPath) -> AppleCollectionViewItem {
            guard
                let data = self.itemAt(indexPath),
                let item = data.item.reuse(collectionView, indexPath: indexPath) as? CollectionViewItem
            else {
                return CollectionViewItem.reuse(collectionView, indexPath: indexPath)
            }
            data.config(item: item, data: data.value, indexPath: indexPath, grid: self.grid(indexPath.section))
            return item
        }

        #if os(iOS) || os(tvOS)
        public func collectionView(_ collectionView: AppleCollectionView,
                                   cellForItemAt indexPath: AppleIndexPath) -> AppleCollectionViewItem {
            return self.collectionView(collectionView, itemForIndexPath: indexPath)
        }
        #elseif os(macOS)

        public func collectionView(_ collectionView: AppleCollectionView,
                                   itemForRepresentedObjectAt indexPath: AppleIndexPath) -> AppleCollectionViewItem {
            return self.collectionView(collectionView, itemForIndexPath: indexPath)
        }
        #endif

        private func _collectionView(_ collectionView: AppleCollectionView,
                                     viewForSupplementaryElementOfKind kind: String,
                                     at indexPath: AppleIndexPath) -> AppleCollectionViewReusableView
        {
            let grid = self.grid(indexPath.section)
            let section = self.itemAt(indexPath.section)

            if kind == AppleCollectionElementKindSectionHeader {
                guard
                    let section = section,
                    let data = section.header,
                    let cell = data.item.reuse(collectionView,
                                               indexPath: indexPath,
                                               kind: .header) as? CollectionViewItem
                else {
                    return CollectionViewItem.reuse(collectionView, indexPath: indexPath)
                }
                data.config(item: cell, data: data.value, indexPath: indexPath, grid: grid)
                return cell
            }

            if kind == AppleCollectionElementKindSectionFooter {
                guard
                    let section = section,
                    let data = section.footer,
                    let cell = data.item.reuse(collectionView,
                                               indexPath: indexPath,
                                               kind: .footer) as? CollectionViewItem
                else {
                    return CollectionViewItem.reuse(collectionView, indexPath: indexPath)
                }
                data.config(item: cell, data: data.value, indexPath: indexPath, grid: grid)
                return cell
            }

            return CollectionViewItem.reuse(collectionView, indexPath: indexPath, kind: .header)
        }

        #if os(iOS) || os(tvOS)
        public func collectionView(_ collectionView: AppleCollectionView,
                                   viewForSupplementaryElementOfKind kind: String,
                                   at indexPath: AppleIndexPath) -> AppleCollectionViewReusableView {
            return self._collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        #elseif os(macOS)
        public func collectionView(_ collectionView: AppleCollectionView,
                                   viewForSupplementaryElementOfKind kind: AppleCollectionView.SupplementaryElementKind,
                                   at indexPath: AppleIndexPath) -> AppleView {
            let reusedView = self._collectionView(collectionView,
                                                  viewForSupplementaryElementOfKind: kind.rawValue,
                                                  at: indexPath)
            // swiftlint:disable:next force_unwrapping
            return reusedView.view.superview!
        }

        #endif

        public func collectionView(_ collectionView: AppleCollectionView,
                                   canMoveItemAt indexPath: AppleIndexPath) -> Bool
        {
            return false
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   moveItemAt sourceIndexPath: AppleIndexPath,
                                   to destinationIndexPath: AppleIndexPath) {
            //        guard let _ = self.dataAt(sourceIndexPath) else { return }
        }
    }

    extension CollectionViewSource: AppleCollectionViewDelegate {

        func selectItem(at indexPath: AppleIndexPath) {
            guard let data = self.itemAt(indexPath), !self.indexPathSelected else {
                return
            }

            if self.selectionThreshold > 0 {
                self.indexPathSelected = true

                DispatchQueue.main.asyncAfter(delay: self.selectionThreshold) { [weak self] in
                    self?.indexPathSelected = false
                }
            }

            if !data.callback(data: data.value, indexPath: indexPath) {
                if let section = self.itemAt(indexPath.section), let callback = section.callback {
                    return callback(data.value, indexPath)
                }
                self.callback?(data.value, indexPath)
            }
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   didSelectItemAt indexPath: AppleIndexPath) {
            self.selectItem(at: indexPath)
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   willDisplay cell: AppleCollectionViewItem,
                                   forItemAt indexPath: AppleIndexPath) {
            //        guard let _ = self.dataAt(indexPath) else { return }
        }

        #if os(macOS)
        public func collectionView(_ collectionView: AppleCollectionView,
                                   didSelectItemsAt indexPaths: Set<AppleIndexPath>) {
            collectionView.deselectItems(at: indexPaths)

            guard let indexPath = indexPaths.first else {
                return
            }

            self.selectItem(at: indexPath)
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   didDeselectItemsAt indexPaths: Set<AppleIndexPath>) {
            //        guard let indexPath = indexPaths.first else {return}
            //        guard let item = collectionView.itemAtIndexPath(indexPath) else {return}
            //        (item as! CollectionViewItem).setHighlight(false)
        }
        #endif
        
        // MARK: AppleScrollViewDelegate

        #if os(iOS)
        public func scrollViewDidScroll(_ scrollView: AppleScrollView) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewDidScroll?(scrollView)
        }
        
        public func scrollViewDidZoom(_ scrollView: AppleScrollView) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewDidZoom?(scrollView)
        }
        
        public func scrollViewWillBeginDragging(_ scrollView: AppleScrollView) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
        }
        
        public func scrollViewWillEndDragging(_ scrollView: AppleScrollView,
                                              withVelocity velocity: CGPoint,
                                              targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewWillEndDragging?(scrollView,
                                                                          withVelocity: velocity,
                                                                          targetContentOffset: targetContentOffset)
        }
        
        public func scrollViewDidEndDragging(_ scrollView: AppleScrollView, willDecelerate decelerate: Bool) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
        
        public func scrollViewWillBeginDecelerating(_ scrollView: AppleScrollView) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
        }
        
        public func scrollViewDidEndDecelerating(_ scrollView: AppleScrollView) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
        }
        
        public func scrollViewDidEndScrollingAnimation(_ scrollView: AppleScrollView) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
        }
        
        public func viewForZooming(in scrollView: AppleScrollView) -> AppleView? {
            guard let collectionView = scrollView as? CollectionView else {
                return nil
            }
            return collectionView.scrollViewDelegate?.viewForZooming?(in: scrollView)
        }
        
        public func scrollViewWillBeginZooming(_ scrollView: AppleScrollView, with view: AppleView?) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
        }
        
        public func scrollViewDidEndZooming(_ scrollView: AppleScrollView,
                                            with view: AppleView?,
                                            atScale scale: CGFloat) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewDidEndZooming?(scrollView,
                                                                        with: view,
                                                                        atScale: scale)
        }
        
        public func scrollViewShouldScrollToTop(_ scrollView: AppleScrollView) -> Bool {
            guard let collectionView = scrollView as? CollectionView else {
                return true
            }
            return collectionView.scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
        }
        
        public func scrollViewDidScrollToTop(_ scrollView: AppleScrollView) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
        }
        
        @available(iOSApplicationExtension 11.0, *)
        public func scrollViewDidChangeAdjustedContentInset(_ scrollView: AppleScrollView) {
            guard let collectionView = scrollView as? CollectionView else {
                return
            }
            collectionView.scrollViewDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
        }
        #endif
    }

    extension CollectionViewSource: AppleCollectionViewDelegateFlowLayout {

        func grid(_ section: Int) -> Grid {
            return self.itemAt(section)?.grid ?? self.grid
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   layout collectionViewLayout: AppleCollectionViewLayout,
                                   sizeForItemAt indexPath: AppleIndexPath) -> CGSize {
            guard let data = self.itemAt(indexPath) else {
                return .zero
            }
            let grid = self.grid(indexPath.section)
            
            return data.size(data: data.value, indexPath: indexPath, grid: grid, view: collectionView)
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   layout collectionViewLayout: AppleCollectionViewLayout,
                                   insetForSectionAt section: Int) -> AppleEdgeInsets {
            return self.grid(section).margin
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   layout collectionViewLayout: AppleCollectionViewLayout,
                                   minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return self.grid(section).verticalPadding
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   layout collectionViewLayout: AppleCollectionViewLayout,
                                   minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return self.grid(section).horizontalPadding
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   layout collectionViewLayout: AppleCollectionViewLayout,
                                   referenceSizeForHeaderInSection section: Int) -> CGSize {
            guard let data = self.itemAt(section)?.header else {
                return .zero
            }
            let indexPath = AppleIndexPath(item: -1, section: section)
            let grid = self.grid(section)
            return data.size(data: data.value, indexPath: indexPath, grid: grid, view: collectionView)
        }

        public func collectionView(_ collectionView: AppleCollectionView,
                                   layout collectionViewLayout: AppleCollectionViewLayout,
                                   referenceSizeForFooterInSection section: Int) -> CGSize {
            guard let data = self.itemAt(section)?.footer else {
                return .zero
            }
            let indexPath = AppleIndexPath(item: -1, section: section)
            let grid = self.grid(section)
            return data.size(data: data.value, indexPath: indexPath, grid: grid, view: collectionView)
        }
    }
    
    

#endif


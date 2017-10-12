//
//  AppleCollectionViewItem+Reuse.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 29..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//


#if os(macOS) || os(iOS) || os(tvOS)

    /**
     Reuse identifier shorthand
     */
    public extension AppleCollectionViewItem {

        public static var reuseIdentifier: AppleCollectionViewItem.Identifier.RawValue {
            return AppleCollectionViewItem.Identifier(self).rawValue
        }
    }

    /**
     Cells
     */
    public extension AppleCollectionViewItem {

        public static func register(nibFor collectionView: AppleCollectionView) {
            #if os(macOS)
                collectionView.register(self.nib, forItemWithIdentifier: self.reuseIdentifier)
            #else
                collectionView.register(self.nib, forCellWithReuseIdentifier: self.reuseIdentifier)
            #endif
        }
        
        public static func register(classFor collectionView: AppleCollectionView) {
            #if os(macOS)
                collectionView.register(self, forItemWithIdentifier: self.reuseIdentifier)
            #else
                collectionView.register(self, forCellWithReuseIdentifier: self.reuseIdentifier)
            #endif
        }

        public static func register(itemFor collectionView: AppleCollectionView) {
            if self.nib != nil {
                return self.register(nibFor: collectionView)
            }
            self.register(classFor: collectionView)
        }
        
        public static func reuse(_ collectionView: AppleCollectionView, indexPath: AppleIndexPath) -> AppleCollectionViewItem {
            #if os(macOS)
                return collectionView.makeItem(withIdentifier: self.reuseIdentifier, for: indexPath)
            #else
                return collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
            #endif
        }
        
    }
    
    /**
     Supplementary views
     */
    public extension AppleCollectionViewItem {
        
        /**
         Register a nib for reuse as a supplementary element
         
         - parameter _ collectionView: A collection view to regsiter the view
         - parameter kind: The view type for reuse
         */
        public static func register(nibFor collectionView: AppleCollectionView, kind: AppleCollectionViewItem.Kind) {
            #if os(macOS)
                collectionView.register(self.nib, forSupplementaryViewOfKind: kind.rawValue, withIdentifier: self.reuseIdentifier)
            #else
                collectionView.register(self.nib, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: self.reuseIdentifier)
            #endif
        }
        
        /**
         Register a class for reuse as a supplementary element
         
         - parameter _ collectionView: A collection view to regsiter the view
         - parameter kind: The view type for reuse
         */
        public static func register(classFor collectionView: AppleCollectionView, kind: AppleCollectionViewItem.Kind) {
            #if os(macOS)
                collectionView.register(self, forSupplementaryViewOfKind: kind.rawValue, withIdentifier: self.reuseIdentifier)
            #else
                collectionView.register(self, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: self.reuseIdentifier)
            #endif
        }
        
        /**
         Register a nib or a class for reuse as a supplementary element
         
         - parameter _ collectionView: A collection view to regsiter the view
         - parameter kind: The view type for reuse
         */
        public static func register(itemFor collectionView: AppleCollectionView, kind: AppleCollectionViewItem.Kind) {
            if self.nib != nil {
                return self.register(nibFor: collectionView, kind: kind)
            }
            self.register(classFor: collectionView, kind: kind)
        }

        /**
         Reuse a type for a supplementary element kind
         
         - parameter _ collectionView: A collection view to regsiter the view
         - parameter kind: The view type for reuse
         */
        public static func reuse(_ collectionView: AppleCollectionView, indexPath: AppleIndexPath, kind: AppleCollectionViewItem.Kind) -> AppleCollectionViewReusableView {
            #if os(macOS)
                //let wrapper = self.init(nib: AppleNib.Identifier(self)) //unfortunately this is not possible right now...
                let wrapper = self.init(nibName: AppleNib.Identifier(self).rawValue, bundle: .main)
                
                let view = collectionView.makeSupplementaryView(ofKind: kind.rawValue, withIdentifier: self.reuseIdentifier, for: indexPath)
                
                view.subviews.forEach { $0.removeFromSuperview() }
                
                wrapper.view.frame = view.bounds
                
                view.addSubview(wrapper.view)
                
                return wrapper
            #else
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: self.reuseIdentifier, for: indexPath)
            #endif
        }
    }

#endif

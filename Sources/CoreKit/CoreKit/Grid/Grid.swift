//
//  Grid.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 09. 29..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS)

    import CoreGraphics

    open class Grid {

        open var columns: CGFloat
        open var margin: AppleEdgeInsets
        open var padding: AppleEdgeInsets
        
        public var verticalMargin: CGFloat {
            return self.margin.top + self.margin.bottom
        }
        
        public var horizontalMargin: CGFloat {
            return self.margin.left + self.margin.right
        }

        // line spacing
        public var verticalPadding: CGFloat {
            return self.padding.top + self.padding.bottom
        }
        
        // inter item spacing
        public var horizontalPadding: CGFloat {
            return self.padding.left + self.padding.right
        }

        public init(columns: CGFloat = 1, margin: AppleEdgeInsets = .zero, padding: AppleEdgeInsets = .zero) {
            self.columns = columns
            self.margin = margin
            self.padding = padding
        }

        open func size(for view: AppleView, ratio: CGFloat, items: CGFloat = 1, gaps: CGFloat? = nil) -> CGSize {
            let size = self.width(for: view, items: items, gaps: gaps)
            return CGSize(width: size, height: (size * ratio).evenRounded)
        }

        open func size(for view: AppleView, height: CGFloat, items: CGFloat = 1, gaps: CGFloat? = nil) -> CGSize {
            let size = self.width(for: view, items: items, gaps: gaps)

            var height = height
            if height < 0 {
                height = view.bounds.size.height - height
            }
            return CGSize(width: size, height: height.evenRounded)
        }

        open func width(for view: AppleView, items: CGFloat = 1, gaps: CGFloat? = nil) -> CGFloat {
            let gaps = gaps ?? items - 1

            let width = view.bounds.size.width - self.horizontalMargin - self.horizontalPadding * gaps

            return (width / self.columns * items).evenRounded
        }
    }

#endif

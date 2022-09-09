//
//  CGRect+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

public extension CGRect {
    
    /// Area of rectangle
    @inlinable var area: CGFloat { size.area }
    
    /// Max corner radius allowed for rectangle
    @inlinable var maxCornerRadius: CGFloat { size.maxCornerRadius }
    
    /// Center point on the rectangle
    @inlinable var center: CGPoint {
        let centerX = minX + ((maxX - minX) / 2)
        let centerY = minY + ((maxY - minY) / 2)
        return CGPoint(x: centerX, y: centerY)
    }
    
    /// Calculate centered frame with given size
    /// - Parameter size: Size
    /// - Returns: New CGRect instance
    @inlinable func centeredFrame(withSize size: CGSize) -> CGRect {
        let halfSize = size / 2
        let origin = CGPoint(x: center.x - halfSize.width, y: center.y - halfSize.height)
        return CGRect(origin: origin, size: size)
    }
    
    /// Calculate insets to frame containing the given frame
    /// - Parameter outerFrame: Frame containing this CGRect
    /// - Returns: UIEdgeInsets of the frame
    @inlinable func insets(to outerFrame: CGRect) -> UIEdgeInsets {
        outerFrame.insets(of: self)
    }
    
    /// Calculate insets of frame inside this CGRect
    /// - Parameter innerFrame: Frame inside
    /// - Returns: UIEdgeInsets of the frame
    @inlinable func insets(of innerFrame: CGRect) -> UIEdgeInsets {
        let topInset = innerFrame.origin.y
        let leftInset = innerFrame.origin.x
        let maxX = topInset + innerFrame.size.height
        let bottomInset = size.height - maxX
        let maxY = leftInset + innerFrame.size.width
        let rightInset = size.width - maxY
        return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    
    /// Calculate frame inside this CGRect with given the insets
    /// - Parameter insets: UIEdgeInsets to the frame
    /// - Returns: Calculated inner frame
    @inlinable func innerFrame(insetedBy insets: UIEdgeInsets) -> CGRect {
        let origin = CGPoint(x: insets.left, y: insets.top)
        let size = self.size.reduced(by: insets)
        return CGRect(origin: origin, size: size)
    }
    
    /// Calculate new frame if enlarged by the given offset
    /// - Parameter offsets: Offset for enlargement
    /// - Returns: New enlarged CGRect
    @inlinable func enlarged(by offsets: UIEdgeInsets) -> CGRect {
        let origin = CGPoint(x: origin.x - offsets.left, y: origin.y - offsets.top)
        let size = self.size.enlarged(by: offsets)
        return CGRect(origin: origin, size: size)
    }
}
#endif

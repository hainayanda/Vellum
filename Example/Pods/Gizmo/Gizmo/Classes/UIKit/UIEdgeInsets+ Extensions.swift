//
//  UIEdgeInsets+Extenison.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/.zero7/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

// MARK: Init

public extension UIEdgeInsets {
    
    /// Create UIEdgeInsets with given verticals and horizontals insets
    /// Default value of verticals and horizontals is zero
    /// - Parameters:
    ///   - vertical: Top and bottom insets
    ///   - horizontal: Left and right insets
    @inlinable init(verticals: CGFloat = .zero, horizontals: CGFloat = .zero) {
        self.init(top: verticals, left: horizontals, bottom: verticals, right: horizontals)
    }
    
    /// Create UIEdgeInsets with given insets
    /// - Parameter insets: All edge insets
    @inlinable init(insets: CGFloat) {
        self.init(top: insets, left: insets, bottom: insets, right: insets)
    }
}

// MARK: Common

public extension UIEdgeInsets {
    
    /// Create new UIEdgeInsets increased by another insets
    /// - Parameter insets: Another insets
    /// - Returns: New UIEdgeInsets
    @inlinable func increased(by insets: UIEdgeInsets) -> UIEdgeInsets {
        self + insets
    }
    
    /// Create new UIEdgeInsets increased by another insets
    /// - Parameter insets: Another insets
    /// - Returns: New UIEdgeInsets
    @inlinable func increased(by insets: CGFloat) -> UIEdgeInsets {
        self + insets
    }
    
    /// Create new UIEdgeInsets decreased by another insets
    /// - Parameter insets: Another insets
    /// - Returns: New UIEdgeInsets
    @inlinable func decreased(by insets: UIEdgeInsets) -> UIEdgeInsets {
        self - insets
    }
    
    /// Create new UIEdgeInsets decreased by another insets
    /// - Parameter insets: Another insets
    /// - Returns: New UIEdgeInsets
    @inlinable func decreased(by insets: CGFloat) -> UIEdgeInsets {
        self - insets
    }
}

// MARK: Operator

@inlinable public func +(_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(
        top: lhs.top + rhs.top,
        left: lhs.left + rhs.left,
        bottom: lhs.bottom + rhs.bottom,
        right: lhs.right + rhs.right
    )
}

@inlinable public func -(_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(
        top: lhs.top - rhs.top,
        left: lhs.left - rhs.left,
        bottom: lhs.bottom - rhs.bottom,
        right: lhs.right - rhs.right
    )
}

@inlinable public func +(_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(
        top: lhs.top + rhs,
        left: lhs.left + rhs,
        bottom: lhs.bottom + rhs,
        right: lhs.right + rhs
    )
}

@inlinable public func -(_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(
        top: lhs.top - rhs,
        left: lhs.left - rhs,
        bottom: lhs.bottom - rhs,
        right: lhs.right - rhs
    )
}

@inlinable public func *(_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(
        top: lhs.top * rhs,
        left: lhs.left * rhs,
        bottom: lhs.bottom * rhs,
        right: lhs.right * rhs
    )
}

@inlinable public func /(_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(
        top: lhs.top / rhs,
        left: lhs.left / rhs,
        bottom: lhs.bottom / rhs,
        right: lhs.right / rhs
    )
}
#endif

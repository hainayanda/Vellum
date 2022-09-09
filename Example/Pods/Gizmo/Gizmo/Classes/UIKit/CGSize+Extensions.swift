//
//  CGSize+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

// MARK: Common

public extension CGSize {
    /// Area of size
    @inlinable var area: CGFloat { width * height }
    
    /// Max corner radius allowed for size
    @inlinable var maxCornerRadius: CGFloat { min(width, height) / 2 }
    
    /// Create new reduced size by the given insets
    /// - Parameter inset: Insets that will reduce the size
    /// - Returns: Reduced size
    @inlinable func reduced(by inset: UIEdgeInsets) -> CGSize {
        CGSize(
            width: width - inset.left - inset.right,
            height: height - inset.top - inset.bottom
        )
    }
    
    /// Create new enlarged size by the given offsets
    /// - Parameter offsets: Offsets that will enlarge the size
    /// - Returns: Enlarged size
    @inlinable func enlarged(by offsets: UIEdgeInsets) -> CGSize {
        CGSize(
            width: width + offsets.left + offsets.right,
            height: height + offsets.top + offsets.bottom
        )
    }
}

// MARK: Init

public extension CGSize {
    /// Initialized CGSize with the given dimension for both witdth and height
    /// - Parameter sides: dimension of size
    @inlinable init(sides: CGFloat) {
        self.init(width: sides, height: sides)
    }
}

// MARK: Operator

@inlinable public func +(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    CGSize(
        width: lhs.width + rhs.width,
        height: lhs.height + rhs.height
    )
}

@inlinable public func -(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    CGSize(
        width: lhs.width - rhs.width,
        height: lhs.height - rhs.height
    )
}

@inlinable public func +(_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
    CGSize(
        width: lhs.width + rhs,
        height: lhs.height + rhs
    )
}

@inlinable public func -(_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
    CGSize(
        width: lhs.width - rhs,
        height: lhs.height - rhs
    )
}

@inlinable public func *(_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
    CGSize(
        width: lhs.width * rhs,
        height: lhs.height * rhs
    )
}

@inlinable public func /(_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
    CGSize(
        width: lhs.width / rhs,
        height: lhs.height / rhs
    )
}
#endif

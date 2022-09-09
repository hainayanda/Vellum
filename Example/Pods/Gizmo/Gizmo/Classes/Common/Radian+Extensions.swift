//
//  Float+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation

public typealias Radian = Float

public extension Float {
    /// convert angle in Float to its radian value
    @inlinable var angleDegree: Radian {
        .pi * (self / 180)
    }
}

public extension Double {
    /// convert angle in Double to its radian value
    @inlinable var angleDegree: Radian {
        Float(self).angleDegree
    }
}

public extension Int {
    /// convert angle in Int to its radian value
    @inlinable var angleDegree: Radian {
        Float(self).angleDegree
    }
}

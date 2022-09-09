//
//  CACornerMask+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

public extension CACornerMask {
    
    @inlinable static var topLeft: CACornerMask { layerMinXMinYCorner }

    @inlinable static var topRight: CACornerMask { layerMaxXMinYCorner }

    @inlinable static var bottomLeft: CACornerMask { layerMinXMaxYCorner }

    @inlinable static var bottomRight: CACornerMask { layerMaxXMaxYCorner }
    
    @inlinable static var allTop: CACornerMask {
        [topLeft, topRight]
    }

    @inlinable static var allLeft: CACornerMask {
        [topLeft, bottomLeft]
    }

    @inlinable static var allRight: CACornerMask {
        [topRight, bottomRight]
    }

    @inlinable static var allBottom: CACornerMask {
        [bottomLeft, bottomRight]
    }
    
    @inlinable static var allButTopLeft: CACornerMask {
        [topRight, bottomLeft, bottomRight]
    }

    @inlinable static var allButTopRight: CACornerMask {
        [topLeft, bottomLeft, bottomRight]
    }

    @inlinable static var allButBottomLeft: CACornerMask {
        [topLeft, topRight, bottomRight]
    }

    @inlinable static var allButBottomRight: CACornerMask {
        [topLeft, topRight, bottomLeft]
    }
    
    @inlinable static var all: CACornerMask {
        [topLeft, topRight, bottomLeft, bottomRight]
    }

}
#endif

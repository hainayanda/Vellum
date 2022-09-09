//
//  UIResponder.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

public extension UIResponder {
    /// Get the nearest responder view controller from this responder
    /// - Complexity: O(*n*) where *n* is number of responder until next UIViewController
    var responderViewController: UIViewController? {
        self as? UIViewController ?? next?.responderViewController
    }
}
#endif

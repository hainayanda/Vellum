//
//  TimeInterval+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation

public extension TimeInterval {
    
    /// create a Date object calculating to the past using the current TimeInterval value
    @inlinable var ago: Date {
        Date(timeIntervalSinceNow: -self)
    }
    
    /// create a Date object calculating to the future using the current TimeInterval value
    @inlinable var sinceNow: Date {
        Date(timeIntervalSinceNow: self)
    }
    
    /// create a Date object calculating from the 1970 using the current TimeInterval value
    @inlinable var since1970: Date {
        Date(timeIntervalSince1970: self)
    }
}

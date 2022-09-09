//
//  Int+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation

public extension Int {
    /// Convert int value to equivalent microseconds in TimeInterval
    @inlinable var microSeconds: TimeInterval {
        miliSeconds / 1000
    }
    
    /// Convert int value to equivalent miliSeconds in TimeInterval
    @inlinable var miliSeconds: TimeInterval {
        seconds / 1000
    }
    
    /// Convert int value to equivalent seconds in TimeInterval
    @inlinable var seconds: TimeInterval {
        TimeInterval(self)
    }
    
    /// Convert int value to equivalent minutes in TimeInterval
    @inlinable var minutes: TimeInterval {
        seconds * 60
    }
    
    /// Convert int value to equivalent hours in TimeInterval
    @inlinable var hours: TimeInterval {
        minutes * 60
    }
    
    /// Convert int value to equivalent days in TimeInterval
    @inlinable var days: TimeInterval {
        hours * 24
    }
    
    /// Convert int value to equivalent weeks in TimeInterval
    @inlinable var weeks: TimeInterval {
        days * 7
    }
}

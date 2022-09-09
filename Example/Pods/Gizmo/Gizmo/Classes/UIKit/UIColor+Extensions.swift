//
//  UIColor+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation
#if canImport(UIKit)
import UIKit

public extension UIColor {
    
    /// Hex string representation of the color
    /// eg: #ffffff
    @inlinable var hex: String {
        String(format: "#%02lX%02lX%02lX", redInt, greenInt, blueInt)
    }
    
    /// Red value of the color from 0 to 255
    @inlinable var redInt: Int {
        lroundf(Float(red * 255))
    }
    
    /// Green value of the color from 0 to 255
    @inlinable var greenInt: Int {
        lroundf(Float(green * 255))
    }
    
    /// Blue value of the color from 0 to 255
    @inlinable var blueInt: Int {
        lroundf(Float(blue * 255))
    }
    
    /// Red value of the color from 0 to 1
    var red: CGFloat {
        colorComponent(at: 0)
    }
    
    /// Green value of the color from 0 to 1
    var green: CGFloat {
        colorComponent(at: 1)
    }
    
    /// Blue value of the color from 0 to 1
    var blue: CGFloat {
        colorComponent(at: 2)
    }
    
    /// Alpha value of the color from 0 to 1
    @inlinable var alpha: CGFloat {
        cgColor.alpha
    }
    
    /// Initialize UIColor using string hex representation of the color
    /// It will produce nil if fail
    /// eg: UIColor(hex: "#ffffff")
    /// - Parameters:
    ///   -  hex: Hex representation of the color
    ///   -  alpha: Alpha value from 0 to 1. Default 1
    convenience init?(hex: String, alpha: CGFloat = 1) {
        var formattedHex: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        if formattedHex.count != 6 {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /// Initialize UIColor using rgb value
    /// - Parameters:
    ///   - red: Red int value from 0 to 255
    ///   - green: Green int value from 0 to 255
    ///   - blue: Blue int value from 0 to 255
    ///   - alpha: Alpha value from 0 to 1. Default 1
    @inlinable convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        let cgRed = CGFloat(max(min(red, 255), 0))
        let cgGreen = CGFloat(max(min(green, 255), 0))
        let cgBlue = CGFloat(max(min(blue, 255), 0))
        self.init(
            red: CGFloat(cgRed) / 255,
            green: CGFloat(cgGreen) / 255,
            blue: CGFloat(cgBlue) / 255,
            alpha: alpha
        )
    }
    
    /// Initialize UIColor using Int hex representation of the color
    /// - Parameters:
    ///   -  hex: Hex representation of the color
    ///   -  alpha: Alpha value from 0 to 1. Default 1
    @inlinable convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(
            red: ((hex >> 16) & 0xFF),
            green: ((hex >> 8) & 0xFF),
            blue: (hex & 0xFF),
            alpha: alpha
        )
    }
}

// MARK: Internal

extension UIColor {
    
    func colorComponent(at index: Int) -> CGFloat {
        guard let components = cgColor.components, components.isNotEmpty else { return 0 }
        guard components.count > 2 else { return components[0] }
        return components[safe: index] ?? 0
    }
}
#endif

//
//  Common.swift
//  Vellum
//
//  Created by Nayanda Haberty on 13/01/21.
//

import Foundation

extension String {
    func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return self.processCamelCase(pattern: acronymPattern)?
            .processCamelCase(pattern: normalPattern)?.lowercased() ?? self.lowercased()
    }
    
    private func processCamelCase(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}

public extension Int {
    var bit: Int { self / 8 }
    var nibble: Int { self / 2 }
    var byte: Int { self }
    var kiloByte: Int { self * 1024 }
    var megaByte: Int { kiloByte * 1024 }
    var gigaByte: Int { megaByte * 1024 }
}

public extension Double {
    var bit: Int { Int(self).bit }
    var nibble: Int { Int(self).nibble }
    var byte: Int { Int(self).byte }
    var kiloByte: Int { Int(self).kiloByte }
    var megaByte: Int { Int(self).megaByte }
    var gigaByte: Int { Int(self).gigaByte }
}

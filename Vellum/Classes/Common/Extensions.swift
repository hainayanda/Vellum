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
    var bits: DataSize { .bits(self) }
    var nibbles: DataSize { .nibles(self) }
    var bytes: DataSize { .bytes(self) }
    var kiloBytes: DataSize { .kiloBytes(self) }
    var megaBytes: DataSize { .megaBytes(self) }
    var gigaBytes: DataSize { .gigaBytes(self) }
}

public extension Double {
    var bits: DataSize { .bits(self) }
    var nibbles: DataSize { .nibles(self) }
    var bytes: DataSize { .bytes(self) }
    var kiloBytes: DataSize { .kiloBytes(self) }
    var megaBytes: DataSize { .megaBytes(self) }
    var gigaBytes: DataSize { .gigaBytes(self) }
}

protocol OptionalValidatable {
    var isNil: Bool { get }
    var isNotNil: Bool { get }
}

extension Optional: OptionalValidatable {
    var isNil: Bool {
        switch self {
        case .some(_):
            return false
        default:
            return true
        }
    }
    
    var isNotNil: Bool {
        return !isNil
    }
}

public func max<Some: Comparable>(_ left: Some, _ right: Some) -> Some {
    if left < right {
        return right
    }
    return left
}

public func min<Some: Comparable>(_ left: Some, _ right: Some) -> Some {
    if left > right {
        return right
    }
    return left
}

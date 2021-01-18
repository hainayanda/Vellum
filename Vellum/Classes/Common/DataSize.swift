//
//  DataSize.swift
//  Vellum
//
//  Created by Nayanda Haberty on 18/01/21.
//

import Foundation

public struct DataSize: Equatable, Comparable {
    
    public var bits: Int { bytes * 8 }
    public var nibbles: Int { bytes * 2 }
    public var bytes: Int
    public var kiloBytes: Double {
        let bytes: Double = Double(self.bytes)
        return bytes / 1024
    }
    public var megaBytes: Double {
        return kiloBytes / 1024
    }
    public var gigaBytes: Double {
        return megaBytes / 1024
    }
    
    public static var zero: DataSize {
        .init(bytes: 0)
    }
    
    public static func bits(_ count: Int) -> DataSize {
        let bytes = count / 8
        if count % 8 == 0 {
            return .init(bytes: bytes)
        }
        return .init(bytes: bytes + 1)
    }
    
    public static func bits(_ count: Double) -> DataSize {
        let bytes = count / 8
        if count.truncatingRemainder(dividingBy: 8) == 0 {
            return .init(bytes: Int(bytes))
        }
        return .init(bytes: Int(bytes) + 1)
    }
    
    public static func nibles(_ count: Int) -> DataSize {
        let numberOfBits = count * 4
        return .bits(numberOfBits)
    }
    
    public static func nibles(_ count: Double) -> DataSize {
        let numberOfBits = count * 4
        return .bits(numberOfBits)
    }
    
    public static func bytes(_ count: Int) -> DataSize {
        .init(bytes: count)
    }
    
    public static func bytes(_ count: Double) -> DataSize {
        let numberOfBits = count * 8
        return .bits(numberOfBits)
    }
    
    public static func kiloBytes(_ count: Int) -> DataSize {
        .init(bytes: count * 1024)
    }
    
    public static func kiloBytes(_ count: Double) -> DataSize {
        let numberOfBits = count * 8 * 1024
        return .bits(numberOfBits)
    }
    
    public static func megaBytes(_ count: Int) -> DataSize {
        .init(bytes: count * 1024 * 1024)
    }
    
    public static func megaBytes(_ count: Double) -> DataSize {
        let numberOfBits = count * 8 * 1024 * 1024
        return .bits(numberOfBits)
    }
    
    public static func gigaBytes(_ count: Int) -> DataSize {
        .init(bytes: count * 1024 * 1024 * 1024)
    }
    
    public static func gigaBytes(_ count: Double) -> DataSize {
        let numberOfBits = count * 8 * 1024 * 1024 * 1024
        return .bits(numberOfBits)
    }
    
    public static func < (lhs: DataSize, rhs: DataSize) -> Bool {
        return lhs.bytes < rhs.bytes
    }
}

extension DataSize: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self.init(bytes: value)
    }
}

extension DataSize: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    
    public init(floatLiteral value: Double) {
        let numberOfBits = value * 8
        var bytes: Int = Int(numberOfBits / 8)
        if numberOfBits.truncatingRemainder(dividingBy: 8) > 0 {
            bytes += 1
        }
        self.init(bytes: bytes)
    }
}

extension DataSize: AdditiveArithmetic {
    public static func - (lhs: DataSize, rhs: DataSize) -> DataSize {
        return .init(bytes: lhs.bytes - rhs.bytes)
    }
    
    public static func + (lhs: DataSize, rhs: DataSize) -> DataSize {
        return .init(bytes: lhs.bytes + rhs.bytes)
    }
}

extension Data {
    public var dataSize: DataSize {
        .init(bytes: count)
    }
}

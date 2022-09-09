//
//  DataSize.swift
//  Vellum
//
//  Created by Nayanda Haberty on 18/01/21.
//

import Foundation

public struct DataSize: Hashable {
    let bytes: Int
    
    public init(bytes: Int) {
        self.bytes = bytes
    }
}

public extension DataSize {
    @inlinable var bitsCount: Int { bytesCount * 8 }
    @inlinable var nibblesCount: Int { bytesCount * 2 }
    var bytesCount: Int { bytes }
    @inlinable var kiloBytesCount: Double { Double(self.bytesCount) / 1024 }
    @inlinable var megaBytesCount: Double { Double(bytesCount) / 1024 }
    @inlinable var gigaBytesCount: Double { Double(bytesCount) / 1024 }
}

public extension DataSize {
    @inlinable static var zero: DataSize { .init(bytes: 0) }
}

extension DataSize: Comparable {
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
    
    public static func * (lhs: DataSize, rhs: DataSize) -> DataSize {
        return .init(bytes: lhs.bytes * rhs.bytes)
    }
    
    public static func / (lhs: DataSize, rhs: DataSize) -> DataSize {
        return .init(bytes: lhs.bytes / rhs.bytes)
    }
}

public extension Data {
    var dataSize: DataSize {
        count.bytes
    }
}

public extension Int {
    @inlinable var bits: DataSize { .init(bytes: self / 8) }
    @inlinable var nibbles: DataSize { .init(bytes: self / 4) }
    @inlinable var bytes: DataSize { .init(bytes: self) }
    @inlinable var kiloBytes: DataSize { (self * 1024).bytes }
    @inlinable var megaBytes: DataSize { (self * 1024).kiloBytes }
    @inlinable var gigaBytes: DataSize { (self * 1024).megaBytes }
}

public extension Double {
    @inlinable var bits: DataSize { Int(self).bits }
    @inlinable var nibbles: DataSize { Int(self).nibbles }
    var bytes: DataSize { Int(self).bytes }
    @inlinable var kiloBytes: DataSize { (self * 1024).bytes }
    @inlinable var megaBytes: DataSize { (self * 1024).kiloBytes }
    @inlinable var gigaBytes: DataSize { (self * 1024).megaBytes }
}


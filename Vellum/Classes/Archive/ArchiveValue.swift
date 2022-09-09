//
//  ArchiveValue.swift
//  Vellum
//
//  Created by Nayanda Haberty on 17/08/22.
//

import Foundation

// MARK: ArchiveValue

public protocol ArchiveValue {
    static var archiveDataSize: DataSize { get }
    func archiveStorage() -> ArchiveStorage
    init?(archiveData: Data)
}

public protocol PrimitiveArchiveValue: ArchiveValue { }

// MARK: ArchiveValue + Numeric

public extension PrimitiveArchiveValue {
    static var archiveDataSize: DataSize { MemoryLayout<Self>.size.bytes }
    func archiveStorage() -> ArchiveStorage {
        PrimitiveArchiveStorage(value: self)
    }
    
    init?(archiveData: Data) {
        self = archiveData.withUnsafeBytes { $0.load(as: Self.self) }
    }
}

extension Int: PrimitiveArchiveValue { }
extension Int8: PrimitiveArchiveValue { }
extension Int16: PrimitiveArchiveValue { }
extension Int32: PrimitiveArchiveValue { }
extension Int64: PrimitiveArchiveValue { }
extension UInt: PrimitiveArchiveValue { }
extension UInt8: PrimitiveArchiveValue { }
extension UInt16: PrimitiveArchiveValue { }
extension UInt32: PrimitiveArchiveValue { }
extension UInt64: PrimitiveArchiveValue { }
extension Float: PrimitiveArchiveValue { }
extension Double: PrimitiveArchiveValue { }
@available(iOS 14.0, *)
extension Float16: PrimitiveArchiveValue { }
extension Float80: PrimitiveArchiveValue { }
extension Character: PrimitiveArchiveValue { }
extension Bool: PrimitiveArchiveValue { }

extension UUID: ArchiveValue {
    public static var archiveDataSize: DataSize { 16.bytes }
    public func archiveStorage() -> ArchiveStorage {
        UUIDArchiveStorage(value: self)
    }
    
    public init?(archiveData: Data) {
        self = UUID(
            uuid: (
                archiveData[0], archiveData[1], archiveData[2], archiveData[3],
                archiveData[4], archiveData[5], archiveData[6], archiveData[7],
                archiveData[8], archiveData[9], archiveData[10], archiveData[11],
                archiveData[12], archiveData[13], archiveData[14], archiveData[15]
            )
        )
    }
}

extension Date: ArchiveValue {
    public static var archiveDataSize: DataSize { MemoryLayout<TimeInterval>.size.bytes }
    public func archiveStorage() -> ArchiveStorage {
        DateArchiveStorage(value: self)
    }
    
    public init?(archiveData: Data) {
        guard let date = TimeInterval(archiveData: archiveData)?.since1970 else {
            return nil
        }
        self = date
    }
}

extension Optional: ArchiveValue where Wrapped: ArchiveValue {
    public static var archiveDataSize: DataSize { Wrapped.archiveDataSize + 1.bytes }
    public func archiveStorage() -> ArchiveStorage {
        OptionalArchiveStorage(value: self)
    }
    
    public init?(archiveData: Data) {
        if archiveData.isNil {
            self = .none
        } else {
            self = Wrapped(archiveData: archiveData[1 ..< archiveData.count])
        }
    }
}

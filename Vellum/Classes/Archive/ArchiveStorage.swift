//
//  ArchiveStorage.swift
//  Vellum
//
//  Created by Nayanda Haberty on 17/08/22.
//

import Foundation

public protocol ArchiveStorage {
    static var dataSize: DataSize { get }
    var data: Data { get }
    func prepareForStoring() throws
}

extension ArchiveStorage {
    var staticDataSize: DataSize { Self.dataSize }
}

public struct PrimitiveArchiveStorage<P: PrimitiveArchiveValue>: ArchiveStorage {
    public let data: Data
    public static var dataSize: DataSize { P.archiveDataSize }
    
    public init(value: P) {
        var mutableValue = value
        data = Data(bytes: &mutableValue, count: staticDataSize.bytesCount)
    }
    
    public func prepareForStoring() throws { }
}

public struct UUIDArchiveStorage: ArchiveStorage {
    public static var dataSize: DataSize { UUID.archiveDataSize }
    public let data: Data
    
    public init(value: UUID) {
        let uuid = value.uuid
        data = Data([
            uuid.0, uuid.1, uuid.2, uuid.3,
            uuid.4, uuid.5, uuid.6, uuid.7,
            uuid.8, uuid.9, uuid.10, uuid.11,
            uuid.12, uuid.13, uuid.14, uuid.15
        ])
    }
    
    public func prepareForStoring() throws { }
}

public struct DateArchiveStorage: ArchiveStorage {
    public static var dataSize: DataSize { TimeInterval.archiveDataSize }
    public let data: Data
    
    public init(value: Date) {
        var mutableValue = value.timeIntervalSince1970
        data = Data(bytes: &mutableValue, count: staticDataSize.bytesCount)
    }
    
    public func prepareForStoring() throws { }
}

public struct OptionalArchiveStorage<Wrapped: ArchiveValue>: ArchiveStorage {
    public static var dataSize: DataSize { Optional<Wrapped>.archiveDataSize }
    public var data: Data {
        guard let storage = wrappedStorage else {
            return Data(repeating: .zero, count: staticDataSize.bytesCount)
        }
        return Data([0x01]).added(with: storage.data)
    }
    let wrappedStorage: ArchiveStorage?
    
    public init(value: Wrapped?) {
        wrappedStorage = value?.archiveStorage()
    }
    
    public func prepareForStoring() throws {
        try wrappedStorage?.prepareForStoring()
    }
}

public struct ArrayArchiveStorage<Element: ArchiveValue>: ArchiveStorage {
    public static var dataSize: DataSize { [Element].archiveDataSize }
    public let data: Data
    let id: UUID
    let array: [Element]
    
    public init(value: [Element] = []) {
        array = value
        id = UUID()
        data = id.archiveStorage().data
    }
    
    public func prepareForStoring() throws {
        try [Element].chache.store(array, usingId: id)
    }
}

public struct StringArchiveStorage: ArchiveStorage {
    public static var dataSize: DataSize { [Character].archiveDataSize }
    public let data: Data
    let id: UUID
    let string: String
    
    public init(value: String) {
        string = value
        id = UUID()
        data = id.archiveStorage().data
    }
    
    public func prepareForStoring() throws {
        let array = Array(string)
        try String.chache.store(array, usingId: id)
    }
}

public struct ArchivableArchiveStorage<A: Archivable>: ArchiveStorage {
    public static var dataSize: DataSize { A.archiveDataSize }
    public let data: Data
    let id: UUID
    let archivable: A
    
    public init(value: A) {
        archivable = value
        id = UUID()
        data = id.archiveStorage().data
    }
    
    public func prepareForStoring() throws {
        try A.chache.store(archivable, usingId: id)
    }
}

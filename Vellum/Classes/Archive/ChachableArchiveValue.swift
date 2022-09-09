//
//  ChachableArchiveValue.swift
//  Vellum
//
//  Created by Nayanda Haberty on 17/08/22.
//

import Foundation

public protocol ChachableArchiveValue: ArchiveValue {
    static var chache: ArchiveChache { get }
}

extension ChachableArchiveValue {
    var staticChache: ArchiveChache {
        Self.chache
    }
    
    public init?(archiveData: Data) {
        guard let id = UUID(archiveData: archiveData),
              let archive = staticChache.readArchive(withId: id) as? Self else {
            return nil
        }
        self = archive
    }
}

public protocol ArrayArchiveValue: ChachableArchiveValue {
    init?(arrayArchiveData data: Data)
}

extension Array: ArchiveValue where Element: ArchiveValue {
    public static var archiveDataSize: DataSize { 16.bytes }
}

extension Array: ChachableArchiveValue where Element: ArchiveValue {
    public static var chache: ArchiveChache {
        <#code#>
    }
    
    public func archiveStorage() -> ArchiveStorage {
        ArrayArchiveStorage(value: self)
    }
    
    public init?(arrayArchiveData data: Data) {
        self = data.compactMapEach(maxBytesCount: Element.archiveDataSize.bytesCount) { Element(archiveData: $0) }
    }
    
}

extension String: ChachableArchiveValue {
    public static var archiveDataSize: DataSize { [Character].archiveDataSize }
    
    public static var chache: ArchiveChache {
        <#code#>
    }
    
    public func archiveStorage() -> ArchiveStorage {
        StringArchiveStorage(value: self)
    }
    
    public init?(archiveData: Data) {
        guard let characters = [Character].init(archiveData: archiveData) else {
            return nil
        }
        self = String(characters)
    }
    
    public init?(arrayArchiveData data: Data) {
        guard let characters = [Character].init(arrayArchiveData: data) else {
            return nil
        }
        self = String(characters)
    }
}

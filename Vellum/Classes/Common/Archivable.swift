//
//  Archivable.swift
//  Vellum
//
//  Created by Nayanda Haberty on 13/01/21.
//

import Foundation

public typealias ArchiveCodable = Archivable & Codable

public protocol Archivable {
    static var archiveName: String { get }
    static var archivePropertyBehavior: ArchivePropertyBehavior { get }
    var primaryKey: String { get }
    var sizeOfData: DataSize { get }
    func archiveData() throws -> Data
    static func decode(archive data: Data) throws -> Archivable
}

public enum ArchivePropertyBehavior {
    case replaceExisting
    case insertIfNotPresent
    case ignore
}

public extension Archivable {
    static var archiveName: String {
        let camelCase = String(describing: Self.self).filter { $0.isLetter || $0.isNumber }.camelCaseToSnakeCase()
        return "vellum_\(camelCase)"
    }
    
    static var archivePropertyBehavior: ArchivePropertyBehavior {
        .insertIfNotPresent
    }
    
    var sizeOfData: DataSize {
        let data = try? archiveData()
        return .init(bytes: data?.count ?? 0)
    }
    
    func updateArchive() {
        guard let archives: ArchiveManager<Self> = try? ArchivesFactory.shared.archives() else {
            return
        }
        archives.update(self)
    }
    
    func archivedVersion() -> Self? {
        guard let archives: ArchiveManager<Self> = try? ArchivesFactory.shared.archives() else {
            return nil
        }
        return archives.access(archiveWithKey: primaryKey)
    }
    
    func archiveArchivablePropertiesIfNeeded() {
        guard Self.archivePropertyBehavior != .ignore else { return }
        archiveArchivableProperties()
    }
    
    func archiveArchivableProperties() {
        var reflection = Mirror(reflecting: self)
        var superReflection: Mirror?
        repeat {
            for child in reflection.children {
                guard let archivable = child.value as? Archivable,
                      (Self.archivePropertyBehavior == .insertIfNotPresent && archivable.archivedVersion() == nil)
                        || Self.archivePropertyBehavior == .replaceExisting else { continue }
                archivable.updateArchive()
            }
            superReflection = reflection.superclassMirror
            reflection = superReflection ?? reflection
        }
        while superReflection != nil
    }
    
    func tryCopy() -> Self {
        guard type(of: self) is AnyClass else {
            return self
        }
        if let nsCopying = self as? NSCopying, let copy = nsCopying.copy(with: nil) as? Self {
            return copy
        }
        do {
            let data = try archiveData()
            return (try Self.decode(archive: data) as? Self) ?? self
        } catch {
            return self
        }
    }
}

public extension Archivable where Self: Codable {
    func archiveData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    static func decode(codableArchive data: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
    
    static func decode(archive data: Data) throws -> Archivable {
        return try decode(codableArchive: data)
    }
}

//
//  Archiver.swift
//  Vellum
//
//  Created by Nayanda Haberty on 14/01/21.
//

import Foundation

public protocol Archivist {
    associatedtype Archive: Archivable
    var maxSize: Int { get }
    var currentSize: Int { get }
    func latestAccessedTime(for key: String) -> Date?
    func deleteAllInvalidateArchives(invalidateTimeInterval: TimeInterval)
    func record(_ object: Archive)
    func update(_ object: Archive)
    func access(archiveWithKey key: String) -> Archive?
    func accessAll(limitedBy limit: Int) -> [Archive]
    func accessAll() -> [Archive]
    func delete(archiveWithKey key: String)
    func deleteAll()
    func process(queries: [Query<Archive>]) -> [Archive]
}

extension Archivist {
    public func findWhere(_ finder: (QueryFinder<Archive>) -> (QueryFinder<Archive>)) -> QueryBuilder<Self> {
        let queryBuilder = QueryBuilder(archiver: self)
        return queryBuilder.findWhere(finder)
    }
    
    public func sorted(_ sorter: (QuerySorter<Archive>) -> QuerySorter<Archive>) -> QueryBuilder<Self> {
        let queryBuilder = QueryBuilder(archiver: self)
        return queryBuilder.sorted(sorter)
    }
    
    public func limitResults(by count: Int) -> QueryBuilder<Self> {
        let queryBuilder = QueryBuilder(archiver: self)
        return queryBuilder.limitResults(by: count)
    }
}

public extension Archivist {
    
    func latestAccessedTime(for object: Archive) -> Date? {
        latestAccessedTime(for: object.primaryKey)
    }
    
    func insert(all objects: [Archive]) {
        objects.forEach {
            record($0)
        }
    }
    
    func update(_ object: Archive) {
        delete(archiveWithKey: object.primaryKey)
        record(object)
    }
    
    func insert(_ objects: Archive...) {
        insert(all: objects)
    }
    
    func delete(_ object: Archive) {
        delete(archiveWithKey: object.primaryKey)
    }
    
    func delete(all objects: [Archive]) {
        objects.forEach {
            delete($0)
        }
    }
    
    func delete(_ objects: Archive...) {
        delete(all: objects)
    }
    
    func delete(keys: String...) {
        delete(allKeys: keys)
    }
    func delete(allKeys objectsKeys: [String]) {
        objectsKeys.forEach {
            delete(archiveWithKey: $0)
        }
    }
}

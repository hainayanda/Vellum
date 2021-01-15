//
//  MemoryArchiver.swift
//  Vellum
//
//  Created by Nayanda Haberty on 14/01/21.
//

import Foundation

class MemoryArchives<Archive: Archivable>: Archivist {
    
    var maxSize: Int
    var currentSize: Int = 0
    
    lazy var memoryCache: [String: DateStampedWrapper<Archive>] = [:]
    
    init(maxSize: Int) {
        self.maxSize = maxSize
    }
    
    func latestAccessedTime(for key: String) -> Date? {
        memoryCache[key]?.dateStamp
    }
    
    func record(_ object: Archive) {
        let copy = object.tryCopy()
        let objectSize = copy.sizeOfData
        deleteArchivesIfNecessary(toAdd: objectSize)
        if memoryCache[copy.primaryKey] == nil {
            currentSize += objectSize
        }
        memoryCache[copy.primaryKey] = .init(wrapped: copy)
    }
    
    func access(archiveWithKey key: String) -> Archive? {
        guard let wrapper = memoryCache[key] else { return nil }
        wrapper.dateStamp = .init()
        return wrapper.wrapped
    }
    
    func accessAll(limitedBy limit: Int) -> [Archive]  {
        let count = limit
        guard memoryCache.count > count else {
            return accessAll()
        }
        return memoryCache.values.prefix(limit).compactMap {
            $0.dateStamp = .init()
            return $0.wrapped
        }
    }
    
    func accessAll() -> [Archive]  {
        return memoryCache.values.compactMap {
            $0.dateStamp = .init()
            return $0.wrapped
        }
    }
    
    func process(queries: [Query<Archive>]) -> [Archive]  {
        var results = accessAll()
        for query in queries {
            results = query.process(results: results)
        }
        return results
    }
    
    func delete(archiveWithKey key: String) {
        let removed = memoryCache.removeValue(forKey: key)
        currentSize -= removed?.wrapped.sizeOfData ?? 0
    }
    
    func deleteAll() {
        memoryCache.removeAll()
        currentSize = 0
    }
    
    func deleteAllInvalidateArchives(invalidateTimeInterval: TimeInterval) {
        let allObject = memoryCache.values.compactMap { $0.wrapped }
        let now = Date()
        allObject.forEach {
            guard let lastAccess = latestAccessedTime(for: $0),
                  lastAccess.addingTimeInterval(invalidateTimeInterval) > now else { return }
            delete($0)
        }
    }
    
    func deleteArchivesIfNecessary(toAdd objectSize: Int = 0) {
        guard objectSize + currentSize > maxSize else { return }
        let allObjects = memoryCache.values.sorted { $0.dateStamp.compare($1.dateStamp) == .orderedAscending }
            .compactMap { $0.wrapped }
        for cacheObject in allObjects {
            delete(cacheObject)
            if currentSize + objectSize <= maxSize {
                break
            }
        }
    }
}

class DateStampedWrapper<Wrapped> {
    var dateStamp: Date
    let wrapped: Wrapped
    
    init(wrapped: Wrapped, dateStamp: Date = .init()) {
        self.wrapped = wrapped
        self.dateStamp = dateStamp
    }
}

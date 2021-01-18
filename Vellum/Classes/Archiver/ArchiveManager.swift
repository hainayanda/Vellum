//
//  ArchiveManager.swift
//  Vellum
//
//  Created by Nayanda Haberty on 14/01/21.
//

import Foundation

public class ArchiveManager<Archive: Archivable>: Archivist {
    
    public var maxSize: DataSize { memoryArchives.maxSize + diskArchives.maxSize }
    public var currentSize: DataSize { memoryArchives.currentSize + diskArchives.currentSize }
    var memoryArchives: MemoryArchives<Archive>
    var diskArchives: DiskArchives<Archive>
    
    public init(maxMemorySize: DataSize, maxDiskSize: DataSize) throws {
        memoryArchives = .init(maxSize: maxMemorySize)
        diskArchives = try .init(maxSize: maxDiskSize)
    }
    
    public func latestAccessedTime(for key: String) -> Date? {
        memoryArchives.latestAccessedTime(for: key) ?? diskArchives.latestAccessedTime(for: key)
    }
    
    public func deleteAllInvalidateArchives(invalidateTimeInterval: TimeInterval) {
        memoryArchives.deleteAllInvalidateArchives(invalidateTimeInterval: invalidateTimeInterval)
        diskArchives.deleteAllInvalidateArchives(invalidateTimeInterval: invalidateTimeInterval)
    }
    
    public func record(_ object: Archive) {
        object.archiveArchivablePropertiesIfNeeded()
        memoryArchives.record(object)
        diskArchives.record(object)
    }
    
    public func update(_ object: Archive) {
        object.archiveArchivablePropertiesIfNeeded()
        memoryArchives.update(object)
        diskArchives.update(object)
    }
    
    public func access(archiveWithKey key: String) -> Archive? {
        guard let result = memoryArchives.access(archiveWithKey: key) else {
            guard let diskResult = diskArchives.access(archiveWithKey: key) else {
                return nil
            }
            memoryArchives.record(diskResult)
            return diskResult
        }
        return result
    }
    
    public func accessAll(limitedBy limit: Int) -> [Archive] {
        let memoryResult = memoryArchives.accessAll(limitedBy: limit)
        guard memoryResult.count < limit else {
            return memoryResult
        }
        let diskResult = diskArchives
            .accessAll(
                limitedBy: limit - memoryResult.count,
                updateIndex: true,
                except: memoryResult.compactMap { $0.primaryKey }
            )
        let results = memoryResult + diskResult
        return results
    }
    
    public func accessAll() -> [Archive] {
        let memoryResult = memoryArchives.accessAll()
        let diskResult = diskArchives
            .accessAll(
                updateIndex: true,
                except: memoryResult.compactMap { $0.primaryKey }
            )
        let results = memoryResult + diskResult
        return results
    }
    
    public func process(queries: [Query<Archive>]) -> [Archive] {
        let allMemory = memoryArchives.accessAll()
        let allDisk = diskArchives.accessAll(updateIndex: false, except: allMemory.compactMap { $0.primaryKey })
        var results = allMemory + allDisk
        for query in queries {
            results = query.process(results: results)
        }
        results.forEach { result in
            diskArchives.index.first { $0.wrapped == result.primaryKey }?.dateStamp = .init()
        }
        return results
    }
    
    public func delete(archiveWithKey key: String) {
        memoryArchives.delete(archiveWithKey: key)
        diskArchives.delete(archiveWithKey: key)
    }
    
    public func deleteAll() {
        memoryArchives.deleteAll()
        diskArchives.deleteAll()
    }
    
}

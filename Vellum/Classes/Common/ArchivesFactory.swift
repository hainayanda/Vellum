//
//  ArchiverFactory.swift
//  Vellum
//
//  Created by Nayanda Haberty on 14/01/21.
//

import Foundation

public class ArchivesFactory {
    public static var shared: ArchivesFactory = .init()
    public var defaultMaxMemorySize: Int = 1.megaByte
    public var defaultMaxDiskSize: Int = 2.megaByte
    var archiveManager: [Any] = []
    var repositoryManager: [Any] = []
    
    public func archives<Archive: Archivable>(
        for type: Archive.Type,
        trySetMaxMemorySize memorySize: Int = 0,
        trySetMaxDiskSize diskSize: Int = 0) throws -> ArchiveManager<Archive> {
        guard let found = archiveManager.first(where:{ $0 as? ArchiveManager<Archive> != nil }),
              let archivist = found as? ArchiveManager<Archive> else {
            let memorySize = memorySize <= 0 ? defaultMaxMemorySize : memorySize
            let diskSize = diskSize <= 0 ? defaultMaxDiskSize : diskSize
            let archivist = try ArchiveManager<Archive>(maxMemorySize: memorySize, maxDiskSize: diskSize)
            archiveManager.append(archivist)
            return archivist
        }
        return archivist
    }
    
    public func archives<Archive: Archivable>(
        trySetMaxMemorySize memorySize: Int = 0,
        trySetMaxDiskSize diskSize: Int = 0) throws -> ArchiveManager<Archive> {
        return try archives(for: Archive.self, trySetMaxMemorySize: memorySize, trySetMaxDiskSize: diskSize)
    }
    
}

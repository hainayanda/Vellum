//
//  DiskArchivableChache.swift
//  Vellum
//
//  Created by Nayanda Haberty on 22/08/22.
//

import Foundation

class ArchivableIndexComponent {
    static var dataSize: DataSize { UUID.archiveDataSize + Int.archiveDataSize + Date.archiveDataSize }
    let id: UUID
    var dateAccessed: Date
    
    var data: Data {
        id.archiveStorage().data
            .added(with: dateAccessed.archiveStorage().data)
    }
    
    init(id: UUID, dateAccessed: Date = Date()) {
        self.id = id
        self.dateAccessed = dateAccessed
    }
    
    init(from data: Data) throws {
        let idEndIndex = UUID.archiveDataSize.bytesCount
        let dateAccessedEndIndex = ArrayIndexComponent.dataSize.bytesCount
        guard let id = UUID(archiveData: data[0 ..< idEndIndex]),
              let dateAccessed: Date = Date(archiveData: data[idEndIndex ..< dateAccessedEndIndex]) else {
            fatalError()
        }
        self.id = id
        self.dateAccessed = dateAccessed
    }
}

class DiskArchivableChache<Archive: Archivable>: ArchiveChache {
    public let maxDataSize: DataSize
    public internal(set) var currentDataSize: DataSize
    
    let schemaFilePath: URL
    let indexFilePath: URL
    let chacheFilePath: URL
    var schema: ArchiveSchema?
    var indexes: [ArchivableIndexComponent] = []
    var singleArchiveSize: DataSize? {
        schema?.dataSize
    }
    
    init(maxDataSize: DataSize) throws {
        self.maxDataSize = maxDataSize
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
              let folderPath = URL(string: path.appending("\(Archive.self)")),
              folderPath.isFileURL else {
            fatalError()
        }
        schemaFilePath = folderPath.appendingPathComponent("schema").appendingPathExtension("scm")
        indexFilePath = folderPath.appendingPathComponent("index").appendingPathExtension("idx")
        chacheFilePath = folderPath.appendingPathComponent("chache").appendingPathExtension("vlm")
        
        try folderPath.createDirectoryIfNeeded()
        try schemaFilePath.createFileIfNeeded()
        try indexFilePath.createFileIfNeeded()
        try chacheFilePath.createFileIfNeeded()
        
        currentDataSize = chacheFilePath.fileSize
        
        do {
            try indexes = indexFilePath.readStream?.mapEachNext(maxBytesCount: ArchivableIndexComponent.dataSize.bytesCount) {
                try ArchivableIndexComponent(from: $0)
            } ?? []
            schema = try ArchiveSchema(from: try schemaFilePath.fileData())
        } catch {
            try reset()
        }
    }
    
    func store(_ archive: ArchiveValue, usingId id: UUID) throws {
        guard let archivable = archive as? Archive else {
            fatalError()
            return
        }
        let entity = try VellumEntityEncoder().encode(archivable)
        let schema = entity.schema
        try resetIfNeeded(forNewSchema: schema)
        guard let index = indexOf(id: id, for: schema) else {
            try deleteLeastAccessedForStoreIfNeeded(for: schema)
            try store(newEntity: entity, usingId: id)
            return
        }
        try replace(entityAt: index.chacheIndex, with: entity)
        index.indexComponent.dateAccessed = Date()
        try updateIndexes()
    }
    
    func readArchive(withId id: UUID) -> ArchiveValue? {
        guard let schema = getAndResetIfSchemaDidNotValid() else {
            return nil
        }
        guard let index = indexOf(id: id, for: schema) else {
            return nil
        }
        guard let data = chacheFilePath.readStream?.read(atNext: index.chacheIndex, targetLength: schema.dataSize.bytesCount) else {
            try? reset()
            return nil
        }
        do {
            let archive = try Archive.init(archiveDataCompatible: data)
            try updateIndexes()
            index.indexComponent.dateAccessed = Date()
            return archive
        } catch {
            return nil
        }
    }
    
    private func store(newEntity: ArchiveEntity, usingId id: UUID) throws {
        try chacheFilePath.appendStream?.writeOperation {
            try $0.write(data: newEntity.data)
        }
        indexes.append(.init(id: id))
        try updateIndexes()
    }
    
    private func replace(entityAt index: Int, with newEntity: ArchiveEntity) throws {
        let newData = newEntity.data
        let endIndex = index + newData.dataSize.bytesCount
        var chacheData = try chacheFilePath.fileData()
        chacheData[index ..< endIndex] = newEntity.data
        try chacheFilePath.deleteFileOrDirectoryIfNeeded()
        chacheFilePath.createFileWith(data: chacheData)
    }
    
    private func indexOf(id: UUID, for schema: ArchiveSchema) -> (indexComponent: ArchivableIndexComponent, chacheIndex: Int)? {
        guard let index = indexes.firstIndex(where: { $0.id == id }),
                let indexComponent = indexes[safe: index] else {
            return nil
        }
        return (indexComponent, index * schema.dataSize.bytesCount)
    }
    
    private func getAndResetIfSchemaDidNotValid() -> ArchiveSchema? {
        guard let schema = schema else {
            try? reset()
            return nil
        }
        return schema
    }
    
    private func resetIfNeeded(forNewSchema schema: ArchiveSchema) throws {
        if let currentSchema = self.schema, currentSchema == schema {
            return
        }
        try reset()
        self.schema = schema
    }
    
    private func deleteLeastAccessedForStoreIfNeeded(for schema: ArchiveSchema) throws {
        let targetDataSize = currentDataSize - schema.dataSize
        guard currentDataSize > targetDataSize else { return }
        let removed = indexes.enumerated().sorted { $0.element.dateAccessed < $1.element.dateAccessed }.first
        guard let removed = removed else {
            fatalError()
        }
        let startIndex = removed.offset * schema.dataSize.bytesCount
        let endIndex = startIndex + schema.dataSize.bytesCount
        var chacheData = try chacheFilePath.fileData()
        chacheData.removeSubrange(startIndex ..< endIndex)
        try chacheFilePath.deleteFileOrDirectoryIfNeeded()
        chacheFilePath.createFileWith(data: chacheData)
    }
    
    private func updateIndexes() throws {
        let indexData = indexes.reduce(Data()) { partialResult, component in
            partialResult.added(with: component.data)
        }
        try indexFilePath.deleteFileOrDirectoryIfNeeded()
        indexFilePath.createFileWith(data: indexData)
    }
    
    private func reset() throws {
        schema = nil
        indexes = []
        
        try chacheFilePath.deleteFileOrDirectoryIfNeeded()
        try schemaFilePath.deleteFileOrDirectoryIfNeeded()
        try indexFilePath.deleteFileOrDirectoryIfNeeded()
        
        try chacheFilePath.createFileIfNeeded()
        try schemaFilePath.createFileIfNeeded()
        try indexFilePath.createFileIfNeeded()
    }
}


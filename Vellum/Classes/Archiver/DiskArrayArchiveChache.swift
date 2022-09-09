//
//  DiskArrayArchiveChache.swift
//  Vellum
//
//  Created by Nayanda Haberty on 18/08/22.
//

import Foundation

class ArrayIndexComponent {
    static var dataSize: DataSize { UUID.archiveDataSize + Int.archiveDataSize + Date.archiveDataSize }
    let id: UUID
    let bytesLength: UInt
    var dateAccessed: Date
    
    var data: Data {
        id.archiveStorage().data
            .added(with: bytesLength.archiveStorage().data)
            .added(with: dateAccessed.archiveStorage().data)
    }
    
    init(id: UUID, bytesLength: UInt, dateAccessed: Date = Date()) {
        self.id = id
        self.bytesLength = bytesLength
        self.dateAccessed = dateAccessed
    }
    
    init(from data: Data) throws {
        let idEndIndex = UUID.archiveDataSize.bytesCount
        let bytesLengthEndIndex = idEndIndex + Int.archiveDataSize.bytesCount
        let dateAccessedEndIndex = ArrayIndexComponent.dataSize.bytesCount
        guard let id = UUID(archiveData: data[0 ..< idEndIndex]),
              let bytesLength: UInt = UInt(archiveData: data[idEndIndex ..< bytesLengthEndIndex]),
              let dateAccessed: Date = Date(archiveData: data[bytesLengthEndIndex ..< dateAccessedEndIndex]) else {
            fatalError()
        }
        self.id = id
        self.bytesLength = bytesLength
        self.dateAccessed = dateAccessed
    }
}

class DiskArrayArchiveChache<Element: ArchiveValue>: ArchiveChache {
    public let maxDataSize: DataSize
    public var currentDataSize: DataSize { chacheFilePath.fileSize }
    
    let indexFilePath: URL
    let chacheFilePath: URL
    var indexes: [ArrayIndexComponent] = []
    
    init(maxDataSize: DataSize) throws {
        self.maxDataSize = maxDataSize
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
              let folderPath = URL(string: path.appending("Array_of_\(Element.self)")),
              folderPath.isFileURL else {
            fatalError()
        }
        indexFilePath = folderPath.appendingPathComponent("index").appendingPathExtension("idx")
        chacheFilePath = folderPath.appendingPathComponent("chache").appendingPathExtension("vlm")
        
        try folderPath.createDirectoryIfNeeded()
        try indexFilePath.createFileIfNeeded()
        try chacheFilePath.createFileIfNeeded()
        
        do {
            try indexes = indexFilePath.readStream?.mapEachNext(maxBytesCount: ArrayIndexComponent.dataSize.bytesCount) {
                try ArrayIndexComponent(from: $0)
            } ?? []
        } catch {
            indexes = []
            try reset()
        }
    }
    
    func store(_ archive: ArchiveValue, usingId id: UUID) throws {
        guard let array: [Element] = archive as? [Element] else {
            fatalError()
            return
        }
        let data = array.reduce(Data()) { partialData, element in
            partialData.added(with: element.archiveStorage().data)
        }
        guard let indexComponent = indexOf(id: id) else {
            try store(newArrayData: data, usingId: id)
            indexes.append(.init(id: id, bytesLength: UInt(data.count)))
            try updateIndexes()
            return
        }
        try replace(arrayAt: indexComponent.start, endIndex: indexComponent.end, with: data)
        indexComponent.component.dateAccessed = Date()
        try updateIndexes()
    }
    
    func readArchive(withId id: UUID) -> ArchiveValue? {
        guard let indexComponent = indexOf(id: id) else { return nil }
        guard let data = chacheFilePath.readStream?.read(atNext: indexComponent.start, targetLength: indexComponent.end) else {
            try? reset()
            return nil
        }
        let array = [Element].init(arrayArchiveData: data)
        do {
            try updateIndexes()
            indexComponent.component.dateAccessed = Date()
            return array
        } catch {
            return nil
        }
    }
    
    private func store(newArrayData data: Data, usingId id: UUID) throws {
        try deleteLeastAccessedUntil(fitForSize: data.dataSize)
        guard let stream = chacheFilePath.appendStream else {
            fatalError()
        }
        try stream.writeOperation { outputStream in
            try outputStream.write(data: data)
        }
    }
    
    private func replace(arrayAt index: Int, endIndex: Int, with newData: Data) throws {
        var chacheData = try chacheFilePath.fileData()
        chacheData[index ..< endIndex] = newData
        try chacheFilePath.deleteFileOrDirectoryIfNeeded()
        chacheFilePath.createFileWith(data: chacheData)
    }
    
    private func indexOf(id: UUID) -> (component: ArrayIndexComponent, start: Int, end: Int)? {
        var startIndex: UInt = 0
        for component in indexes {
            guard component.id == id else {
                startIndex += component.bytesLength
                continue
            }
            return (component, Int(startIndex), Int(startIndex + component.bytesLength))
        }
        return nil
    }
    
    private func deleteLeastAccessedUntil(fitForSize size: DataSize) throws {
        let targetSize = maxDataSize - size
        guard currentDataSize > targetSize else { return }
        
        let sizeToBeRemoved = currentDataSize - targetSize
        
        let sortedIndexes = indexes.enumerated().sorted { $0.element.dateAccessed < $1.element.dateAccessed }
        var neededRemoval: [EnumeratedSequence<[ArrayIndexComponent]>.Element] = []
        var sizeRemoved: DataSize = .zero
        
        for component in sortedIndexes {
            guard sizeRemoved > sizeToBeRemoved else {
                break
            }
            neededRemoval.append(component)
            sizeRemoved += Int(component.element.bytesLength).bytes
        }
        
        let sortedRemove = neededRemoval
            .sorted { $0.offset > $1.offset }
            .compactMap {
                indexOf(id: $0.element.id)
            }
        
        var chacheData = try chacheFilePath.fileData()
        for remove in sortedRemove {
            chacheData.removeSubrange(remove.start ..< remove.end)
            indexes = indexes.removedSameInstance(remove.component)
        }
        
        try chacheFilePath.deleteFileOrDirectoryIfNeeded()
        chacheFilePath.createFileWith(data: chacheData)
        try updateIndexes()
    }
    
    private func updateIndexes() throws {
        let indexData = indexes.reduce(Data()) { partialResult, component in
            partialResult.added(with: component.data)
        }
        try indexFilePath.deleteFileOrDirectoryIfNeeded()
        indexFilePath.createFileWith(data: indexData)
    }
    
    private func reset() throws {
        indexes = []
        
        try chacheFilePath.deleteFileOrDirectoryIfNeeded()
        try indexFilePath.deleteFileOrDirectoryIfNeeded()
        
        try chacheFilePath.createFileIfNeeded()
        try indexFilePath.createFileIfNeeded()
    }
}

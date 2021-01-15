//
//  DiskArchiver.swift
//  Vellum
//
//  Created by Nayanda Haberty on 14/01/21.
//

import Foundation

class DiskArchives<Archive: Archivable>: Archivist {
    
    var maxSize: Int
    private var _currentSize: Int = 0
    var currentSize: Int {
        get {
            return _currentSize
        }
        set {
            _currentSize = max(newValue, 0)
        }
    }
    var fileManager: FileManager = .default
    var diskPath: String
    let fileExtension: String = "vlm"
    var index: [DateStampedWrapper<String>] = []
    
    init(maxSize: Int) throws {
        self.maxSize = maxSize
        // will throw error if fail
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first as NSString? else {
            throw VellumError(errorDescription: "VellumError: fail creating DiskArchiver", failureReason: "Fail to get chaches directory")
        }
        self.diskPath = path.appendingPathComponent(Archive.archiveName)
        if isExist(forDirectoryPath: diskPath) {
            let fileNames = try getAllArchived(at: diskPath)
            currentSize = getAllSize(forFiles: fileNames)
            index = fileNames.compactMap { DateStampedWrapper(wrapped: $0, dateStamp: getFileLatestUpdate(named: $0)) }
        } else {
            try createDirectory(at: diskPath)
            index = []
        }
    }
    
    func latestAccessedTime(for key: String) -> Date? {
        guard isExist(forFileNamed: key) else { return nil }
        return getFileLatestUpdate(named: key)
    }
    
    func record(_ object: Archive) {
        doTry {
            let objectSize = object.sizeOfData
            if isExist(forFileNamed: object.primaryKey) {
                delete(archiveWithKey: object.primaryKey)
            } else {
                deleteArchivesIfNecessary(toAdd: objectSize)
            }
            createFile(named: object.primaryKey, contents: try object.archiveData())
            index.append(.init(wrapped: object.primaryKey))
            currentSize += objectSize
        }
    }
    
    func access(archiveWithKey key: String) -> Archive? {
        access(archiveWithKey: key, updateIndex: true)
    }
    
    func access(archiveWithKey key: String, updateIndex: Bool) -> Archive? {
        guard let index = self.index.first(where: { $0.wrapped == key }),
              isExist(forFileNamed: key) else {
            return nil
        }
        return doTry {
            let data = try readFile(named: key)
            let result = try Archive.decode(archive: data) as? Archive
            if updateIndex {
                try updateDate(forFileName: key)
                index.dateStamp = .init()
            }
            return result
        }
    }
    
    func accessAll(limitedBy limit: Int) -> [Archive] {
        accessAll(limitedBy: limit, updateIndex: true)
    }
    
    func accessAll() -> [Archive]  {
        accessAll(updateIndex: true)
    }
    
    func accessAll(limitedBy limit: Int? = nil, updateIndex: Bool, except: [String] = []) -> [Archive]  {
        var filteredIndex = index.filter { !except.contains($0.wrapped) }
        if let limit = limit, filteredIndex.count < limit {
            filteredIndex = Array(filteredIndex.prefix(limit))
        }
        return filteredIndex.compactMap {
            access(archiveWithKey: $0.wrapped, updateIndex: updateIndex)
        }
    }
    
    func process(queries: [Query<Archive>]) -> [Archive]  {
        var results = accessAll(updateIndex: false)
        for query in queries {
            results = query.process(results: results)
        }
        results.forEach { result in
            index.first { $0.wrapped == result.primaryKey }?.dateStamp = .init()
        }
        return results
    }
    
    func delete(archiveWithKey key: String) {
        guard index.contains(where: { $0.wrapped == key }) else {
            return
        }
        doTry {
            let size = try readFile(named: key).count
            try deleteFile(named: key)
            index.removeAll { $0.wrapped == key }
            currentSize -= size
        }
    }
    
    func deleteAllInvalidateArchives(invalidateTimeInterval: TimeInterval) {
        let now = Date()
        index.forEach {
            guard $0.dateStamp.addingTimeInterval(invalidateTimeInterval) > now else { return }
            delete(archiveWithKey: $0.wrapped)
        }
    }
    
    func deleteAll() {
        index.forEach { key in
            doTry {
                try deleteFile(named: key.wrapped)
            }
        }
        index.removeAll()
        currentSize = 0
    }
    
    func deleteArchivesIfNecessary(toAdd objectSize: Int = 0) {
        guard objectSize + currentSize > maxSize else { return }
        let indexes = self.index.sorted { $0.dateStamp.compare($1.dateStamp) == .orderedAscending }
            .compactMap { $0.wrapped }
        for index in indexes {
            delete(archiveWithKey: index)
            if currentSize + objectSize <= maxSize {
                break
            }
        }
    }
    
    func doTry(_ trying: () throws -> Void) {
        do {
            try trying()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func doTry<R>(_ trying: () throws -> R?) -> R? {
        do {
            return try trying()
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}

extension DiskArchives {
    func isExist(forDirectoryPath path: String) -> Bool{
        var isDirectory : ObjCBool = false
        let isExist = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue && isExist
    }
    
    func isExist(forFileNamed fileName: String) -> Bool {
        var isDirectory : ObjCBool = false
        let isExist = fileManager.fileExists(atPath: filePath(ofFileName: fileName), isDirectory: &isDirectory)
        return !isDirectory.boolValue && isExist
    }
    
    func createDirectory(at path: String) throws {
        let url = URL(fileURLWithPath: path)
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    
    func createFile(named fileName: String, contents: Data) {
        fileManager.createFile(atPath: filePath(ofFileName: fileName), contents: contents, attributes: [.creationDate: Date() as NSDate])
    }
    
    func updateDate(forFileName fileName: String) throws {
        try fileManager.setAttributes([.modificationDate: Date() as NSDate], ofItemAtPath: filePath(ofFileName: fileName))
    }
    
    func deleteFile(named fileName: String) throws {
        try fileManager.removeItem(atPath: filePath(ofFileName: fileName))
    }
    
    func deleteAll(files fileNames: [String]) throws {
        for fileName in fileNames {
            try deleteFile(named: fileName)
        }
    }
    
    func readFile(named fileName: String) throws -> Data {
        let url = URL(fileURLWithPath: filePath(ofFileName: fileName))
        return try Data(contentsOf: url)
    }
    
    func getFileSize(named fileName: String) -> Int {
        let attributes = try? fileManager.attributesOfItem(atPath: filePath(ofFileName: fileName))
        return (attributes?[.size] as? NSNumber)?.intValue ?? 0
    }
    
    func getFileLatestUpdate(named fileName: String) -> Date {
        let attributes = try? fileManager.attributesOfItem(atPath: filePath(ofFileName: fileName))
        let creationDate = (attributes?[.creationDate] as? NSDate) as Date? ?? .distantPast
        let modifyDate = (attributes?[.modificationDate] as? NSDate) as Date? ?? .distantPast
        return max(creationDate, modifyDate)
    }
    
    func getAllSize(forFiles fileNames: [String]) -> Int {
        fileNames.reduce(0) { currentSize, fileName in
            getFileSize(named: fileName) + currentSize
        }
    }
    
    func getAllArchived(at path: String) throws -> [String] {
        let url = URL(fileURLWithPath: path)
        let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
        return contents.filter {
            $0.pathExtension == fileExtension
        }.compactMap {
            $0.deletingPathExtension().lastPathComponent
        }
    }
    
    func filePath(ofFileName fileName: String) -> String {
        (diskPath as NSString).appendingPathComponent("\(fileName).\(fileExtension)")
    }
}

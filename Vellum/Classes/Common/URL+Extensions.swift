//
//  URL+Extensions.swift
//  Vellum
//
//  Created by Nayanda Haberty on 16/08/22.
//

import Foundation

extension URL {
    var isDirectoryExist: Bool {
        guard isFileURL else { return false }
        var isDirectory: ObjCBool = false
        let exist = FileManager.default.fileExists(atPath: absoluteString, isDirectory: &isDirectory)
        return exist && isDirectory.boolValue
    }
    
    var isFileExist: Bool {
        guard isFileURL else { return false }
        return FileManager.default.fileExists(atPath: absoluteString)
    }
    
    func createDirectoryIfNeeded() throws {
        guard !isDirectoryExist else { return }
        try FileManager.default.createDirectory(at: self, withIntermediateDirectories: true)
    }
    
    func createFileIfNeeded() throws {
        guard !isFileExist else { return }
        FileManager.default.createFile(atPath: absoluteString, contents: nil)
    }
    
    func createFileWith(data: Data) {
        FileManager.default.createFile(atPath: absoluteString, contents: data)
    }
    
    func deleteFileOrDirectoryIfNeeded() throws {
        guard !isFileExist else { return }
        guard FileManager.default.isDeletableFile(atPath: absoluteString) else {
            fatalError()
        }
        try FileManager.default.removeItem(at: self)
    }
    
    var fileSize: DataSize {
        let attributes = try? FileManager.default.attributesOfItem(atPath: absoluteString)
        return ((attributes?[.size] as? NSNumber)?.intValue ?? 0).bytes
    }
    
    var readStream: InputStream? {
        InputStream(url: self)
    }
    
    var appendStream: OutputStream? {
        OutputStream(url: self, append: true)
    }
    
    func fileData() throws -> Data {
        try Data(contentsOf: self)
    }
}

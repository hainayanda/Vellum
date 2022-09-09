//
//  ArchiveEntity.swift
//  Vellum
//
//  Created by Nayanda Haberty on 17/08/22.
//

import Foundation

// MARK: ArchiveEntity

public struct ArchiveEntity {
    public let properties: [Property]
    
    init(properties: [Property]) {
        self.properties = properties.sorted { $0.name < $1.name }
    }
}

extension ArchiveEntity {
    public struct Property {
        public let name: String
        public let data: Data
    }
}

extension ArchiveEntity {
    var schema: ArchiveSchema {
        let properties: [ArchiveSchema.Property] = self.properties.compactMap {
            .init(name: $0.name, dataSize: $0.data.dataSize)
        }
        return .init(properties: properties)
    }
    
    var data: Data {
        properties.reduce(Data()) { partialResult, property in
            partialResult.added(with: property.data)
        }
    }
}

// MARK: ArchiveSchema

struct ArchiveSchema: Hashable {
    let properties: [Property]
    
    init(properties: [Property]) {
        self.properties = properties.sorted { $0.name < $1.name }
    }
    
    init(from data: Data) throws {
        properties = try data.split(separator: 0x00).map { try Property(from: $0) }
    }
}

extension ArchiveSchema {
    struct Property: Hashable {
        let name: String
        let dataSize: DataSize
        
        init(name: String, dataSize: DataSize) {
            self.name = name
            self.dataSize = dataSize
        }
        
        init(from data: Data) throws {
            let endNameIndex = data.count - 8
            let propertyNameData = data[0 ..< endNameIndex]
            let sizeData = data[endNameIndex ..< data.count]
            guard let name = String(data: propertyNameData, encoding: .utf8) else {
                fatalError()
            }
            self.name = name
            self.dataSize = Int(sizeData.withUnsafeBytes{ $0.load(as: UInt.self) }).bytes
        }
        
        var data: Data? {
            var size = UInt(dataSize.bytesCount)
            return name.data(using: .utf8)?
                .added(with: Data(bytes: &size, count: MemoryLayout<UInt>.size))
        }
    }
}

extension ArchiveSchema {
    
    var dataSize: DataSize {
        properties.reduce(0.bytes) { partialResult, property in
            partialResult + property.dataSize
        }
    }
    
    func rangeOf(propertyName: String) -> Range<Int>? {
        var start: Int = 0
        for property in properties {
            guard property.name == propertyName else {
                start += property.dataSize.bytesCount
                continue
            }
            let end = start + property.dataSize.bytesCount
            return start ..< end
        }
        return nil
    }
    
    func entity(from data: Data) throws -> ArchiveEntity {
        guard data.dataSize == dataSize else {
            fatalError()
        }
        var offset: Int = 0
        let properties: [ArchiveEntity.Property] = self.properties.compactMap {
            let nextOffset = offset + $0.dataSize.bytesCount
            defer { offset = nextOffset }
            return .init(name: $0.name, data: data[offset ..< nextOffset])
        }
        return .init(properties: properties)
    }
}

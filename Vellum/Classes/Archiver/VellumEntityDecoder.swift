//
//  VellumEntityDecoder.swift
//  Vellum
//
//  Created by Nayanda Haberty on 17/08/22.
//

import Foundation
import Gizmo

// MARK: VellumEntityDecoder

class VellumEntityDecoder {
    func decode<T: Archivable>(_ type: T.Type,data: Data, using schema: ArchiveSchema) throws -> T {
        let entity = try schema.entity(from: data)
        let decoder = EntityDecoder(entity: entity)
        return try T.init(from: decoder)
    }
}

class EntityDecoder: Decoder {
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey : Any] = [:]
    let entity: ArchiveEntity
    
    init(entity: ArchiveEntity, codingPath: [CodingKey] = []) {
        self.entity = entity
        self.codingPath = codingPath
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer<Key>(ArchivableDecodingContainer<Key>(rootDecoder: self, entity: entity, codingPath: codingPath))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}

class ArchivableDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let codingPath: [CodingKey]
    let allKeys: [Key]
    let entity: ArchiveEntity
    let rootDecoder: EntityDecoder
    
    init(rootDecoder: EntityDecoder, entity: ArchiveEntity, codingPath: [CodingKey] = []) {
        self.entity = entity
        self.codingPath = codingPath
        self.allKeys = entity.properties.compactMap {
            Key(stringValue: $0.name)
        }
        self.rootDecoder = rootDecoder
    }
    
    func contains(_ key: Key) -> Bool {
        allKeys.contains { $0.stringValue == key.stringValue }
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        fatalError()
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool { try decodeArchive(type, forKey: key) }
    func decode(_ type: String.Type, forKey key: Key) throws -> String { try decodeArchive(type, forKey: key) }
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double { try decodeArchive(type, forKey: key) }
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float { try decodeArchive(type, forKey: key) }
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int { try decodeArchive(type, forKey: key) }
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 { try decodeArchive(type, forKey: key) }
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 { try decodeArchive(type, forKey: key) }
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 { try decodeArchive(type, forKey: key) }
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 { try decodeArchive(type, forKey: key) }
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt { try decodeArchive(type, forKey: key) }
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 { try decodeArchive(type, forKey: key) }
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 { try decodeArchive(type, forKey: key) }
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 { try decodeArchive(type, forKey: key) }
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 { try decodeArchive(type, forKey: key) }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        guard let property = entity.properties.first(where: { $0.name == key.stringValue }) else {
            fatalError()
        }
        guard let result = try T(archiveDataCompatible: property.data) else {
            fatalError()
        }
        return result
    }
    
    func decodeArchive<A: ArchiveValue>(_ type: A.Type, forKey key: Key) throws -> A {
        guard let property = entity.properties.first(where: { $0.name == key.stringValue }) else {
            fatalError()
        }
        guard let result = A(archiveData: property.data) else {
            fatalError()
        }
        return result
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func superDecoder() throws -> Decoder {
        rootDecoder
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        rootDecoder
    }
    
}

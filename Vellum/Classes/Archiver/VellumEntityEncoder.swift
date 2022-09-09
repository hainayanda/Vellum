//
//  VellumEntityEncoder.swift
//  Vellum
//
//  Created by Nayanda Haberty on 17/08/22.
//

import Foundation
import Gizmo

// MARK: VellumEntityEncoder

class VellumEntityEncoder {
    func encode<T: Archivable>(_ value: T) throws -> ArchiveEntity {
        let encoder = EntityEncoder()
        try value.encode(to: encoder)
        return try encoder.extractEntity()
    }
}

// MARK: EntityEncoder

class EntityEncoder: Encoder {
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey : Any] = [:]
    var keyedContainers: [KeyedArchiveEncodingContainer] = []
    
    init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = ArchivableEncodingContainer<Key>(rootEncoder: self, codingPath: codingPath)
        self.keyedContainers.append(container)
        return KeyedEncodingContainer<Key>(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError()
    }
    
    func extractEntity() throws -> ArchiveEntity {
        let properties: [ArchiveEntity.Property] = try keyedContainers.reduce([]) { partialResult, container in
            partialResult.added(
                withContentsOf: try container.keyedStorage.map { pair in
                    try pair.value.prepareForStoring()
                    return .init(name: pair.key, data: pair.value.data)
                }
            )
        }
        return .init(properties: properties.uniqued(withHasher: { $0.name }))
    }
}

// MARK: ArchiveKeyedContainer

protocol KeyedArchiveEncodingContainer {
    var keyedStorage: [String: ArchiveStorage] { get }
}

class ArchivableEncodingContainer<Key: CodingKey>: KeyedArchiveEncodingContainer, KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey]
    var keyedStorage: [String: ArchiveStorage] = [:]
    var rootEncoder: EntityEncoder
    
    init(rootEncoder: EntityEncoder, codingPath: [CodingKey] = []) {
        self.rootEncoder = rootEncoder
        self.codingPath = codingPath
    }
    
    func encodeNil(forKey key: Key) throws { fatalError() }
    func encode(_ value: Bool, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: Bool?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: String, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: String?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: Double, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: Double?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: Float, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: Float?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: Int, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: Int?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: Int8, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: Int8?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: Int16, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: Int16?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: Int32, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: Int32?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: Int64, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: Int64?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: UInt, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: UInt?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: UInt8, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: UInt8?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: UInt16, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: UInt16?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: UInt32, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: UInt32?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encode(_ value: UInt64, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    func encodeIfPresent(_ value: UInt64?, forKey key: Key) throws { try encode(archiveValue: value, forKey: key) }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        guard let archiveValue = value as? ArchiveValue else {
            fatalError()
        }
        try encode(archiveValue: archiveValue, forKey: key)
    }
    
    func encodeIfPresent<T>(_ value: T?, forKey key: Key) throws where T : Encodable  {
        guard let archiveValue = value as? ArchiveValue else {
            fatalError()
        }
        try encode(archiveValue: archiveValue, forKey: key)
    }
    
    func encode(archiveValue: ArchiveValue, forKey key: Key) throws {
        keyedStorage[key.stringValue] = archiveValue.archiveStorage()
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError()
    }
    
    func superEncoder() -> Encoder {
        rootEncoder
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        rootEncoder
    }
}

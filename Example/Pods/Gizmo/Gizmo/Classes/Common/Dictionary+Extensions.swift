//
//  Dictionary+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation

public extension Dictionary {
    
    /// Map Dictionary keys to another keys
    /// Key generated must be unique, otherwise it will replace the duplicated value with the last one mapped
    /// - Complexity: O(*n*), where *n* is the length of this dictionary.
    /// - Parameter mapper: Closure that map the old keys to the new one
    /// - Returns: New dictionary with new set of keys
    @inlinable func mapKeys<NewKey: Hashable>(_ mapper: (Key) -> NewKey) -> Dictionary<NewKey, Value> {
        var newDictionary: [NewKey: Value] = [:]
        forEach { pair in
            let newKey = mapper(pair.key)
            newDictionary[newKey] = pair.value
        }
        return newDictionary
    }
    
    /// Map Dictionary keys to another keys
    /// If new key is nil, it will then ignore it and proceed with next key
    /// Key generated must be unique, otherwise it will replace the duplicated value with the last one mapped
    /// - Complexity: O(*n*), where *n* is the length of this dictionary
    /// - Parameter mapper: Closure that map the old keys to the new one
    /// - Returns: New dictionary with new set of keys
    @inlinable func compactMapKeys<NewKey: Hashable>(_ mapper: (Key) throws -> NewKey?) -> Dictionary<NewKey, Value> {
        var newDictionary: [NewKey: Value] = [:]
        forEach { pair in
            do {
                guard let newKey = try mapper(pair.key) else { return }
                newDictionary[newKey] = pair.value
            } catch {
                #if DEBUG
                print("fail to map key: \(pair.key) and value: \(pair.value)")
                #endif
            }
        }
        return newDictionary
    }
    
    /// Map Dictionary keys to another keys and values to another values
    /// Key generated must be unique, otherwise it will replace the duplicated value with the last one mapped
    /// - Complexity: O(*n*), where *n* is the length of this dictionary
    /// - Parameter mapper: Closure that map the old keys and values to the new one
    /// - Returns: New dictionary with new set of keys and values
    @inlinable func mapKeyValues<NewKey: Hashable, NewValue>(_ mapper: (Key, Value) -> (key: NewKey, value: NewValue)) -> Dictionary<NewKey, NewValue> {
        var newDictionary: [NewKey: NewValue] = [:]
        forEach { pair in
            let newPair = mapper(pair.key, pair.value)
            newDictionary[newPair.key] = newPair.value
        }
        return newDictionary
    }
    
    /// Map Dictionary keys to another keys and values to another values
    /// If new key and value is nil, it will then ignore it and proceed with next key
    /// Key generated must be unique, otherwise it will replace the duplicated value with the last one mapped
    /// - Complexity: O(*n*), where *n* is the length of this dictionary
    /// - Parameter mapper: Closure that map the old keys and values to the new one
    /// - Returns: New dictionary with new set of keys and values
    @inlinable func compactMapKeyValues<NewKey: Hashable, NewValue>(_ mapper: (Key, Value) throws -> (key: NewKey, value: NewValue)?) -> Dictionary<NewKey, NewValue> {
        var newDictionary: [NewKey: NewValue] = [:]
        forEach { pair in
            do {
                guard let newPair = try mapper(pair.key, pair.value) else { return }
                newDictionary[newPair.key] = newPair.value
            } catch {
                #if DEBUG
                print("fail to map key: \(pair.key) and value: \(pair.value)")
                #endif
            }
        }
        return newDictionary
    }
}

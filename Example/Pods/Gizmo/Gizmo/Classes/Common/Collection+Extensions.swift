//
//  Collection+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 26/07/22.
//

import Foundation

// MARK: Safe access

public extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Element? {
        get {
            whenIndexIsSafe(for: index) {
                self[index]
            }
        }
    }
}

public extension Collection {
    @inlinable var isNotEmpty: Bool {
        !isEmpty
    }
}

// MARK: Internal

extension Collection where Indices.Iterator.Element == Index {
    
    @inlinable func whenIndexIsSafe<Return>(for index: Index, do work: () -> Return) -> Return? {
        guard indices.contains(index) else { return nil }
        return work()
    }
}

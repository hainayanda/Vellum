//
//  Data+Extensions.swift
//  Vellum
//
//  Created by Nayanda Haberty on 16/08/22.
//

import Foundation

extension Data {
    var isNil: Bool {
        !contains { $0 != 0x00 }
    }
    
    func added(with data: Data) -> Data {
        var result = self
        result.append(data)
        return result
    }
    
    func added(with byte: UInt8) -> Data {
        var result = self
        result.append(Data([byte]))
        return result
    }
    
    func added<S: Sequence>(with bytes: S) -> Data where S.Element == UInt8 {
        var result = self
        result.append(Data(bytes))
        return result
    }
    
    func added(with buffer: UnsafeMutablePointer<UInt8>, count: Int) -> Data {
        var result = self
        result.append(buffer, count: count)
        return result
    }
    
    func forEach(maxBytesCount: Int, do readOperation: (Data) -> Void) {
        let iterations = count / maxBytesCount
        var currentOffset = 0
        (0 ..< iterations).forEach { iteration in
            let endOffset = Swift.min(currentOffset + maxBytesCount, count)
            readOperation(self[currentOffset ..< endOffset])
            currentOffset = endOffset
        }
    }
    
    func forEach(maxBytesCount: Int, do readOperation: (Data) throws -> Void) throws {
        let iterations = count / maxBytesCount
        var currentOffset = 0
        try (0 ..< iterations).forEach { iteration in
            let endOffset = Swift.min(currentOffset + maxBytesCount, count)
            try readOperation(self[currentOffset ..< endOffset])
            currentOffset = endOffset
        }
    }
    
    func mapEach<M>(maxBytesCount: Int, _ mapper: (Data) -> M) -> [M] {
        var result: [M] = []
        forEach(maxBytesCount: maxBytesCount) { data in
            result.append(mapper(data))
        }
        return result
    }
    
    func compactMapEach<M>(maxBytesCount: Int, _ mapper: (Data) -> M?) -> [M] {
        var result: [M] = []
        forEach(maxBytesCount: maxBytesCount) { data in
            guard let mapped = mapper(data) else { return }
            result.append(mapped)
        }
        return result
    }
    
    func mapEach<M>(maxBytesCount: Int, _ mapper: (Data) throws -> M) throws -> [M] {
        var result: [M] = []
        try forEach(maxBytesCount: maxBytesCount) { data in
            result.append(try mapper(data))
        }
        return result
    }
    
    func compactMapEach<M>(maxBytesCount: Int, _ mapper: (Data) throws -> M?) throws -> [M] {
        var result: [M] = []
        try forEach(maxBytesCount: maxBytesCount) { data in
            guard let mapped = try mapper(data) else { return }
            result.append(mapped)
        }
        return result
    }
    
    func reduceEach<R>(maxBytesCount: Int, into initialResult: R, _ reducer: (R, Data) -> R) -> R {
        var reduced: R = initialResult
        forEach(maxBytesCount: maxBytesCount) { data in
            reduced = reducer(reduced, data)
        }
        return reduced
    }
    
    func reduceEach<R>(maxBytesCount: Int, into initialResult: R, _ reducer: (R, Data) throws -> R) throws -> R {
        var reduced: R = initialResult
        try forEach(maxBytesCount: maxBytesCount) { data in
            reduced = try reducer(reduced, data)
        }
        return reduced
    }
}

//
//  Stream+Extensions.swift
//  Vellum
//
//  Created by Nayanda Haberty on 16/08/22.
//

import Foundation

extension InputStream {
    
    func autoCloseOpen(then doTask: (InputStream) -> Void) {
        open()
        doTask(self)
        close()
    }
    
    func read(atNext offset: Int, targetLength: Int) -> Data? {
        guard hasBytesAvailable else { return nil }
        if offset > 0 {
            let offsetBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: offset)
            defer { offsetBuffer.deallocate() }
            let byteRead = read(offsetBuffer, maxLength: offset)
            guard byteRead == offset else {
                return nil
            }
        }
        guard hasBytesAvailable else { return nil }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: targetLength)
        defer { buffer.deallocate() }
        guard read(buffer, maxLength: targetLength) == targetLength else {
            return nil
        }
        return Data(bytes: buffer, count: targetLength)
    }
}

// MARK: Iteration

extension InputStream {
    
    func forEachNext(maxBytesCount: Int, do readOperation: (Data) -> Void) {
        open()
        defer { close() }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxBytesCount)
        defer { buffer.deallocate() }
        while hasBytesAvailable {
            let byteRead = read(buffer, maxLength: maxBytesCount)
            guard byteRead > 0 else {
                return
            }
            readOperation(Data(bytes: buffer, count: byteRead))
        }
    }
    
    func forEachNext(maxBytesCount: Int, do readOperation: (Data) throws -> Void) throws {
        open()
        defer { close() }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxBytesCount)
        defer { buffer.deallocate() }
        while hasBytesAvailable {
            let byteRead = read(buffer, maxLength: maxBytesCount)
            guard byteRead > 0 else {
                return
            }
            try readOperation(Data(bytes: buffer, count: byteRead))
        }
    }
    
    func mapEachNext<M>(maxBytesCount: Int, _ mapper: (Data) -> M) -> [M] {
        var mapped: [M] = []
        forEachNext(maxBytesCount: maxBytesCount) { data in
            mapped.append(mapper(data))
        }
        return mapped
    }
    
    func mapEachNext<M>(maxBytesCount: Int, _ mapper: (Data) throws -> M) throws -> [M] {
        var mapped: [M] = []
        try forEachNext(maxBytesCount: maxBytesCount) { data in
            mapped.append(try mapper(data))
        }
        return mapped
    }
    
    func compactMapEachNext<M>(maxBytesCount: Int, _ mapper: (Data) -> M?) -> [M] {
        var mapped: [M] = []
        forEachNext(maxBytesCount: maxBytesCount) { data in
            guard let mappedData = mapper(data) else { return }
            mapped.append(mappedData)
        }
        return mapped
    }
    
    func compactMapEachNext<M>(maxBytesCount: Int, _ mapper: (Data) throws -> M?) throws -> [M] {
        var mapped: [M] = []
        try forEachNext(maxBytesCount: maxBytesCount) { data in
            guard let mappedData = try mapper(data) else { return }
            mapped.append(mappedData)
        }
        return mapped
    }
    
    func reduceEachNext<R>(maxBytesCount: Int, into initialResult: R, _ reducer: (R, Data) -> R) -> R {
        var reduced: R = initialResult
        forEachNext(maxBytesCount: maxBytesCount) { data in
            reduced = reducer(reduced, data)
        }
        return reduced
    }
    
    func reduceEachNext<R>(maxBytesCount: Int, into initialResult: R, _ reducer: (R, Data) throws -> R) throws -> R {
        var reduced: R = initialResult
        try forEachNext(maxBytesCount: maxBytesCount) { data in
            reduced = try reducer(reduced, data)
        }
        return reduced
    }
}

extension OutputStream {
    func write(data: Data) throws {
        try data.withUnsafeBytes {
            guard let address = $0.bindMemory(to: UInt8.self).baseAddress else {
                fatalError()
            }
            write(address, maxLength: data.count)
        }
    }
    
    func writeOperation(_ operation: (OutputStream) throws -> Void) throws {
        do {
            open()
            try operation(self)
            close()
        } catch {
            close()
            throw error
        }
    }
}

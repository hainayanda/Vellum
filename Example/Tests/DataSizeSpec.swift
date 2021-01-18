//
//  DataSizeSpec.swift
//  Vellum_Tests
//
//  Created by Nayanda Haberty on 18/01/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Vellum

class DataSizeSpec: QuickSpec {
    override func spec() {
        it("should calculate bytes correctly") {
            let bits = bitsPairs()
            for pair in bits {
                let dataBytes = DataSize(bytes: pair.key)
                expect(dataBytes.bits).to(equal(pair.value))
                let data: DataSize = .bits(pair.value)
                expect(data).to(equal(dataBytes))
                expect(data.bytes).to(equal(pair.key))
            }
            let nibbles = nibblePairs()
            for pair in nibbles {
                let dataBytes = DataSize(bytes: pair.key)
                expect(dataBytes.nibbles).to(equal(pair.value))
                let data: DataSize = .nibbles(pair.value)
                expect(data).to(equal(dataBytes))
                expect(data.bytes).to(equal(pair.key))
            }
            let bytes = bytesPairs()
            for pair in bytes {
                let dataBytes = DataSize(bytes: pair.key)
                expect(dataBytes.bytes).to(equal(pair.value))
                let data: DataSize = .bytes(pair.value)
                expect(data).to(equal(dataBytes))
                expect(data.bytes).to(equal(pair.key))
            }
            let kiloBytes = kiloBytesPairs()
            for pair in kiloBytes {
                let dataBytes = DataSize(bytes: pair.key)
                expect(dataBytes.kiloBytes).to(equal(pair.value))
                let data: DataSize = .kiloBytes(pair.value)
                expect(data).to(equal(dataBytes))
                expect(data.bytes).to(equal(pair.key))
            }
            let megaBytes = megaBytesPairs()
            for pair in megaBytes {
                let dataBytes = DataSize(bytes: pair.key)
                expect(dataBytes.megaBytes).to(equal(pair.value))
                let data: DataSize = .megaBytes(pair.value)
                expect(data).to(equal(dataBytes))
                expect(data.bytes).to(equal(pair.key))
            }
            let gigaBytes = gigaBytesPairs()
            for pair in gigaBytes {
                let dataBytes = DataSize(bytes: pair.key)
                expect(dataBytes.gigaBytes).to(equal(pair.value))
                let data: DataSize = .gigaBytes(pair.value)
                expect(data).to(equal(dataBytes))
                expect(data.bytes).to(equal(pair.key))
            }
        }
        it("should calculate bytes from bits correctly") {
            let pairs = nonByteBitsPairs()
            for pair in pairs {
                let dataBytes = DataSize.bits(pair.key)
                expect(dataBytes.bytes).to(equal(pair.value))
            }
        }
    }
}

func nonByteBitsPairs() -> [Int: Int] {
    [
        1 : 1,
        50 : 7,
        100 : 13,
        1000 : 125,
        1500 : 188,
        2000 : 250,
        2500 : 313,
        8000 : 1000,
        65500 : 8188
    ]
}

func bitsPairs() -> [Int: Int] {
    [
        128 : 128 * 8,
        256 : 256 * 8,
        512 : 512 * 8,
        1024 : 1024 * 8,
        1536 : 1536 * 8,
        2048 : 2048 * 8,
        2560 : 2560 * 8,
        8192 : 8192 * 8,
        65536 : 65536 * 8
    ]
}

func nibblePairs() -> [Int: Int] {
    [
        128 : 128 * 2,
        256 : 256 * 2,
        512 : 512 * 2,
        1024 : 1024 * 2,
        1536 : 1536 * 2,
        2048 : 2048 * 2,
        2560 : 2560 * 2,
        8192 : 8192 * 2,
        65536 : 65536 * 2
    ]
}

func bytesPairs() -> [Int: Int] {
    [
        128 : 128,
        256 : 256,
        512 : 512,
        1024 : 1024,
        1536 : 1536,
        2048 : 2048,
        2560 : 2560,
        8192 : 8192,
        65536 : 65536
    ]
}

func kiloBytesPairs() -> [Int: Double] {
    [
        128 : 0.125,
        256 : 0.25,
        512 : 0.5,
        1024 : 1,
        1536 : 1.5,
        2048 : 2,
        2560 : 2.5,
        8192 : 8,
        65536 : 64
    ]
}

func megaBytesPairs() -> [Int: Double] {
    [
        128 * 1024 : 0.125,
        256 * 1024 : 0.25,
        512 * 1024 : 0.5,
        1024 * 1024 : 1,
        1536 * 1024 : 1.5,
        2048 * 1024 : 2,
        2560 * 1024 : 2.5,
        8192 * 1024 : 8,
        65536 * 1024 : 64
    ]
}

func gigaBytesPairs() -> [Int: Double] {
    [
        128 * 1024 * 1024 : 0.125,
        256 * 1024 * 1024 : 0.25,
        512 * 1024 * 1024 : 0.5,
        1024 * 1024 * 1024 : 1,
        1536 * 1024 * 1024 : 1.5,
        2048 * 1024 * 1024 : 2,
        2560 * 1024 * 1024 : 2.5,
        8192 * 1024 * 1024 : 8,
        65536 * 1024 * 1024 : 64
    ]
}

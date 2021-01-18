//
//  Extensions.swift
//  Vellum_Tests
//
//  Created by Nayanda Haberty on 14/01/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

extension String {
    static func randomString(length: Int = 8) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}

extension Array where Element == Structure {
    static func random(size: Int) -> [Element] {
        var array: [Element] = []
        for _ in 0..<size {
            array.append(.random())
        }
        return array
    }
}

extension Array where Element == ObjectValidateable {
    static func random(size: Int, commonPrefix: String = "", countOfCommonPrefix: Int = 0, haveSuffix: Bool = true, countOfNils: Int = 0) -> [Element] {
        var array: [Element] = []
        for index in 0..<size {
            let string = index < countOfCommonPrefix ? "\(commonPrefix)\(haveSuffix ? String.randomString() : "")": String.randomString()
            let nullableString = index < countOfNils ? nil : String.randomString()
            array.append(.init(string: string, nullableString: nullableString, int: Int.random(in: -99..<100)))
        }
        return array.shuffled()
    }
    
    static func random(size: Int, countOfEmpty: Int = 0, countOfNils: Int = 0) -> [Element] {
        var array: [Element] = []
        for index in 0..<size {
            let string = index < countOfEmpty ? "": String.randomString()
            let nullableString = index < countOfNils ? nil : String.randomString()
            array.append(.init(string: string, nullableString: nullableString, int: Int.random(in: -99..<100)))
        }
        return array.shuffled()
    }
    
    static func random(size: Int, biggerThan number: Int, countOfBigger: Int) -> [Element] {
        var array: [Element] = []
        for index in 0..<size {
            let int = index < countOfBigger ? Int.random(in: number..<Int.max) : Int.random(in: Int.min..<number)
            array.append(.init(string: .randomString(), nullableString: .randomString(), int: int))
        }
        return array.shuffled()
    }
    
    static func random(size: Int, lessThan number: Int, countOfLesser: Int) -> [Element] {
        var array: [Element] = []
        for index in 0..<size {
            let int = index < countOfLesser ? Int.random(in: Int.min..<number) : Int.random(in: number..<Int.max)
            array.append(.init(string: .randomString(), nullableString: .randomString(), int: int))
        }
        return array.shuffled()
    }
    
    static func random(size: Int, equal number: Int, countOfEqual: Int) -> [Element] {
        var array: [Element] = []
        for index in 0..<size {
            let int = index < countOfEqual ? number : Int.random(in: number..<Int.max)
            array.append(.init(string: .randomString(), nullableString: .randomString(), int: int))
        }
        return array.shuffled()
    }
    
    static func random(size: Int, countOfNilOrEmpty: Int) -> [Element] {
        var array: [Element] = []
        for index in 0..<size {
            let nullableString = index < countOfNilOrEmpty ? (Bool.random() ? nil : "") : .randomString()
            array.append(.init(string: .randomString(), nullableString: nullableString, int: Int.random(in: -99..<100)))
        }
        return array.shuffled()
    }
}

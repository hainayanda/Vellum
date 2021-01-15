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


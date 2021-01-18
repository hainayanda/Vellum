//
//  QueryValidatorSpec.swift
//  Vellum_Tests
//
//  Created by Nayanda Haberty on 18/01/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Vellum

class QueryValidatorSpec: QuickSpec {
    override func spec() {
        var query: QueryFinder<ObjectValidateable>!
        beforeEach {
            query = .init()
        }
        afterEach {
            query = nil
        }
        it("should validate result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "some", countOfCommonPrefix: 5, countOfNils: 5)
            let queries = query.string(.isValid { $0.contains("some") })
                .nullableString(.isValid { $0.isNil }).queries
            expect(queries.count).to(equal(2))
            let result1 = queries[0].process(results: random)
            expect(result1.count).to(equal(5))
            result1.forEach {
                expect($0.string.contains("some")).to(beTrue())
            }
            let result2 = queries[1].process(results: random)
            expect(result2.count).to(equal(5))
            result1.forEach {
                expect($0.nullableString).to(beNil())
            }
        }
        it("should validate nil result") {
            let random: [ObjectValidateable] = .random(size: 10, countOfNils: 5)
            let queries = query.nullableString(.isNil()).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.nullableString).to(beNil())
            }
        }
        it("should validate not nil result") {
            let random: [ObjectValidateable] = .random(size: 10, countOfNils: 5)
            let queries = query.nullableString(.isNotNil()).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.nullableString == nil).to(beFalse())
            }
        }
        it("should validate equal result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "some", countOfCommonPrefix: 5, haveSuffix: false)
            let queries = query.string(.isEqual(with: "some")).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string).to(equal("some"))
            }
        }
        it("should validate not equal result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "some", countOfCommonPrefix: 5, haveSuffix: false)
            let queries = query.string(.isNotEqual(with: "some")).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string == "some").to(beFalse())
            }
        }
        it("should validate greater result") {
            let random: [ObjectValidateable] = .random(size: 10, biggerThan: 10, countOfBigger: 5)
            let queries = query.int(.greater(than: 10)).int(.greaterOrEqual(with: 10)).queries
            expect(queries.count).to(equal(2))
            let result = queries[1].process(results: queries[0].process(results: random))
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.int).to(beGreaterThan(10))
            }
        }
        it("should validate less result") {
            let random: [ObjectValidateable] = .random(size: 10, lessThan: 10, countOfLesser: 5)
            let queries = query.int(.less(than: 10)).int(.lessOrEqual(with: 10)).queries
            expect(queries.count).to(equal(2))
            let result = queries[1].process(results: queries[0].process(results: random))
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.int).to(beLessThan(10))
            }
        }
        it("should validate equal count result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "some", countOfCommonPrefix: 5, haveSuffix: false)
            let queries = query.string(.countEqual(with: 4)).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.count).to(equal(4))
            }
        }
        it("should validate less count result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "some", countOfCommonPrefix: 5, haveSuffix: false)
            let queries = query.string(.countLess(than: 5)).string(.countLessOrEqual(with: 5)).queries
            expect(queries.count).to(equal(2))
            let result = queries[1].process(results: queries[0].process(results: random))
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.count).to(beLessThan(5))
            }
        }
        it("should validate greater count result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "some", countOfCommonPrefix: 5, haveSuffix: false)
            let queries = query.string(.countGreater(than: 5)).string(.countGreaterOrEqual(with: 5)).queries
            expect(queries.count).to(equal(2))
            let result = queries[1].process(results: queries[0].process(results: random))
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.count).to(beGreaterThan(5))
            }
        }
        it("should validate empty count result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "", countOfCommonPrefix: 5, haveSuffix: false)
            let queries = query.string(.isEmpty()).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.count).to(equal(0))
            }
        }
        it("should validate not empty count result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "", countOfCommonPrefix: 5, haveSuffix: false)
            let queries = query.string(.isNotEmpty()).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.count).to(equal(8))
            }
        }
        it("should validate contains result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "$#%", countOfCommonPrefix: 5, haveSuffix: true)
            let queries = query.string(.contains(atLeastOne: ["$", "%"])).string(.contains(with: "$")).string(.contains("$", "#", "%")).queries
            expect(queries.count).to(equal(3))
            let result = queries[2].process(results: queries[1].process(results: queries[0].process(results: random)))
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.contains("$#%")).to(beTrue())
            }
        }
        it("should validate string result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "some", countOfCommonPrefix: 5, haveSuffix: true)
            let queries = query.string(.contains(string: "some")).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.contains("some")).to(beTrue())
            }
        }
        it("should validate string result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "Some", countOfCommonPrefix: 5, haveSuffix: true)
            let queries = query.string(.contains(string: "some", caseSensitive: false)).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.contains("Some")).to(beTrue())
            }
        }
        it("should validate string result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "some", countOfCommonPrefix: 5, haveSuffix: true)
            let queries = query.string(.matches(regex: "^some")).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.string.contains("some")).to(beTrue())
            }
        }
        it("should validate string result") {
            let random: [ObjectValidateable] = .random(size: 10, commonPrefix: "", countOfCommonPrefix: 5, haveSuffix: false, countOfNils: 5)
            let queries = query.nullableString(.isNilOrEmpty()).queries
            expect(queries.count).to(equal(1))
            let result = queries[0].process(results: random)
            expect(result.count).to(equal(5))
            result.forEach {
                expect($0.nullableString?.count ?? 0).to(equal(0))
            }
        }
    }
}

struct ObjectValidateable {
    var string: String
    var nullableString: String?
    var int: Int
}

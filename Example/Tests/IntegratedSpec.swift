//
//  IntegratedSpec.swift
//  Vellum_Tests
//
//  Created by Nayanda Haberty on 14/01/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Vellum

class IntegratedSpec: QuickSpec {
    override func spec() {
        var archives: ArchiveManager<Structure>!
        var innerArchives: ArchiveManager<InnerStructure>!
        beforeEach {
            archives = try! ArchivesFactory.shared.archives(trySetMaxMemorySize: 10.kiloByte, trySetMaxDiskSize: 20.kiloByte)
            innerArchives = try! ArchivesFactory.shared.archives(trySetMaxMemorySize: 10.kiloByte, trySetMaxDiskSize: 20.kiloByte)
        }
        afterEach {
            archives.deleteAll()
            innerArchives.deleteAll()
        }
        it("should store object") {
            let object: Structure = .random()
            archives.record(object)
            expect(archives.access(archiveWithKey: object.primaryKey)).to(equal(object))
            expect(archives.memoryArchives.access(archiveWithKey: object.primaryKey)).to(equal(object))
            expect(archives.diskArchives.access(archiveWithKey: object.primaryKey)).toEventually(equal(object))
        }
        it("should store all object") {
            let objects: [Structure] = .random(size: 5)
            for object in objects {
                archives.record(object)
                expect(archives.access(archiveWithKey: object.primaryKey)).to(equal(object))
                expect(archives.memoryArchives.access(archiveWithKey: object.primaryKey)).to(equal(object))
                expect(archives.diskArchives.access(archiveWithKey: object.primaryKey)).toEventually(equal(object))
            }
            let all = archives.accessAll()
            let memObjects = archives.memoryArchives.accessAll()
            let diskObjects = archives.diskArchives.accessAll()
            expect(all.count).to(equal(memObjects.count))
            expect(all.count).to(equal(diskObjects.count))
            for object in objects {
                expect(objects.contains(object)).to(beTrue())
                expect(memObjects.contains(object)).to(beTrue())
                expect(diskObjects.contains(object)).to(beTrue())
            }
        }
        it("should store just enough object") {
            let objects: [Structure] = .random(size: 100)
            for object in objects {
                archives.record(object)
                expect(archives.access(archiveWithKey: object.primaryKey)).to(equal(object))
                expect(archives.memoryArchives.access(archiveWithKey: object.primaryKey)).to(equal(object))
                expect(archives.diskArchives.access(archiveWithKey: object.primaryKey)).toEventually(equal(object))
            }
            let memObjects = archives.memoryArchives.accessAll()
            let diskObjects = archives.diskArchives.accessAll()
            expect(memObjects.isEmpty).to(beFalse())
            expect(diskObjects.isEmpty).to(beFalse())
            expect(objects.count).to(beGreaterThan(diskObjects.count))
            expect(diskObjects.count).to(beGreaterThan(memObjects.count))
            for object in memObjects {
                expect(objects.contains(object)).to(beTrue())
            }
            for object in diskObjects {
                expect(objects.contains(object)).to(beTrue())
            }
        }
        it("should sort object by queries") {
            let objects: [Structure] = .random(size: 100)
            for object in objects {
                archives.record(object)
            }
            let unsortedResults = archives.accessAll()
            let ascendingResults = archives.sorted { by in
                by.someNumber(.ascending)
            }.getResults()
            let descendingResults = archives.sorted { by in
                by.someNumber(.descending)
            }.getResults()
            expect(unsortedResults.isEmpty).to(beFalse())
            expect(ascendingResults.isEmpty).to(beFalse())
            expect(descendingResults.isEmpty).to(beFalse())
            expect(unsortedResults.count).to(equal(ascendingResults.count))
            expect(unsortedResults.count).to(equal(descendingResults.count))
            var latestNumber: Int = -1
            for object in ascendingResults {
                expect(object.someNumber).to(beGreaterThanOrEqualTo(latestNumber))
                expect(objects.contains(object)).to(beTrue())
                expect(unsortedResults.contains(object)).to(beTrue())
                latestNumber = object.someNumber
            }
            latestNumber = .max
            for object in descendingResults {
                expect(object.someNumber).to(beLessThanOrEqualTo(latestNumber))
                expect(objects.contains(object)).to(beTrue())
                expect(unsortedResults.contains(object)).to(beTrue())
                latestNumber = object.someNumber
            }
        }
        it("should find object by queries") {
            let objects: [Structure] = .random(size: 100)
            for object in objects {
                archives.record(object)
            }
            let allStored = archives.accessAll()
            expect(allStored.isEmpty).to(beFalse())
            for object in allStored {
                let equalResults = archives.findWhere { archive in
                    archive.someText(.isEqual(with: object.someText))
                }.getResults()
                let rangeResults = archives.findWhere { archive in
                    archive.someNumber(.greater(than: object.someNumber - 1))
                        .someNumber(.less(than: object.someNumber + 1))
                }.getResults()
                expect(equalResults.isEmpty).to(beFalse())
                expect(equalResults.contains(object)).to(beTrue())
                expect(rangeResults.isEmpty).to(beFalse())
                expect(rangeResults.contains(object)).to(beTrue())
            }
        }
        it("should combine queries") {
            let objects: [Structure] = .random(size: 100)
            for object in objects {
                archives.record(object)
            }
            let allStored = archives.accessAll()
            expect(allStored.isEmpty).to(beFalse())
            
            let firstResults = archives.findWhere { archive in
                archive.someNumber(.greater(than: 500))
            }.sorted { by in
                by.someNumber(.ascending)
            }.limitResults(by: 10)
            .getResults()
            
            expect(firstResults.count).to(beLessThanOrEqualTo(10))
            
            let secondResults = archives.findWhere { archive in
                archive.someNumber(.less(than: 500))
            }.sorted { by in
                by.someNumber(.descending)
            }.limitResults(by: 10)
            .getResults()
            
            expect(secondResults.count).to(beLessThanOrEqualTo(10))
            
            var latestNumber: Int = -1
            for object in firstResults {
                expect(object.someNumber).to(beGreaterThanOrEqualTo(latestNumber))
                expect(object.someNumber).to(beGreaterThan(500))
                expect(objects.contains(object)).to(beTrue())
                latestNumber = object.someNumber
            }
            latestNumber = .max
            for object in secondResults {
                expect(object.someNumber).to(beLessThanOrEqualTo(latestNumber))
                expect(object.someNumber).to(beLessThan(500))
                expect(objects.contains(object)).to(beTrue())
                latestNumber = object.someNumber
            }
        }
        it("should archiverd property") {
            let dummy = DummyWithStructure()
            let object: Structure = .random()
            dummy.structure = object
            expect(archives.access(archiveWithKey: object.primaryKey)).to(equal(object))
            dummy.structure = nil
            expect(archives.access(archiveWithKey: object.primaryKey)).to(beNil())
        }
        it("should archiverd property with key") {
            var object: Structure = .random()
            object.primaryKey = "key"
            archives.record(object)
            let dummy = DummyWithStructure()
            expect(dummy.keyedStructure).to(equal(object))
            dummy.keyedStructure = nil
            expect(archives.access(archiveWithKey: object.primaryKey)).to(beNil())
        }
    }
}

class DummyWithStructure {
    @Archived
    var structure: Structure?
    
    @Archived(initialPrimaryKey: "key")
    var keyedStructure: Structure?
}

struct Structure: ArchiveCodable, Equatable {
    var primaryKey: String
    var someNumber: Int
    var someText: String?
    var innerStructure: InnerStructure?
    
    static func random(with key: String = .randomString()) -> Structure {
        Structure(
            primaryKey: key,
            someNumber: .random(in: 0..<1000),
            someText: .randomString(length: .random(in: 50..<100)),
            innerStructure: .random()
        )
    }
    
    static func == (lhs: Structure, rhs: Structure) -> Bool {
        return lhs.primaryKey == rhs.primaryKey && lhs.someNumber == rhs.someNumber
            && lhs.someText == rhs.someText && lhs.innerStructure == rhs.innerStructure
    }
}

struct InnerStructure: ArchiveCodable, Equatable {
    var primaryKey: String
    var key: String = ""
    var someNumber: Int = -1
    var someText: String?
    
    static func random(with key: String = .randomString()) -> InnerStructure {
        InnerStructure(
            primaryKey: key,
            someNumber: .random(in: 0..<1000),
            someText: .randomString(length: .random(in: 50..<100))
        )
    }
    
    static func == (lhs: InnerStructure, rhs: InnerStructure) -> Bool {
        return lhs.primaryKey == rhs.primaryKey && lhs.someNumber == rhs.someNumber
            && lhs.someText == rhs.someText
    }
}

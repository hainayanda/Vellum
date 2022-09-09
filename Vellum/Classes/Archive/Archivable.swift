//
//  Archivable.swift
//  Vellum
//
//  Created by Nayanda Haberty on 17/08/22.
//

import Foundation

public protocol Archivable: ChachableArchiveValue, Codable { }

extension Archivable {
    
    public init?(archiveData: Data) {
        guard let id = UUID(archiveData: archiveData),
              let archive = staticChache.readArchive(withId: id) as? Self else {
            return nil
        }
        self = archive
    }
}

extension Decodable {
    init?(archiveDataCompatible: Data) throws {
        guard let archivable: ChachableArchiveValue = self as? ChachableArchiveValue else {
            fatalError()
        }
        guard let id = UUID(archiveData: archiveDataCompatible),
              let decodable = archivable.staticChache.readArchive(withId: id) as? Self else {
            return nil
        }
        self = decodable
    }
}

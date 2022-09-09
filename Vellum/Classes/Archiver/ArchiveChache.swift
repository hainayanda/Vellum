//
//  ArchiveChache.swift
//  Vellum
//
//  Created by Nayanda Haberty on 18/08/22.
//

import Foundation

public protocol ArchiveChache {
    var maxDataSize: DataSize { get }
    var currentDataSize: DataSize { get }
    func store(_ archive: ArchiveValue, usingId id: UUID) throws
    func readArchive(withId id: UUID) -> ArchiveValue?
}

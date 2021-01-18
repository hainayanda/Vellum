//
//  PropertyWrapper.swift
//  Vellum
//
//  Created by Nayanda Haberty on 14/01/21.
//

import Foundation

@propertyWrapper
public class Archived<Archive: Archivable> {
    public lazy var wrappedValue: Archive? = tryGetByInitialPrimaryKey() {
        didSet {
            guard let archivist = self.archivist else { return }
            if let archive = wrappedValue {
                archivist.record(archive)
            } else if let key = oldValue?.primaryKey {
                archivist.delete(archiveWithKey: key)
            }
        }
    }
    
    private var initialPrimaryKey: String?
    
    private var archivist: ArchiveManager<Archive>? {
        return try? ArchivesFactory.shared.archives()
    }
    
    public init(wrappedValue: Archive?) {
        self.wrappedValue = wrappedValue
        guard let archivist = self.archivist, let archive = wrappedValue else { return }
        archivist.record(archive)
    }
    
    public init(initialPrimaryKey key: String) {
        self.initialPrimaryKey = key
    }
    
    private func tryGetByInitialPrimaryKey() -> Archive? {
        guard let archivist = self.archivist,
              let initialPrimaryKey = initialPrimaryKey else { return nil }
        return archivist.access(archiveWithKey: initialPrimaryKey)
    }
    
}

//
//  UniqueSequence.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 01/08/22.
//

import Foundation

public class UniqueSequence<Element: Equatable> {
    public typealias Iterator = UniqueSequnceIterator<Element>
    
    var base: [Element]?
    lazy var uniqued: [Element] = {
        defer { base = nil }
        return base?.uniqued(where: ==) ?? []
    }()
    
    /// Get count of unique element in sequence
    /// - Complexity: O(*n*^2) on the first run when never accessed and O(1) on the any other occasion, where *n* is the length of base array
    public var count: Int {
        uniqued.count
    }
    
    public var underestimatedCount: Int {
        uniqued.underestimatedCount
    }
    
    init(base: [Element]) {
        self.base = base
    }
    
    public subscript(_ index: Int) -> Element {
        get {
            element(at: index)!
        }
    }
    
    public subscript(safe index: Int) -> Element? {
        get {
            element(at: index)
        }
    }
    
    /// Get index of element in this sequence
    /// - Complexity: O(*n*^2) on the first run when never accessed and O(*n*) on the any other occasion, where *n* is the length of base array
    /// - Parameter element: Element to be found
    /// - Returns: Index of element if found, nil if not found
    public func indexOf(element: Element) -> Int? {
        uniqued.firstIndex(of: element)
    }
    
    func element(at index: Int) -> Element? {
        uniqued[safe: index]
    }
}

public class UniqueHashableSequence<Element: Hashable>: UniqueSequence<Element> {
    public typealias Iterator = UniqueSequnceIterator<Element>
    
    var safeBase: [Element] { base ?? [] }
    var mapped: [Element: Int] = [:]
    var mappedIndexes: [Int] = []
    var lastMappingIndex: Int = -1
    var isFinishMapping: Bool {
        lastMappingIndex == safeBase.count - 1
    }
    
    /// Get count of unique element in sequence
    /// - Complexity: O(*n*) on the first run when never accessed and O(1) on the any other occasion, where *n* is the length of base array
    public override var count: Int {
        completeMappingIfNeeded()
        return mappedIndexes.count
    }
    
    /// Get index of element in this sequence
    /// - Complexity: O(*n*) on the first run when never accessed and O(1) when all element already mapped, where *n* is the index of element found in base array
    /// - Parameter element: Element to be found
    /// - Returns: Index of element if found, nil if not found
    public override func indexOf(element: Element) -> Int? {
        mapped[element] ?? partialMappingIfNeeded { value in
            guard value.element == element else { return .continueMap }
            return .returnValue(value.mappedIndex)
        }
    }
    
    override func element(at index: Int) -> Element? {
        if let indexMapped = mappedIndexes[safe: index] {
            return safeBase[indexMapped]
        }
        return partialMappingIfNeeded { value in
            guard value.mappedIndex == index else { return .continueMap }
            return .returnValue(value.element)
        }
    }
}

extension UniqueHashableSequence {
    
    enum PartialMappingIterationDecision<Return> {
        case continueMap
        case returnValue(Return)
    }
    
    struct PartialMappingValue {
        let realIndex: Int
        let mappedIndex: Int
        let element: Element
    }
    
    func completeMappingIfNeeded() {
        return partialMappingIfNeeded { _ in .continueMap } ?? Void()
    }
    
    func partialMappingIfNeeded<Return>(onIteration doDecide: (PartialMappingValue) -> PartialMappingIterationDecision<Return>) -> Return? {
        guard !isFinishMapping else { return nil }
        let start = lastMappingIndex + 1
        for index in start ..< safeBase.count {
            let elementFromBase = safeBase[index]
            lastMappingIndex = index
            guard mapped[elementFromBase] == nil else { continue }
            mappedIndexes.append(index)
            let mappedIndex = mappedIndexes.count - 1
            mapped[elementFromBase] = mappedIndex
            let decision = doDecide(PartialMappingValue(realIndex: index, mappedIndex: mappedIndex, element: elementFromBase))
            switch decision {
            case .continueMap:
                continue
            case .returnValue(let value):
                return value
            }
        }
        return nil
    }
}

extension UniqueSequence: Sequence {
    public func makeIterator() -> UniqueSequnceIterator<Element> {
        UniqueSequnceIterator(uniqueSequence: self)
    }
}

public struct UniqueSequnceIterator<Element: Equatable>: IteratorProtocol {
    var currentIndex: Int = 0
    var uniqueSequence: UniqueSequence<Element>
    
    public mutating func next() -> Element? {
        defer { currentIndex += 1 }
        return uniqueSequence.element(at: currentIndex)
    }
}

public extension Array where Element: Equatable {
    /// Create UniqueSequence object that will iterate uniquely
    /// - Complexity: O(1), it will be O(*n*^2) at average when iterated if never accessed before and O(*n*) on any other next iteration,  where *n* is the length of base array
    /// - Returns: UniqueSequence
    func uniqueSequence() -> UniqueSequence<Element> {
        UniqueSequence(base: self)
    }
}

public extension Array where Element: Hashable {
    /// Create UniqueSequence object that will iterate uniquely
    /// - Complexity: O(1), it will be O(*n*) when iterated,  where *n* is the length of base array
    /// - Returns: UniqueSequence
    func uniqueSequence() -> UniqueHashableSequence<Element> {
        UniqueHashableSequence(base: self)
    }
}

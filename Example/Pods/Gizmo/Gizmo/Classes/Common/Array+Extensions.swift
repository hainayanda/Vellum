//
//  Array+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation

// MARK: Functional mutation add

public extension Array {
    
    /// Create new array added with given element at the end of the array
    /// - Complexity: O(1)
    /// - Parameter element: Element added
    /// - Returns: New array with added element
    @inlinable func added(with element: Element) -> [Element] {
        mutatingWithNewArray { $0.append(element) }
    }
    
    /// Create new array added with given contents of the sequence at the end of the array
    /// - Complexity: O(*m*) on average, where *m* is the length of sequence
    /// - Parameter sequence: Sequence of the elements
    /// - Returns: New array with added sequence
    @inlinable func added<S: Sequence>(withContentsOf sequence: S) -> [Element] where S.Element == Element {
        mutatingWithNewArray { $0.append(contentsOf: sequence) }
    }
    
    /// Create new array added with given elements at the end of the array
    /// - Complexity: O(*m*) on average, where *m* is the length of elements
    /// - Parameter elements: Elements added
    /// - Returns: New array with added elements
    @inlinable func added(with elements: Element...) -> [Element] {
        added(withContentsOf: elements)
    }
    
    /// Create new array added with given elements at the given index
    /// - Complexity: O(*n*), where *n* is the length of arrays
    /// - Parameters:
    ///   - index: Index of the new element
    ///   - element: Element added
    /// - Returns: New array with added element
    @inlinable func added(at index: Index, with element: Element) -> [Element] {
        mutatingWithNewArray { $0.insert(element, at: index)}
    }
    
    /// Create new array added with given contents of the collection at the given index
    /// - Complexity: O(*n* + *m*), where *n* is the length of arrays and *m* is length of collection
    /// - Parameters:
    ///   - index: Index of the new element
    ///   - collection: Collection of the elements
    /// - Returns: New array with added collection
    @inlinable func added<C: Collection>(at index: Index, withContentsOf collection: C) -> [Element] where C.Element == Element {
        mutatingWithNewArray { $0.insert(contentsOf: collection, at: index)}
    }
    
    /// Create new array added with given elements at the given index
    /// - Complexity: O(*n* + *m*), where *n* is the length of arrays and *m* is length of elements
    /// - Parameters:
    ///   - index: Index of the new elements
    ///   - elements: Elements added
    /// - Returns: New array with added elements
    @inlinable func added(at index: Index, with elements: Element...) -> [Element] {
        added(at: index, withContentsOf: elements)
    }
}

public extension Array where Element: Equatable {
    
    /// Create new array added with given element at the end of the array if the element is not present in this array
    /// - Complexity: O(*n*), where *n* is the length of arrays
    /// - Parameter element: Element added
    /// - Returns: New array with added element
    @inlinable func addedIfUnique(with element: Element) -> [Element] {
        guard !contains(element) else { return self }
        return added(with: element)
    }
    
    /// Create new array added with given contents of the sequence at the end of the array if the content is not present in this array
    /// - Complexity: O(*n* *m*), where *n* is the length of arrays and *m* is length of elements
    /// - Parameter sequence: Sequence of the elements
    /// - Returns: New array with added sequence
    @inlinable func addedIfUnique<S: Sequence>(withContentsOf sequence: S) -> [Element] where S.Element == Element {
        sequence.reduce(self) { partialResult, element in
            partialResult.addedIfUnique(with: element)
        }
    }
    
    /// Create new array added with given elements at the end of the array if the element is not present in this array
    /// - Complexity: O(*n* *m*), where *n* is the length of arrays and *m* is length of elements
    /// - Parameter elements: Elements added
    /// - Returns: New array with added elements
    @inlinable func addedIfUnique(with elements: Element...) -> [Element] {
        addedIfUnique(withContentsOf: elements)
    }
    
    /// Create new array added with given elements at the given index if the element is not present in this array
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameters:
    ///   - index: Index of the new element
    ///   - element: Element added
    /// - Returns: New array with added element
    @inlinable func addedIfUnique(at index: Index, with element: Element) -> [Element] {
        guard !contains(element) else { return self }
        return added(at: index, with: element)
    }
    
    /// Create new array added with given contents of the collection at the given index if the content is not present in this array
    /// - Complexity: O(*n*(2*n* + *m*)) at worst, where *n* is the length of arrays and *m* is length of collection
    /// - Parameters:
    ///   - index: Index of the new element
    ///   - collection: Collection of the elements
    /// - Returns: New array with added collection
    @inlinable func addedIfUnique<C: Collection>(at index: Index, withContentsOf collection: C) -> [Element] where C.Element == Element {
        var currentIndex = index
        return collection.reduce(self) { partialResult, element in
            guard !partialResult.contains(element) else { return partialResult }
            defer { currentIndex += 1 }
            return partialResult.added(at: currentIndex, with: element)
        }
    }
    
    /// Create new array added with given elements at the given index if the element is not present in this array
    /// - Complexity: O(*n*(2*n* + *m*)) at worst, where *n* is the length of arrays and *m* is length of collection
    /// - Parameters:
    ///   - index: Index of the new elements
    ///   - elements: Elements added
    /// - Returns: New array with added elements
    @inlinable func addedIfUnique(at index: Index, with elements: Element...) -> [Element] {
        addedIfUnique(at: index, withContentsOf: elements)
    }
}

public extension Array where Element: AnyObject {
    
    /// Create new array added with given element at the end of the array if the element instance is not present in this array
    /// - Complexity: O(*n*) where *n* is the length of arrays
    /// - Parameter element: Element added
    /// - Returns: New array with added element
    @inlinable func addedIfUniqueInstance(with element: Element) -> [Element] {
        guard !contains(where: { $0 === element }) else { return self }
        return added(with: element)
    }
    
    /// Create new array added with given contents of the sequence at the end of the array if the content instance is not present in this array
    /// - Complexity: O(*n* + *m*) at average, where *n* is the length of arrays and *m* is length of sequence
    /// - Parameter sequence: Sequence of the elements
    /// - Returns: New array with added sequence
    @inlinable func addedIfUniqueInstance<S: Sequence>(withContentsOf sequence: S) -> [Element] where S.Element == Element {
        var mappedIdentifier: [ObjectIdentifier: Void] = [:]
        forEach { element in
            let identifier = ObjectIdentifier(element)
            mappedIdentifier[identifier] = ()
        }
        return sequence.reduce(self) { partialResult, element in
            let identifier = ObjectIdentifier(element)
            guard mappedIdentifier[identifier] == nil else {
                return partialResult
            }
            return partialResult.added(with: element)
        }
    }
    
    /// Create new array added with given elements at the end of the array if the element instance is not present in this array
    /// - Complexity: O(*n* + *m*) at average, where *n* is the length of arrays and *m* is length of sequence
    /// - Parameter elements: Elements added
    /// - Returns: New array with added elements
    @inlinable func addedIfUniqueInstance(with elements: Element...) -> [Element] {
        addedIfUniqueInstance(withContentsOf: elements)
    }
    
    /// Create new array added with given elements at the given index if the element instance is not present in this array
    /// - Complexity: O(2*n* + *m*) at average, where *n* is the length of arrays and *m* is length of elements
    /// - Parameters:
    ///   - index: Index of the new element
    ///   - element: Element added
    /// - Returns: New array with added element
    @inlinable func addedIfUniqueInstance(at index: Index, with element: Element) -> [Element] {
        guard !contains(where: { $0 === element }) else { return self }
        return added(at: index, with: element)
    }
    
    /// Create new array added with given contents of the collection at the given index if the content instance is not present in this array
    /// - Complexity: O(2*n* + *m*) at average, where *n* is the length of arrays and *m* is length of collection
    /// - Parameters:
    ///   - index: Index of the new element
    ///   - collection: Collection of the elements
    /// - Returns: New array with added collection
    @inlinable func addedIfUniqueInstance<C: Collection>(at index: Index, withContentsOf collection: C) -> [Element] where C.Element == Element {
        var currentIndex = index
        var mappedIdentifier: [ObjectIdentifier: Void] = [:]
        forEach { element in
            let identifier = ObjectIdentifier(element)
            mappedIdentifier[identifier] = ()
        }
        return collection.reduce(self) { partialResult, element in
            let identifier = ObjectIdentifier(element)
            guard mappedIdentifier[identifier] == nil else {
                return partialResult
            }
            defer { currentIndex += 1 }
            return partialResult.added(at: currentIndex, with: element)
        }
    }
    
    /// Create new array added with given elements at the given index if the element instance is not present in this array
    /// - Complexity: O(2*n* + *m*) at average, where *n* is the length of arrays and *m* is length of elements
    /// - Parameters:
    ///   - index: Index of the new elements
    ///   - elements: Elements added
    /// - Returns: New array with added elements
    @inlinable func addedIfUniqueInstance(at index: Index, with elements: Element...) -> [Element] {
        addedIfUniqueInstance(at: index, withContentsOf: elements)
    }
}

// MARK: Functional mutation remove

public extension Array {
    
    /// Create new array with removed element at given index
    /// - Complexity: O(*n*) where *n* is the length of arrays
    /// - Parameter index: Index to remove
    /// - Returns: New array with removed element
    func removed(at index: Index) -> [Element] {
        whenIndexIsSafe(for: index) {
            mutatingWithNewArray { $0.remove(at: index) }
        } ?? self
    }
    
    /// Create new array with removed element when element found
    /// - Complexity: O(*n*) where *n* is the length of arrays
    /// - Parameter found: Closure to check element needs to be removed
    /// - Returns: New array with removed element
    @inlinable func removed(ifFound found: (Element) -> Bool) -> [Element] {
        mutatingWithNewArray { $0.removeAll(where: found) }
    }
    
}

public extension Array where Element: Equatable {
    
    /// Create new array with removed element when same element found
    /// - Complexity: O(*n*) where *n* is the length of arrays
    /// - Parameter element: element to be removed
    /// - Returns: New array with removed element
    @inlinable func removed(_ element: Element) -> [Element] {
        removed { $0 == element }
    }
    
    /// Create new array with removed element when same element found
    /// - Complexity: O(*n* *m*) where *n* is the length of arrays and *m* is length of sequence
    /// - Parameter elements: elements to be removed
    /// - Returns: New array with removed element
    @inlinable func removed(_ elements: [Element]) -> [Element] {
        removed { elements.contains($0) }
    }
    
    /// Create new array with removed element when same element found
    /// - Complexity: O(*n* *m*) where *n* is the length of arrays and *m* is length of sequence
    /// - Parameter elements: elements to be removed
    /// - Returns: New array with removed element
    @inlinable func removed(_ elements: Element...) -> [Element] {
        removed(elements)
    }
}

public extension Array where Element: AnyObject {
    
    /// Create new array with removed element when same element instance found
    /// - Complexity: O(*n*) where *n* is the length of arrays
    /// - Parameter element: element to be removed
    /// - Returns: New array with removed element
    @inlinable func removedSameInstance(_ element: Element) -> [Element] {
        removed { $0 === element }
    }
    
    /// Create new array with removed element when same element instance found
    /// - Complexity: O(*n* + *m*) at average, where *n* is the length of arrays and *m* is length of sequence
    /// - Parameter elements: elements to be removed
    /// - Returns: New array with removed element
    @inlinable func removedSameInstance(in elements: [Element]) -> [Element] {
        var seen: [ObjectIdentifier: Void] = [:]
        for element in elements {
            let identifier = ObjectIdentifier(element)
            seen[identifier] = ()
        }
        return removed { element in
            seen[ObjectIdentifier(element)] != nil
        }
    }
    
    /// Create new array with removed element when same element instance found
    /// - Complexity: O(*n* + *m*) at average, where *n* is the length of arrays and *m* is length of sequence
    /// - Parameter elements: elements to be removed
    /// - Returns: New array with removed element
    @inlinable func removedSameInstance(_ elements: Element...) -> [Element] {
        removedSameInstance(in: elements)
    }
}

// MARK: Unique

public extension Array {
    
    /// Create new array with unique element coming from this array
    /// The order of the element will still be the same
    /// - Complexity: O(*n*^2) at average, where *n* is the length of arrays
    /// - Parameter consideredSame: Closure to check the element
    /// - Returns: New unique array
    @inlinable func uniqued(where consideredSame: (Element, Element) -> Bool) -> [Element] {
        reduce([]) { partialResult, element in
            guard !partialResult.contains(where: { consideredSame(element, $0) }) else {
                return partialResult
            }
            return partialResult.added(with: element)
        }
    }
    
    /// Create new array with unique element coming from this array
    /// The order of the element will still be the same
    /// - Complexity: O(*n*) at average, where *n* is the length of arrays
    /// - Parameter hasher: Closure to convert element to compatible hash
    /// - Returns:New unique array
    @inlinable func uniqued(withHasher hasher: (Element) -> AnyHashable) -> [Element] {
        var seen: [AnyHashable: Void] = [:]
        return compactMap { element in
            let hash = hasher(element)
            guard seen[hash] == nil else {
                return nil
            }
            seen[hash] = ()
            return element
        }
    }
}

public extension Array where Element: AnyObject {
    
    /// Create new array with unique element instance coming from this array
    /// The order of the element will still be the same
    /// - Complexity: O(*n*) at average, where *n* is the length of arrays
    /// The time complexity of the algorithm will be O(n) or on worst case scenario will be O(n log n)
    @inlinable var uniqueObjects: [Element] {
        uniqued(withHasher: { ObjectIdentifier($0) })
    }
}

public extension Array where Element: Hashable {
    
    /// Create new array with unique element coming from this array
    /// The order of the element will still be the same
    /// - Complexity: O(*n*) at average, where *n* is the length of arrays
    @inlinable var unique: [Element] {
        var seen: [Element: Void] = [:]
        return compactMap { element in
            guard seen[element] == nil else {
                return nil
            }
            seen[element] = ()
            return element
        }
    }
}

public extension Array where Element: Equatable {
    
    /// Create new array with unique element coming from this array
    /// The order of the element will still be the same
    /// - Complexity: O(*n*^2) at average,  where *n* is the length of base array
    @inlinable var unique: [Element] {
        uniqued(where: ==)
    }
}

// MARK: Difference

public extension Array {
    
    /// Returns a new array with the elements that are either in this array or in the given sequence, but not in both.
    /// It will use the given closure to compare the elements
    /// - Complexity: O(*n*^2 + *m*^2 + *m*), where *n* is the length of arrays and *m* is length of other array
    /// - Parameters:
    ///   - other: Other array
    ///   - consideredSame: Closure to check equality of the element
    /// - Returns: New array
    @inlinable func symetricDifference(with other: [Element], where consideredSame: (Element, Element) -> Bool) -> [Element] {
        substracted(by: other, where: consideredSame)
            .added(withContentsOf: other.substracted(by: self, where: consideredSame))
    }
    
    /// Returns a new array containing the elements of this array that do not occur in the given array.
    /// It will use the given closure to compare the elements
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameters:
    ///   - other: Other array
    ///   - consideredSame: Closure to check equality of the element
    /// - Returns: New array
    @inlinable func substracted(by other: [Element], where consideredSame: (Element, Element) -> Bool) -> [Element] {
        return compactMap { element in
            guard !other.contains(where: { consideredSame($0, element) }) else {
                return nil
            }
            return element
        }
    }
    
    /// Returns a new array containing the elements of this array that do not occur in the given array.
    /// It will use the given closure to compare the elements
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameters:
    ///   - other: Other array
    ///   - consideredSame: Closure to check equality of the element
    /// - Returns: New array
    @inlinable func notPresent(in other: [Element], where consideredSame: (Element, Element) -> Bool) -> [Element] {
        substracted(by: other, where: consideredSame)
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// It will use the given closure to compare the elements
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameters:
    ///   - other: Other array
    ///   - consideredSame: Closure to check equality of the element
    /// - Returns: New array
    @inlinable func intersection(with other: [Element], where consideredSame: (Element, Element) -> Bool) -> [Element] {
        compactMap { element in
            guard other.contains(where: { consideredSame($0, element) }) else {
                return nil
            }
            return element
        }
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// It will use the given closure to compare the elements
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameters:
    ///   - other: Other array
    ///   - consideredSame: Closure to check equality of the element
    /// - Returns: New array
    @inlinable func present(in other: [Element], where consideredSame: (Element, Element) -> Bool) -> [Element] {
        intersection(with: other, where: consideredSame)
    }
}

public extension Array {
    /// Returns a new array with the elements that are either in this array or in the given sequence, but not in both.
    /// It will use the given closure to generate hash of the elements for comparison.
    /// - Complexity: O(*n* + 2 *m*) on average, where *n* is the length of arrays and *m* is length of other array
    /// - Parameters:
    ///   - other: Other array
    ///   - hasher: Closure to generate hash from the elemen
    /// - Returns: New array
    func symetricDifference(with other: [Element], withHasher hasher: (Element) -> AnyHashable) -> [Element] {
        intermediateHashable(using: hasher)
            .symetricDifference(with: other.intermediateHashable(using: hasher))
            .map { $0.element }
    }
    
    /// Returns a new array containing the elements of this array that do not occur in the given array.
    /// It will use the given closure to generate hash of the elements for comparison.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameters:
    ///   - other: Other array
    ///   - hasher: Closure to generate hash from the elemen
    /// - Returns: New array
    func substracted(by other: [Element], withHasher hasher: (Element) -> AnyHashable) -> [Element] {
        intermediateHashable(using: hasher)
            .substracted(by: other.intermediateHashable(using: hasher))
            .map { $0.element }
    }
    
    /// Returns a new array containing the elements of this array that do not occur in the given array.
    /// It will use the given closure to generate hash of the elements for comparison.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameters:
    ///   - other: Other array
    ///   - hasher: Closure to generate hash from the elemen
    /// - Returns: New array
    @inlinable func notPresent(in other: [Element], withHasher hasher: (Element) -> AnyHashable) -> [Element] {
        substracted(by: other, withHasher: hasher)
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// It will use the given closure to generate hash of the elements for comparison.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameters:
    ///   - other: Other array
    ///   - hasher: Closure to generate hash from the elemen
    /// - Returns: New array
    func intersection(with other: [Element], withHasher hasher: (Element) -> AnyHashable) -> [Element] {
        intermediateHashable(using: hasher)
            .intersection(with: other.intermediateHashable(using: hasher))
            .map { $0.element }
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// It will use the given closure to generate hash of the elements for comparison.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameters:
    ///   - other: Other array
    ///   - hasher: Closure to generate hash from the elemen
    /// - Returns: New array
    @inlinable func present(in other: [Element], withHasher hasher: (Element) -> AnyHashable) -> [Element] {
        intersection(with: other, withHasher: hasher)
    }
}

public extension Array where Element: Hashable {
    
    /// Returns a new array with the elements that are either in this array or in the given sequence, but not in both.
    /// - Complexity: O(*n* + 2 *m*) on average, where *n* is the length of arrays and *m* is length of other array
    /// - Parameter other: Other Array
    /// - Returns: New array
    @inlinable func symetricDifference(with other: [Element]) -> [Element] {
        substracted(by: other)
            .added(withContentsOf: other.substracted(by: self))
    }
    
    /// Returns a new array containing the elements of this array that do not occur in the given array.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func substracted(by other: [Element]) -> [Element] {
        var mappedOther: [Element: Void] = [:]
        other.forEach { element in
            mappedOther[element] = ()
        }
        return compactMap { element in
            mappedOther[element] == nil ? element : nil
        }
    }
    
    /// Returns a new array containing the elements of this array that do not occur in the given array.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func notPresent(in other: [Element]) -> [Element] {
        substracted(by: other)
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func intersection(with other: [Element]) -> [Element] {
        var mappedOther: [Element: Void] = [:]
        other.forEach { element in
            mappedOther[element] = ()
        }
        return compactMap { element in
            mappedOther[element] == nil ? nil : element
        }
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func present(in other: [Element]) -> [Element] {
        intersection(with: other)
    }
}

public extension Array where Element: Equatable {
    
    /// Returns a new array with the elements that are either in this array or in the given sequence, but not in both.
    /// - Complexity: O(*n*^2 + *m*^2 + *m*), where *n* is the length of arrays and *m* is length of other array
    /// - Parameter other: Other Array
    /// - Returns: New array
    @inlinable func symetricDifference(with other: [Element]) -> [Element] {
        symetricDifference(with: other, where: ==)
    }
    
    /// Returns a new array containing the elements of this array that do not occur in the given array.
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func substracted(by other: [Element]) -> [Element] {
        substracted(by: other, where: ==)
    }
    
    /// Returns a new array containing the elements of this array that do not occur in the given array.
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func notPresent(in other: [Element]) -> [Element] {
        substracted(by: other)
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func intersection(with other: [Element]) -> [Element] {
        intersection(with: other, where: ==)
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// - Complexity: O(*n*^2), where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func present(in other: [Element]) -> [Element] {
        intersection(with: other)
    }
}

public extension Array where Element: AnyObject {
    
    /// Returns a new array with the elements instance that are either in this array or in the given sequence, but not in both.
    /// - Complexity: O(*n* + 2 *m*) on average, where *n* is the length of arrays and *m* is length of other array 
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func objectsSymetricDifference(with other: [Element]) -> [Element] {
        symetricDifference(with: other, withHasher: { ObjectIdentifier($0) })
    }
    
    /// Returns a new array containing the elements instance of this array that do not occur in the given array.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func objectsSubstracted(by other: [Element]) -> [Element] {
        substracted(by: other, withHasher: { ObjectIdentifier($0) })
    }
    
    /// Returns a new array containing the elements instance of this array that do not occur in the given array.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func objectsNotPresent(in other: [Element]) -> [Element] {
        objectsSubstracted(by: other)
    }
    
    /// Returns a new array with the elements that are common to both this array and the given array.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func objectsIntersection(with other: [Element]) -> [Element] {
        intersection(with: other, withHasher: { ObjectIdentifier($0) })
    }
    
    /// Returns a new array with the elements instance that are common to both this array and the given array.
    /// - Complexity: O(*n*) on average, where *n* is the length of arrays
    /// - Parameter other: Other array
    /// - Returns: New array
    @inlinable func objectsPresent(in other: [Element]) -> [Element] {
        objectsIntersection(with: other)
    }
}

// MARK: Internal

struct IntermediateHashable<Element>: Hashable {
    
    let element: Element
    let hashable: AnyHashable
    
    init(element: Element, hasher: (Element) -> AnyHashable) {
        self.hashable = hasher(element)
        self.element = element
    }
    
    @inlinable func hash(into hasher: inout Hasher) {
        hasher.combine(hashable)
    }
    
    static func == (lhs: IntermediateHashable<Element>, rhs: IntermediateHashable<Element>) -> Bool {
        lhs.hashable == rhs.hashable
    }
}

extension Array {
    
    @inlinable func mutatingWithNewArray(_ mutator: (inout [Element]) -> Void) -> [Element] {
        var newArray = self
        mutator(&newArray)
        return newArray
    }
}

extension Array {
    func intermediateHashable(using hasher: (Element) -> AnyHashable) -> [IntermediateHashable<Element>] {
        map { IntermediateHashable(element: $0, hasher: hasher) }
    }
}

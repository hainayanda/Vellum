//
//  Statistics.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 02/08/22.
//

import Foundation

// MARK: Median

public extension Array where Element: Comparable {
    
    /// Find median of the array if its sorted
    /// - Complexity: O((*n* / 2) log *n*), where *n* is the length of base array
    @inlinable var median: Median<Element> {
        guard isNotEmpty else { return .noMedian }
        guard count > 1 else {
            guard let median = self.first else {
                return .noMedian
            }
            return .single(median)
        }
        let medianIndex = count / 2
        let medianCount = medianIndex + 1
        var temporary = self
        
        for index in 0 ..< medianCount {
            var smallestIndex = index
            for compareIndex in index + 1 ..< count where temporary[smallestIndex] > temporary[compareIndex] {
                smallestIndex = compareIndex
            }
            temporary.swapAt(smallestIndex, index)
        }
        if count % 2 == 0 {
            return .double(temporary[medianIndex - 1], temporary[medianIndex])
        }
        return .single(temporary[medianIndex])
    }
}

// MARK: Sum

public extension Sequence where Element: AdditiveArithmetic {
    /// Sum all the elements in this array
    /// - Complexity: O(*n*)  on average, where *n* is the length of array
    @inlinable var sum: Element {
        reduce(.zero) { partialResult, element in
            partialResult + element
        }
    }
}

// MARK: Average

public extension Array where Element: FloatingPoint {
    /// Calculate average value of the array elements
    /// - Complexity: O(*n*)  on average, where *n* is the length of array
    @inlinable var average: Element {
        return sum / Element(self.count)
    }
}

public extension Array where Element: BinaryInteger {
    /// Calculate average value of the array elements
    /// - Complexity: O(*n*)  on average, where *n* is the length of array
    @inlinable var average: Element {
        return sum / Element(self.count)
    }
}

// MARK: Smallest and Biggest

public extension Sequence where Element: Comparable {
    
    /// Find the smallest element in this array
    /// - Complexity: O(*n*)  on average, where *n* is the length of array
    @inlinable var smallest: Element? {
        reduce(nil) { lastSmallest, element in
            guard let lastSmallest = lastSmallest else {
                return element
            }
            return lastSmallest > element ? element : lastSmallest
        }
    }
    
    /// Find the biggest element in this array
    /// - Complexity: O(*n*)  on average, where *n* is the length of array
    @inlinable var biggest: Element? {
        reduce(nil) { lastBiggest, element in
            guard let lastBiggest = lastBiggest else {
                return element
            }
            return lastBiggest < element ? element : lastBiggest
        }
    }
}

// MARK: Modus

public extension Sequence where Element: Hashable {
    /// Return the element that appears most often in this array
    /// - Complexity: O(*n*)  on average, where *n* is the length of array
    @inlinable var modus: Element? {
        var counted: [Element: Int] = [:]
        let lastModus: (element: Element?, count: Int) = (nil, 0)
        return reduce(lastModus) { lastModus, element in
            let currentCount = (counted[element] ?? 0) + 1
            counted[element] = currentCount
            return lastModus.count < currentCount ? (element, currentCount): lastModus
        }.element
    }
}

public extension Sequence {
    /// Return the element that appears most often in this array
    /// - Complexity: O(*n* log *n*)  on average, where *n* is the length of array
    /// - Parameter consideredSame: Closure used to compare the elements
    /// - Returns: Element that appears most often in this array
    @inlinable func modus(where consideredSame: (Element, Element) -> Bool) -> Element? {
        var remaining = Array(self)
        var lastModus: (element: Element?, count: Int) = (nil, 0)
        while let first = remaining.first {
            let lastRemainingCount = remaining.count
            remaining.removeAll { element in
                consideredSame(first, element)
            }
            let currentCount = lastRemainingCount - remaining.count
            lastModus = lastModus.count < currentCount ? (first, currentCount) : lastModus
        }
        return lastModus.element
    }
}

public extension Sequence where Element: Equatable {
    /// Return the element that appears most often in this array
    /// - Complexity: O(*n* log *n*)  on average, where *n* is the length of array
    @inlinable var modus: Element? {
        modus(where: ==)
    }
}

public extension Sequence where Element: Hashable {
    
    /// Return Dictionary of Element and Int which represent the element count in this array
    /// - Returns: Dictionary of Element and Int
    @inlinable func groupedByFrequency() -> [Element: Int] {
        reduce([:]) { partialResult, element in
            var result = partialResult
            result[element] = (result[element] ?? 0) + 1
            return result
        }
    }
}

// MARK: Model

public enum Median<Element: Comparable>: Equatable {
    case single(Element)
    case double(Element, Element)
    case noMedian
}

public extension Median where Element: BinaryInteger {
    @inlinable var value: Double? {
        switch self {
        case .single(let element):
            return Double(element)
        case .double(let element1, let element2):
            return Double(element1 + element2) / 2
        case .noMedian:
            return nil
        }
    }
}

public extension Median where Element == Double {
    @inlinable var value: Double? {
        switch self {
        case .single(let element):
            return element
        case .double(let element1, let element2):
            return (element1 + element2) / 2
        case .noMedian:
            return nil
        }
    }
}

public extension Median where Element == Float {
    @inlinable var value: Float? {
        switch self {
        case .single(let element):
            return element
        case .double(let element1, let element2):
            return (element1 + element2) / 2
        case .noMedian:
            return nil
        }
    }
}

#if canImport(UIKit)
import UIKit

public extension Median where Element == CGFloat {
    @inlinable var value: CGFloat? {
        switch self {
        case .single(let element):
            return element
        case .double(let element1, let element2):
            return (element1 + element2) / 2
        case .noMedian:
            return nil
        }
    }
}
#endif

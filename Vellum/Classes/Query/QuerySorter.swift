//
//  QuerySorter.swift
//  Vellum
//
//  Created by Nayanda Haberty on 16/01/21.
//

import Foundation

@dynamicMemberLookup
public class QuerySorter<Result> {
    public typealias Sorter = (QuerySortDirection) -> QuerySorter<Result>
    public typealias Comparator = (Result, Result) -> QueryCompareResult
    
    var query: Query<Result>?
    var lastQueryComparator: QueryComparator?
    
    public subscript<Property: Comparable>(dynamicMember keyPath: KeyPath<Result, Property>) -> Sorter {
        { [unowned self] direction in
            return manual(direction: direction) { left, right in
                if left[keyPath: keyPath] > right[keyPath: keyPath] {
                    return .leftGreaterThanRight
                } else if left[keyPath: keyPath] < right[keyPath: keyPath] {
                    return .leftLessThanRight
                }
                return .leftEqualWithRight
            }
        }
    }
    
    public func manual(direction: QuerySortDirection, by comparator: @escaping Comparator) -> QuerySorter<Result> {
        let query = QuerySortSequence<Result>(direction: direction, comparator: comparator)
        guard let lastQuery = lastQueryComparator else {
            self.query = query
            lastQueryComparator = query
            return self
        }
        lastQuery.nextSequence = query
        lastQueryComparator = query
        return self
    }
}

public enum QueryCompareResult {
    case leftGreaterThanRight
    case leftLessThanRight
    case leftEqualWithRight
}

public enum QuerySortDirection {
    case ascending
    case descending
}

protocol QueryComparator: class {
    var nextSequence: QueryComparator? { get set }
    func isAscending(first: Any, with second: Any) -> Bool
}

public class QuerySortSequence<Result>: Query<Result>, QueryComparator {
    var comparator: (Result, Result) -> QueryCompareResult
    var direction: QuerySortDirection
    var nextSequence: QueryComparator?
    
    init(direction: QuerySortDirection, comparator: @escaping (Result, Result) -> QueryCompareResult) {
        self.comparator = comparator
        self.direction = direction
    }
    
    func isAscending(first: Any, with second: Any) -> Bool {
        let firstResult = first as! Result
        let secondResult = second as! Result
        let result = comparator(firstResult, secondResult)
        switch result {
        case .leftLessThanRight:
            return direction == .ascending
        case .leftGreaterThanRight:
            return direction == .descending
        default:
            return nextSequence?.isAscending(first: first, with: second) ?? true
        }
    }
    
    public override func process(results: [Result]) -> [Result] {
        results.sorted(by: isAscending(first:with:))
    }
}

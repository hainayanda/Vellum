//
//  QueryFinder.swift
//  Vellum
//
//  Created by Nayanda Haberty on 16/01/21.
//

import Foundation

@dynamicMemberLookup
public class QueryFinder<Result> {
    public typealias QueryProperty<Property> = (QueryValidator<Result, Property>) -> QueryFinder<Result>
    
    var queries: [Query<Result>] = []
    
    public subscript<Property>(dynamicMember keyPath: KeyPath<Result, Property>) -> QueryProperty<Property> {
        { query in
            query.keyPath = keyPath
            self.queries.append(query)
            return self
        }
    }
}

public class QueryValidator<Result, Property>: Query<Result> {
    var keyPath: KeyPath<Result, Property>!
    var queryProcessor: (KeyPath<Result, Property>, [Result]) -> [Result]
    
    init(queryProcessor: @escaping (KeyPath<Result, Property>, [Result]) -> [Result]) {
        self.queryProcessor = queryProcessor
    }
    
    open override func process(results: [Result]) -> [Result] {
        queryProcessor(keyPath, results)
    }
    
    public static func isValid(_ validator: @escaping (Property) -> Bool) -> QueryValidator<Result, Property> {
        .init { (keyPath, results) -> [Result] in
            results.filter { result in
                validator(result[keyPath: keyPath])
            }
        }
    }
    
    public static func isNil() -> QueryValidator<Result, Property> {
        isValid { property in
            (property as? OptionalValidatable)?.isNil ?? false
        }
    }
    
    public static func isNotNil() -> QueryValidator<Result, Property> {
        isValid { property in
            (property as? OptionalValidatable)?.isNotNil ?? true
        }
    }
}

public extension QueryValidator where Property: Equatable {
    static func isEqual(with other: Property) -> QueryValidator<Result, Property> {
        .isValid {
            $0 == other
        }
    }
    
    static func isNotEqual(with other: Property) -> QueryValidator<Result, Property> {
        .isValid {
            $0 != other
        }
    }
}

public extension QueryValidator where Property: Comparable {
    static func greater(than other: Property) -> QueryValidator<Result, Property> {
        .isValid {
            $0 > other
        }
    }
    
    static func less(than other: Property) -> QueryValidator<Result, Property> {
        .isValid {
            $0 < other
        }
    }
    
    static func greaterOrEqual(with other: Property) -> QueryValidator<Result, Property> {
        .isValid {
            $0 >= other
        }
    }
    
    static func lessOrEqual(with other: Property) -> QueryValidator<Result, Property> {
        .isValid {
            $0 <= other
        }
    }
}

public extension QueryValidator where Property: Collection {
    static func countEqual(with count: Int) -> QueryValidator<Result, Property> {
        .isValid {
            $0.count == count
        }
    }
    
    static func countGreater(than count: Int) -> QueryValidator<Result, Property> {
        .isValid {
            $0.count > count
        }
    }
    
    static func countLess(than count: Int) -> QueryValidator<Result, Property> {
        .isValid {
            $0.count < count
        }
    }
    
    static func countGreaterOrEqual(with count: Int) -> QueryValidator<Result, Property> {
        .isValid {
            $0.count >= count
        }
    }
    
    static func countLessOrEqual(with count: Int) -> QueryValidator<Result, Property> {
        .isValid {
            $0.count <= count
        }
    }
    
    static func isEmpty() -> QueryValidator<Result, Property> {
        .isValid {
            $0.isEmpty
        }
    }
    
    static func isNotEmpty() -> QueryValidator<Result, Property> {
        .isValid {
            !$0.isEmpty
        }
    }
}

public extension QueryValidator where Property: Collection, Property.Element: Equatable {
    static func contains(with member: Property.Element) -> QueryValidator<Result, Property> {
        .isValid {
            $0.firstIndex(of: member) != nil
        }
    }
    
    static func contains(atLeastOne members: [Property.Element]) -> QueryValidator<Result, Property> {
        .isValid {
            for member in members where $0.firstIndex(of: member) != nil {
                return true
            }
            return false
        }
    }
    
    static func contains(all members: [Property.Element]) -> QueryValidator<Result, Property> {
        .isValid {
            for member in members where $0.firstIndex(of: member) == nil {
                return false
            }
            return true
        }
    }
    
    static func contains(_ members: Property.Element...) -> QueryValidator<Result, Property> {
        return .contains(all: members)
    }
}

public extension QueryValidator where Property == String {
    static func contains(string: String, caseSensitive: Bool = true) -> QueryValidator<Result, Property> {
        .isValid {
            if !caseSensitive {
                return $0.lowercased().contains(string.lowercased())
            }
            return $0.contains(string)
        }
    }
    
    static func matches(regex: String) -> QueryValidator<Result, Property> {
        .isValid {
            $0.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
        }
    }
}

public extension QueryValidator where Property == String? {
    static func isNilOrEmpty() -> QueryValidator<Result, Property> {
        .isValid {
            $0?.isEmpty ?? true
        }
    }
}

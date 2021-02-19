//
//  QueryBuilder.swift
//  Vellum
//
//  Created by Nayanda Haberty on 16/01/21.
//

import Foundation

public class Query<Result> {
    open func process(results: [Result]) -> [Result] {
        fatalError("Vellum.Query<Result>.process(results:) should be implemented")
    }
}

public class QueryBuilder<Queriable: Archivist> {
    public typealias Result = Queriable.Archive
    var queries: [Query<Result>] = []
    var archiver: Queriable
    
    init(archiver: Queriable) {
        self.archiver = archiver
    }
    
    public func findWhere(_ finder: (QueryFinder<Result>) -> QueryFinder<Result>) -> QueryBuilder<Queriable> {
        var queryFinder: QueryFinder<Result> = .init()
        queryFinder = finder(queryFinder)
        queries.append(contentsOf: queryFinder.queries)
        return self
    }
    
    public func sorted(_ sorter: (QuerySorter<Result>) -> QuerySorter<Result>) -> QueryBuilder<Queriable> {
        var querySorter: QuerySorter<Result> = .init()
        querySorter = sorter(querySorter)
        if let query = querySorter.query {
            queries.append(query)
        }
        return self
    }
    
    public func limitResults(by count: Int) -> QueryBuilder<Queriable> {
        queries.append(QueryLimiter(limit: count))
        return self
    }
    
    public func getResults() -> [Result] {
        archiver.process(queries: queries)
    }
    
    public func firstResult() -> Result? {
        getResults().first
    }
    
    public func lastResult() -> Result? {
        getResults().last
    }
}

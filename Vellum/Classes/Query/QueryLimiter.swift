//
//  QueryLimiter.swift
//  Vellum
//
//  Created by Nayanda Haberty on 16/01/21.
//

import Foundation

class QueryLimiter<Result>: Query<Result> {
    var limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    override func process(results: [Result]) -> [Result] {
        Array(results.prefix(limit))
    }
}

//
//  VellumError.swift
//  Vellum
//
//  Created by Nayanda Haberty on 14/01/21.
//

import Foundation

/// Error object generated from Vellum
public struct VellumError: LocalizedError {
    
    /// Description of error
    public let errorDescription: String?
    
    /// Reason of failure
    public let failureReason: String?
    
    init(errorDescription: String, failureReason: String? = nil) {
        self.errorDescription = errorDescription
        self.failureReason = failureReason
    }
}

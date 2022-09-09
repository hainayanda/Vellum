//
//  Data+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 11/08/22.
//

import Foundation

public extension Data {
    
    /// Generate JSON data from a JSON Object. If the object will not produce valid JSON then an exception will be thrown.
    ///
    /// The object must have the following properties:
    /// - Top level object is an NSArray or NSDictionary
    /// - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
    /// - All dictionary keys are NSStrings
    /// - NSNumbers are not NaN or infinity
    /// - Parameters:
    ///   - jsonObject: Valid JSON Object
    ///   - options: Writing Options
    @inlinable init(jsonObject: Any, options: JSONSerialization.WritingOptions = .fragmentsAllowed) throws {
        self = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
    }
    
    /// Generate JSON Object represented in Dictionary. If the data will not produce valid JSON then an exception will be thrown
    /// GizmoError.jsonTypeError will be thrown if the data contains JSON other than object
    /// - Parameter options: Reading options. Default will be allowFragments
    /// - Returns: Dictionary represent of JSON
    @inlinable func jsonToDictionary(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any] {
        let result = try jsonToValue(options: options)
        guard let dictResult = result as? Dictionary<String, Any> else {
            throw GizmoError.jsonTypeError(reason: "Data represent json other than object")
        }
        return dictResult
    }
    
    /// Generate JSON Array represented in Array. If the data will not produce valid JSON then an exception will be thrown
    /// GizmoError.jsonTypeError will be thrown if the data contains JSON other than array
    /// - Parameter options: Reading options. Default will be allowFragments
    /// - Returns: Array represent of JSON
    @inlinable func jsonToArray(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [Any] {
        let result = try jsonToValue(options: options)
        guard let arrayResult = result as? Array<Any> else {
            throw GizmoError.jsonTypeError(reason: "Data represent json other than array")
        }
        return arrayResult
    }
    
    /// Generate JSON Value. If the data will not produce valid JSON then an exception will be thrown.
    ///
    /// The object generated will be one of this:
    /// - NSArray
    /// - NSDictionary with NSStrings as its keys
    /// - NSString
    /// - NSNumber
    /// - NSNull
    /// - Parameter options: Reading options. Default will be allowFragments
    /// - Returns: JSON value from this data
    @inlinable func jsonToValue(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any {
        try JSONSerialization.jsonObject(with: self, options: options)
    }
}

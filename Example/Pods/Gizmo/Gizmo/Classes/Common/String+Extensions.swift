//
//  String+Extensions.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation
import CommonCrypto

public extension String {
    
    /// convert String to its base 64 encoded string
    @inlinable var asBase64: String {
        Data(self.utf8).base64EncodedString()
    }
}

// operation below are copied and edited from
// https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift

@inlinable public func ~= (lhs: String, rhs: String) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
    let range = NSRange(location: .zero, length: lhs.utf16.count)
    return regex.firstMatch(in: lhs, options: [], range: range) != nil
}

// Extension below are copied and edited from
// https://betterprogramming.pub/10-useful-swift-string-extensions-e4280e55a554

public extension String {
    
    /// Convert this string to md5
    @inlinable var md5: String? {
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        guard let data = self.data(using: .utf8) else { return nil }
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(digestLength))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return (0..<digestLength).map { String(format: "%02x", hash[$0]) }.joined()
    }
    
    /// Shortcut for ``NSLocalizedString(_:,tableName:,bundle:,value:,comment:) -> String``
    /// Returns the localized version of a string.
    /// - Parameters:
    ///   - key: An identifying value used to reference a localized string.
    ///   - tableName: The name of the table containing the localized string
    ///   - bundle: The bundle containing the table's strings file. The main bundle is used by default.
    ///   - value: A user-visible string to return when the localized string
    ///   - comment: A note to the translator describing the context where the localized string is presented to the user.
    /// - Returns: A localized version of the string
    @inlinable func localized(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
    
    /// True if string contains digit
    @inlinable var isContainsDigit: Bool {
        rangeOfCharacter(
            from: NSCharacterSet.decimalDigits,
            options: .literal, range: nil
        ) != nil
    }
    
    /// True if string contains letters
    @inlinable var isContainsLetters: Bool {
        rangeOfCharacter(
            from: NSCharacterSet.letters,
            options: .literal, range: nil
        ) != nil
    }
    
    /// True if string contains only digit
    @inlinable var isDigitOnly: Bool {
        rangeOfCharacter(
            from: NSCharacterSet.decimalDigits.inverted,
            options: .literal, range: nil
        ) == nil
    }
    
    /// True if string contains only letters
    @inlinable var isLettersOnly: Bool {
        rangeOfCharacter(
            from: NSCharacterSet.letters.inverted,
            options: .literal, range: nil
        ) == nil
    }
    
    /// True if string contains only alphaNumerics
    @inlinable var isAlphanumeric: Bool {
        rangeOfCharacter(
            from: NSCharacterSet.decimalDigits.union(NSCharacterSet.letters).inverted,
            options: .literal, range: nil
        ) == nil
    }
    
    /// True if string is valid email address
    @inlinable var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", String.emailRegEx).evaluate(with: self)
    }
}

public extension String {
    
    /// Generate JSON string from a JSON Object. If the object will not produce valid JSON then an exception will be thrown.The object must have the following properties:
    /// - Top level object is an NSArray or NSDictionary
    /// - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
    /// - All dictionary keys are NSStrings
    /// - NSNumbers are not NaN or infinity
    /// - Parameters:
    ///   - jsonObject: Valid JSON Object
    ///   - options: Writing Options
    @inlinable init(jsonObject: Any, options: JSONSerialization.WritingOptions = .fragmentsAllowed) throws {
        self = try .init(decoding: Data(jsonObject: jsonObject, options: options), as: UTF8.self)
    }
    
    /// Generate JSON Object represented in Dictionary. If the data will not produce valid JSON then an exception will be thrown
    /// GizmoError.encodingError will be thrown if the string encoding to data using utf-8 is failed
    /// GizmoError.jsonTypeError will be thrown if the data contains JSON other than array
    /// - Parameter options: Reading options. Default will be allowFragments
    /// - Returns: Array represent of JSON
    @inlinable func jsonToDictionary(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any] {
        try unsafeEncodeData(using: .utf8).jsonToDictionary()
    }
    
    /// Generate JSON Array represented in Array. If the data will not produce valid JSON then an exception will be thrown
    /// GizmoError.encodingError will be thrown if the string encoding to data using utf-8 is failed
    /// GizmoError.jsonTypeError will be thrown if the data contains JSON other than array
    /// - Parameter options: Reading options. Default will be allowFragments
    /// - Returns: Array represent of JSON
    @inlinable func jsonToArray(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [Any] {
        try unsafeEncodeData(using: .utf8).jsonToArray()
    }
    
    /// Generate JSON Value. If the data will not produce valid JSON then an exception will be thrown.
    /// GizmoError.encodingError will be thrown if the string encoding to data using utf-8 is failed
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
        try unsafeEncodeData(using: .utf8).jsonToValue()
    }
    
    /// Basically calling data(using:) but if its returns nil it will throw GizmoError.encodingError
    @inlinable func unsafeEncodeData(using encoding: Encoding) throws -> Data {
        guard let data = self.data(using: encoding) else {
            throw GizmoError.encodingError(reason: "Failed to create data from String using utf8 encoding")
        }
        return data
    }
}

public extension String {
    
    /// Regular expression matches with valid email address
    @inlinable static var emailRegEx: String {
        "^(?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
    }
    
    /// Regular expression matches with valid URL
    @inlinable static var urlRegEx: String {
        "^((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((?:\\/[\\+~%\\/\\.\\w\\-_]*)?\\??(?:[\\-\\+=&;%@\\.\\w_]*)#?(?:[\\.\\!\\/\\\\\\w]*))?)$"
    }
    
    /// Regular expression matches with valid ip v4 address
    @inlinable static var ipV4RegEx: String {
        "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$"
    }
    
    /// Regular expression matches with valid ip v6 address
    @inlinable static var ipV6RegEx: String {
        "^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$"
    }
}

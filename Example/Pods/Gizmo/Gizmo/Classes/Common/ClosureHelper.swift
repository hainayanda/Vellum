//
//  ClosureHelper.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 27/07/22.
//

import Foundation

public typealias ReturnClosure<Return> = () -> Return
public typealias ReturnSingleArgClosure<Argument, Return> = (Argument) -> Return
public typealias ReturnBiArgsClosure<Arg1, Arg2, Return> = (Arg1, Arg2) -> Return
public typealias ReturnTriArgsClosure<Arg1, Arg2, Arg3, Return> = (Arg1, Arg2, Arg3) -> Return
public typealias ReturnQuadArgsClosure<Arg1, Arg2, Arg3, Arg4, Return> = (Arg1, Arg2, Arg3, Arg4) -> Return

public typealias VoidClosure = ReturnClosure<Void>
public typealias Closure<Argument> = ReturnSingleArgClosure<Argument, Void>
public typealias BiArgsClosure<Arg1, Arg2> = ReturnBiArgsClosure<Arg1, Arg2, Void>
public typealias TriArgsClosure<Arg1, Arg2, Arg3> = ReturnTriArgsClosure<Arg1, Arg2, Arg3, Void>
public typealias QuadArgsClosure<Arg1, Arg2, Arg3, Arg4> = ReturnQuadArgsClosure<Arg1, Arg2, Arg3, Arg4, Void>

// MARK: Method As VoidClosure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with void closure
///   - method: The method that resemble with void closure
/// - Returns: Void closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject>(
    _ object: Object,
    _ method: @escaping (Object) -> VoidClosure) -> VoidClosure {
        { [weak object] in
            guard let object = object else { return }
            method(object)()
        }
    }

// MARK: Method As Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with one arguments closure
///   - method: The method that resemble with one arguments closure
/// - Returns: One arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Argument>(
    _ object: Object,
    _ method: @escaping (Object) -> Closure<Argument>) -> Closure<Argument> {
        { [weak object] arg in
            guard let object = object else { return }
            method(object)(arg)
        }
    }

// MARK: Method As Bi Arguments Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with two arguments closure
///   - method: The method that resemble with two arguments closure
/// - Returns: Two arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2>(
    _ object: Object,
    _ method: @escaping (Object) -> BiArgsClosure<Arg1, Arg2>) -> BiArgsClosure<Arg1, Arg2> {
        { [weak object] arg1, arg2 in
            guard let object = object else { return }
            method(object)(arg1, arg2)
        }
    }

// MARK: Method As Tri Arguments Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with two arguments closure
///   - method: The method that resemble with two arguments closure
/// - Returns: Two arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2, Arg3>(
    _ object: Object,
    _ method: @escaping (Object) -> TriArgsClosure<Arg1, Arg2, Arg3>) -> TriArgsClosure<Arg1, Arg2, Arg3> {
        { [weak object] arg1, arg2, arg3 in
            guard let object = object else { return }
            method(object)(arg1, arg2, arg3)
        }
    }

// MARK: Method As Quad Arguments Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with two arguments closure
///   - method: The method that resemble with two arguments closure
/// - Returns: Two arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2, Arg3, Arg4>(
    _ object: Object,
    _ method: @escaping (Object) -> QuadArgsClosure<Arg1, Arg2, Arg3, Arg4>) -> QuadArgsClosure<Arg1, Arg2, Arg3, Arg4> {
        { [weak object] arg1, arg2, arg3, arg4 in
            guard let object = object else { return }
            method(object)(arg1, arg2, arg3, arg4)
        }
    }

// MARK: Method As Return Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with void closure
///   - method: The method that resemble with void closure
/// - Returns: Void closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnClosure<Return?>) -> ReturnClosure<Return?> {
        { [weak object] in
            guard let object = object else { return nil }
            return method(object)()
        }
    }

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with void closure
///   - method: The method that resemble with void closure
///   - defaultReturn: The result that will be returned if object is already released
/// - Returns: Void closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnClosure<Return>,
    ifObjectReleasedThenReturn defaultReturn: Return) -> ReturnClosure<Return> {
        { [weak object] in
            guard let object = object else {
                return defaultReturn
            }
            return method(object)()
        }
    }

// MARK: Method As Single Argument Return Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with one arguments closure
///   - method: The method that resemble with one arguments closure
/// - Returns: One arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Argument, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnSingleArgClosure<Argument, Return?>) -> ReturnSingleArgClosure<Argument, Return?> {
        { [weak object] arg in
            guard let object = object else { return nil }
            return method(object)(arg)
        }
    }

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with one arguments closure
///   - method: The method that resemble with one arguments closure
///   - defaultReturn: The result that will be returned if object is already released
/// - Returns: One arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Argument, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnSingleArgClosure<Argument, Return>,
    ifObjectReleasedThenReturn defaultReturn: Return) -> ReturnSingleArgClosure<Argument, Return> {
        { [weak object] arg in
            guard let object = object else {
                return defaultReturn
            }
            return method(object)(arg)
        }
    }

// MARK: Method As Bi Arguments Return Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with two arguments closure
///   - method: The method that resemble with two arguments closure
/// - Returns: Two arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnBiArgsClosure<Arg1, Arg2, Return?>) -> ReturnBiArgsClosure<Arg1, Arg2, Return?> {
        { [weak object] arg1, arg2 in
            guard let object = object else { return nil }
            return method(object)(arg1, arg2)
        }
    }

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with two arguments closure
///   - method: The method that resemble with two arguments closure
///   - defaultReturn: The result that will be returned if object is already released
/// - Returns: Two arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnBiArgsClosure<Arg1, Arg2, Return>,
    ifObjectReleasedThenReturn defaultReturn: Return) -> ReturnBiArgsClosure<Arg1, Arg2, Return> {
        { [weak object] arg1, arg2 in
            guard let object = object else {
                return defaultReturn
            }
            return method(object)(arg1, arg2)
        }
    }

// MARK: Method As Tri Arguments Return Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with three  arguments closure
///   - method: The method that resemble with three arguments closure
/// - Returns: Three  arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2, Arg3, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnTriArgsClosure<Arg1, Arg2, Arg3, Return?>) -> ReturnTriArgsClosure<Arg1, Arg2, Arg3, Return?> {
        { [weak object] arg1, arg2, arg3 in
            guard let object = object else { return nil }
            return method(object)(arg1, arg2, arg3)
        }
    }

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with three  arguments closure
///   - method: The method that resemble with three arguments closure
///   - defaultReturn: The result that will be returned if object is already released
/// - Returns: Three  arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2, Arg3, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnTriArgsClosure<Arg1, Arg2, Arg3, Return>,
    ifObjectReleasedThenReturn defaultReturn: Return) -> ReturnTriArgsClosure<Arg1, Arg2, Arg3, Return> {
        { [weak object] arg1, arg2, arg3 in
            guard let object = object else {
                return defaultReturn
            }
            return method(object)(arg1, arg2, arg3)
        }
    }

// MARK: Method As Quad Arguments Return Closure

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with four arguments closure
///   - method: The method that resemble with four arguments closure
/// - Returns: Four arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2, Arg3, Arg4, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnQuadArgsClosure<Arg1, Arg2, Arg3, Arg4, Return?>) -> ReturnQuadArgsClosure<Arg1, Arg2, Arg3, Arg4, Return?> {
        { [weak object] arg1, arg2, arg3, arg4 in
            guard let object = object else { return nil }
            return method(object)(arg1, arg2, arg3, arg4)
        }
    }

/// Function to convert method of object class instance into closure.
/// It will automatically refer to the object weakly
/// and will safe unwrapped the object before call the method.
/// If the unwrapping fail, it will return and do nothing.
/// This will ensure the closure is safe and simplify calling method inside a closure
/// - Parameters:
///   - object: The object that have the method resemble with four arguments closure
///   - method: The method that resemble with four arguments closure
///   - defaultReturn: The result that will be returned if object is already released
/// - Returns: Four arguments closure that will call the method safely
@inlinable public func methodOf<Object: AnyObject, Arg1, Arg2, Arg3, Arg4, Return>(
    _ object: Object,
    _ method: @escaping (Object) -> ReturnQuadArgsClosure<Arg1, Arg2, Arg3, Arg4, Return>,
    ifObjectReleasedThenReturn defaultReturn: Return) -> ReturnQuadArgsClosure<Arg1, Arg2, Arg3, Arg4, Return> {
        { [weak object] arg1, arg2, arg3, arg4 in
            guard let object = object else {
                return defaultReturn
            }
            return method(object)(arg1, arg2, arg3, arg4)
        }
    }

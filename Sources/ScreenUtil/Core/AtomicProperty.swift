//
//  AtomicProperty.swift
//  ScreenUtil
//
//  High-performance atomic property wrapper using os_unfair_lock
//  Optimized for frequent reads with minimal lock contention
//

import Foundation

@propertyWrapper
public final class Atomic<T> {
    private var _value: T
    private var lock = os_unfair_lock()
    
    public var wrappedValue: T {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return _value
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            _value = newValue
        }
    }
    
    public init(wrappedValue: T) {
        self._value = wrappedValue
    }
    
    public func withValue<U>(_ closure: (T) throws -> U) rethrows -> U {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return try closure(_value)
    }
    
    public func modify(_ closure: (inout T) throws -> Void) rethrows {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        try closure(&_value)
    }
}

@propertyWrapper
public final class AtomicOptional<T> {
    private var _value: T?
    private var lock = os_unfair_lock()
    
    public var wrappedValue: T? {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return _value
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            _value = newValue
        }
    }
    
    public init(wrappedValue: T? = nil) {
        self._value = wrappedValue
    }
    
    public func withValue<U>(_ closure: (T?) throws -> U) rethrows -> U {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return try closure(_value)
    }
    
    public func modify(_ closure: (inout T?) throws -> Void) rethrows {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        try closure(&_value)
    }
}

@propertyWrapper
public final class UnsafeAtomicDouble {
    private var _value: Double
    private var lock = os_unfair_lock()
    
    public var wrappedValue: Double {
        @inline(__always)
        get {
            #if SCREENUTIL_PERFORMANCE_MODE
            return _value  // Lock-free read in release mode
            #else
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return _value
            #endif
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            _value = newValue
        }
    }
    
    public init(wrappedValue: Double) {
        self._value = wrappedValue
    }
    
    @inline(__always)
    public func unsafeRead() -> Double {
        return _value
    }
    
    public func safeRead() -> Double {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return _value
    }
}
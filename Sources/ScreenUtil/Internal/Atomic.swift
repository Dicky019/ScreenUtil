//
//  Atomic.swift
//  ScreenUtil
//
//  Atomic property wrapper using os_unfair_lock
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation

@propertyWrapper
final class Atomic<T> {
    private var _value: T
    private var lock = os_unfair_lock()

    var wrappedValue: T {
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

    init(wrappedValue: T) {
        self._value = wrappedValue
    }

    func withValue<U>(_ closure: (T) throws -> U) rethrows -> U {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return try closure(_value)
    }

    func modify(_ closure: (inout T) throws -> Void) rethrows {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        try closure(&_value)
    }
}

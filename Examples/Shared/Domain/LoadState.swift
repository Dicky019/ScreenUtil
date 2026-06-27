//
//  LoadState.swift
//  ScreenUtil Examples
//
//  Generic async-load state machine driving the profile screens.
//  Created by Dicky Darmawan on 27/06/26.
//

/// The state of an asynchronously loaded value.
///
/// Not `Sendable`: `failed(Error)` wraps `any Error` (not Sendable). This type is
/// mutated and read only on `@MainActor`, so it never crosses an actor boundary.
enum LoadState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(Error)

    /// The loaded value, or `nil` in any other state.
    var value: Value? {
        if case .loaded(let value) = self { return value }
        return nil
    }
}

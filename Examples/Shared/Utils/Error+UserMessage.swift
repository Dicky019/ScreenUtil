//
//  Error+UserMessage.swift
//  ScreenUtil Examples
//
//  Single source of truth for the user-facing load-failure message, so both demos
//  show identical copy.
//  Created by Dicky Darmawan on 27/06/26.
//

import Foundation

extension Error {
    /// Human-readable message for the profile failure state.
    var userMessage: String {
        (self as? URLError)?.localizedDescription
            ?? "Please check your connection and try again."
    }
}

//
//  Format.swift
//  ScreenUtil Examples
//
//  Single source of truth for the demo's value formatting (shared by both apps).
//  Created by Dicky Darmawan on 21/06/26.
//

import CoreGraphics
import Foundation

/// Formatting helpers used across the demo to render scaled values.
enum Format {
    /// e.g. `123`
    static func integer(_ value: CGFloat) -> String { String(format: "%.0f", value) }

    /// e.g. `123.4`
    static func oneDecimal(_ value: CGFloat) -> String { String(format: "%.1f", value) }

    /// e.g. `1.25`
    static func twoDecimals(_ value: CGFloat) -> String { String(format: "%.2f", value) }

    /// e.g. `120×80`
    static func describe(_ size: CGSize) -> String { String(format: "%.0f×%.0f", size.width, size.height) }
}

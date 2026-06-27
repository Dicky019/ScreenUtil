//
//  Format.swift
//  ScreenUtil Examples
//
//  Value-to-display-string formatting, as extensions on the value types so they read
//  with dot syntax (`width.integerText`, `repos.compactText`). Shared by both demos.
//  Created by Dicky Darmawan on 21/06/26.
//

import CoreGraphics
import Foundation

extension CGFloat {
    /// e.g. `123`
    var integerText: String { String(format: "%.0f", self) }
    /// e.g. `1.25`
    var twoDecimalText: String { String(format: "%.2f", self) }
}

extension CGSize {
    /// e.g. `120×80`
    var dimensionsText: String { String(format: "%.0f×%.0f", width, height) }
}

extension Int {
    /// Compact count, e.g. `999` / `3.4k`.
    var compactText: String {
        self >= 1000 ? String(format: "%.1fk", Double(self) / 1000) : "\(self)"
    }
}

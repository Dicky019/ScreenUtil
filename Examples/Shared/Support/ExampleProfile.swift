//
//  ExampleProfile.swift
//  ScreenUtil Examples
//
//  Single source of truth for what both demos render + the ScreenUtil baseline,
//  so the UIKit and SwiftUI showcases stay in lockstep.
//  Created by Dicky Darmawan on 27/06/26.
//

/// Shared facts driving both profile apps. Centralised here so the two showcases
/// never drift apart. (The ScreenUtil baseline stays inline in each app entry point
/// on purpose, so the `configure(with:)` call is visible as usage documentation.)
enum ExampleProfile {
    /// GitHub handle both apps load.
    static let username = "Dicky019"

    /// Tag chips shown on the profile.
    static let tags = ["swift", "ios", "uikit", "swiftui"]
}

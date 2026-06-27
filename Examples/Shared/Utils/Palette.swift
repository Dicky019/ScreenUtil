//
//  Palette.swift
//  ScreenUtil Examples
//
//  Centralised colour palette shared by both demo apps, exposed as extensions so it
//  reads with leading-dot syntax (`.card`, `.secondaryText`) like the system colours.
//  UIColor is the single source of truth; the SwiftUI `Color` values derive from it.
//  Created by Dicky Darmawan on 27/06/26.
//

import SwiftUI
import UIKit

// MARK: - UIColor source of truth (used by the UIKit demo)

extension UIColor {
    /// Banner brand gradient (top-leading → bottom-trailing).
    static let bannerColors: [UIColor] = [.systemBlue, .systemPurple]
    /// Highlight-circle gradient (top-light → accent).
    static let accentColors: [UIColor] = [UIColor.systemBlue.withAlphaComponent(0.85), .systemBlue]

    static let card = UIColor.secondarySystemBackground
    static let chip = UIColor.systemBlue.withAlphaComponent(0.15)
    static let avatarFill = UIColor.secondarySystemBackground
    static let avatarStroke = UIColor.systemBackground
    static let secondaryText = UIColor.secondaryLabel
    static let onAccent = UIColor.white
}

// MARK: - SwiftUI mirrors (derived — one definition per colour)

/// Single colours on `ShapeStyle where Self == Color`, so they work with leading-dot
/// in style contexts: `.background(.card)`, `.foregroundStyle(.secondaryText)`.
extension ShapeStyle where Self == Color {
    static var card: Color { Color(uiColor: .card) }
    static var chip: Color { Color(uiColor: .chip) }
    static var avatarFill: Color { Color(uiColor: .avatarFill) }
    static var avatarStroke: Color { Color(uiColor: .avatarStroke) }
    static var secondaryText: Color { Color(uiColor: .secondaryText) }
    static var onAccent: Color { Color(uiColor: .onAccent) }
}

/// Gradient colour arrays (no leading-dot for `[Color]`, so referenced as `Color.bannerColors`).
extension Color {
    static var bannerColors: [Color] { UIColor.bannerColors.map(Color.init(uiColor:)) }
    static var accentColors: [Color] { UIColor.accentColors.map(Color.init(uiColor:)) }
}

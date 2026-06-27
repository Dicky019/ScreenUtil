//
//  UIKitHelpers.swift
//  ScreenUtil Examples
//
//  Small UIKit conveniences shared across the demo's views, so the view code reads
//  as layout intent rather than boilerplate. UIKit-only (kept out of Shared/).
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit

extension UILabel {
    /// A label with a ScreenUtil-scaled system font and common styling, created in one call.
    static func scaled(
        size: CGFloat,
        weight: UIFont.Weight = .regular,
        color: UIColor = .label,
        align: NSTextAlignment = .natural,
        lines: Int = 1
    ) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: size, weight: weight, scaled: true)
        label.textColor = color
        label.textAlignment = align
        label.numberOfLines = lines
        return label
    }
}

extension UIFont {
    /// A system font whose size is **already** scaled by the caller (e.g. via `fast.text`
    /// or `batchScaler.fontSizes`), so ScreenUtil must not scale it again.
    static func preScaled(_ size: CGFloat, weight: Weight = .regular) -> UIFont {
        .systemFont(ofSize: size, weight: weight).scaled(false)
    }
}

extension UIView {
    /// Adds a subview already opted into Auto Layout (no `translatesAutoresizing…` boilerplate).
    func addAutoLayout(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}

//
//  TagChipsView.swift
//  ScreenUtil Examples
//
//  Topic chips with batch-scaled min widths + corner radii.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit

final class TagChipsView: UIView {
    init(tags: [String]) {
        super.init(frame: .zero)
        
        let widths = withBatchScaler { $0.widths(Array(repeating: 64, count: tags.count)) }
        let radii = ScreenUtil.shared.batchScaler.radii(Array(repeating: 12, count: tags.count))
        let chips = tags.enumerated().map { index, tag in chip(tag, minWidth: widths[index], radius: radii[index]) }
        
        let row = UIStackView(arrangedSubviews: chips)
        row.spacing = 8.w
        addAutoLayout(row)

        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: topAnchor),
            row.bottomAnchor.constraint(equalTo: bottomAnchor),
            row.leadingAnchor.constraint(equalTo: leadingAnchor),
            row.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func chip(_ text: String, minWidth: CGFloat, radius: CGFloat) -> UILabel {
        let label = PaddingLabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .medium, scaled: true)
        label.textAlignment = .center
        label.backgroundColor = .chip
        label.layer.cornerRadius = radius
        label.clipsToBounds = true
        label.textInsets = .scaled(horizontal: 12, vertical: 6)
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
        return label
    }
}

/// Minimal padded label (UIKit has no built-in inset label).
final class PaddingLabel: UILabel {
    var textInsets: UIEdgeInsets = .zero
    override func drawText(in rect: CGRect) { super.drawText(in: rect.inset(by: textInsets)) }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}

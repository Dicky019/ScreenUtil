//
//  HighlightsStripView.swift
//  ScreenUtil Examples
//
//  Horizontal highlights strip (UIKit) — mirrors the SwiftUI Highlights: a gradient
//  circle + caption per item, full-bleed to the screen edges. FastScale drives the
//  repeated per-item sizing (hot path).
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit

final class HighlightsStripView: UIView {
    private let titles = ["Swift", "iOS", "UIKit", "SwiftUI", "Perf", "Open"]
    private let scroll = UIScrollView()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false

        // Full-bleed carousel: extend the scroll past the page's 20pt side margins to the
        // screen edges, then re-inset the content by the same 20pt so the first circle lines
        // up with the other rows and items scroll edge-to-edge. (Matches the page padding.)
        let bleed = 20.w
        scroll.contentInset = UIEdgeInsets(top: 0, left: bleed, bottom: 0, right: bleed)

        // Capture scale factors once for the repeated items (hot path).
        let fast = ScreenUtil.shared.fastScale
        let diameter = fast.width(64)

        let row = UIStackView(arrangedSubviews: titles.map { makeItem(title: $0, diameter: diameter, fast: fast) })
        row.axis = .horizontal
        row.alignment = .top
        row.spacing = fast.width(14)
        row.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scroll)
        scroll.addSubview(row)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -bleed),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: bleed),
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor),
            row.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            row.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            row.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            scroll.heightAnchor.constraint(equalTo: row.heightAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func makeItem(title: String, diameter: CGFloat, fast: FastScale) -> UIStackView {
        // Gradient circle (top-light → accent) approximating SwiftUI's subtle
        // Color.accentColor.gradient.
        let circle = GradientView(
            colors: [UIColor.systemBlue.withAlphaComponent(0.85), .systemBlue],
            start: CGPoint(x: 0.5, y: 0),
            end: CGPoint(x: 0.5, y: 1)
        )
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = diameter / 2
        circle.clipsToBounds = true

        let letter = UILabel()
        letter.text = String(title.prefix(1))
        letter.textColor = .white
        letter.font = .systemFont(ofSize: fast.text(24), weight: .bold).scaled(false)
        letter.translatesAutoresizingMaskIntoConstraints = false
        circle.addSubview(letter)

        let caption = UILabel()
        caption.text = title
        caption.font = .systemFont(ofSize: fast.text(12)).scaled(false)
        caption.textAlignment = .center

        let item = UIStackView(arrangedSubviews: [circle, caption])
        item.axis = .vertical
        item.alignment = .center
        item.spacing = fast.height(6)

        NSLayoutConstraint.activate([
            circle.widthAnchor.constraint(equalToConstant: diameter),
            circle.heightAnchor.constraint(equalToConstant: diameter),
            letter.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            letter.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
        ])
        return item
    }
}

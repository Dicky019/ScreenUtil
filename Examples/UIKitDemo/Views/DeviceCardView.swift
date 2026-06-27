//
//  DeviceCardView.swift
//  ScreenUtil Examples
//
//  "Device & scaling" card (UIKit) — metrics + explicit scaling entry points.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit

final class DeviceCardView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16.r
        layoutMargins = .scaled(all: 16)

        let screenUtil = ScreenUtil.shared
        let metrics = screenUtil.getScreenMetrics()
        let rows: [(String, String)] = [
            ("device", "\(screenUtil.deviceType)"),
            ("screen", Format.describe(CGSize(width: metrics.width, height: metrics.height))),
            ("scaleW · scaleH", "\(Format.twoDecimals(screenUtil.scaleWidth)) · \(Format.twoDecimals(screenUtil.scaleHeight))"),
            ("scaleText", Format.twoDecimals(screenUtil.scaleText)),
            ("safeArea T/B", "\(Format.integer(screenUtil.safeAreaTop)) / \(Format.integer(screenUtil.safeAreaBottom))"),
            ("safeArea L/R", "\(Format.integer(screenUtil.safeAreaLeft)) / \(Format.integer(screenUtil.safeAreaRight))"),
            ("statusBar", Format.integer(screenUtil.statusBarHeight)),
            ("screen W·H", "\(Format.integer(screenUtil.screenWidth)) · \(Format.integer(screenUtil.screenHeight))"),
            // All four ScaleType cases via the explicit entry points.
            ("scale(100,.width)", Format.integer(screenUtil.scale(for: 100, scaleType: .width))),
            ("scale(100,.height)", Format.integer(screenUtil.scale(for: 100, scaleType: .height))),
            ("scale(16,.radius)", Format.integer(screenUtil.scale(for: 16, scaleType: .radius))),
            ("fastScale(100,.text)", Format.integer(screenUtil.fastScale(for: 100, scaleType: .text))),
            // One labelled line for the bulk/geometry APIs without a natural UIKit home.
            ("bulk self-test", Self.selfTest()),
        ]

        let title = UILabel()
        title.text = "Device & Scaling"
        title.font = .systemFont(ofSize: 17, weight: .semibold, scaled: true)

        let stack = UIStackView(arrangedSubviews: [title] + rows.map(makeRow))
        stack.axis = .vertical
        stack.spacing = 8.h
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Exercises the bulk + geometry APIs that have no natural home in this card's layout,
    /// so the UIKit showcase still demonstrates 100% of the public surface. One labelled line.
    private static func selfTest() -> String {
        let batch = ScreenUtil.shared.batchScaler
        let widths = batch.widths([10, 20])
        let heights = batch.heights([10, 20])
        let sizes = batch.sizes([CGSize(width: 8, height: 8)])
        let insets = batch.edgeInsets([UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)])
        let points = batch.points([CGPoint(x: 4, y: 4)])
        let rects = batch.rects([CGRect(x: 0, y: 0, width: 8, height: 8)])
        let byHeight = batch.scale([100, 200], scaleType: .height)

        let fast = ScreenUtil.shared.fastScale
        _ = fast.point(CGPoint(x: 5, y: 5))
        _ = fast.size(CGSize(width: 8, height: 8))
        _ = fast.rect(CGRect(x: 0, y: 0, width: 8, height: 8))
        _ = withFastScale { $0.width(20) }
        _ = CGRect.scaled(x: 0, y: 0, width: 10, height: 10)
        _ = CGRect.responsive(x: 0, y: 0, width: 10, height: 10)
        // Keeps the customFont API demoed now that the card title uses the system font.
        _ = UIFont.customFont(name: "Menlo", size: 12, scaled: true)

        let count = widths.count + heights.count + sizes.count + insets.count
            + points.count + rects.count + byHeight.count
        return "\(count) bulk values ✓"
    }

    private func makeRow(_ pair: (String, String)) -> UIStackView {
        let key = UILabel(); key.text = pair.0; key.textColor = .secondaryLabel
        key.font = .systemFont(ofSize: 13, scaled: true)
        let value = UILabel(); value.text = pair.1; value.textAlignment = .right
        value.font = .systemFont(ofSize: 13, weight: .medium, scaled: true)
        let row = UIStackView(arrangedSubviews: [key, value])
        row.distribution = .equalSpacing
        return row
    }
}

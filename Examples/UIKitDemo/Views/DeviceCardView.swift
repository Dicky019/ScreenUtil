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
        
        backgroundColor = .card
        layer.cornerRadius = 16.r
        layoutMargins = .scaled(all: 16)

        let screenUtil = ScreenUtil.shared
        let rows = DeviceMetricsRows.make(metrics: screenUtil.getScreenMetrics(), scaling: screenUtil)

        let title = UILabel.scaled(size: 17, weight: .semibold)
        title.text = "Device & Scaling"

        let stack = UIStackView(arrangedSubviews: [title] + rows.map(makeRow))
        stack.axis = .vertical
        stack.spacing = 8.h
        addAutoLayout(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func makeRow(_ metric: MetricRow) -> UIStackView {
        let key = UILabel.scaled(size: 13, color: .secondaryText)
        key.text = metric.label
        let value = UILabel.scaled(size: 13, weight: .medium, align: .right)
        value.text = metric.value
        let row = UIStackView(arrangedSubviews: [key, value])
        row.distribution = .equalSpacing
        return row
    }
}

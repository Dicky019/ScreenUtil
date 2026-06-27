//
//  StatsRowView.swift
//  ScreenUtil Examples
//
//  Repos / followers / following — font sizes scaled in bulk.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit

final class StatsRowView: UIView {
    init(profile: Profile) {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16.r
        layoutMargins = .scaled(all: 14)          // UIEdgeInsets.scaled

        let sizes = ScreenUtil.shared.batchScaler.fontSizes([22, 13])  // [value, label]
        let columns = [
            column(value: Self.compact(profile.repos), label: "Repos", sizes: sizes),
            column(value: Self.compact(profile.followers), label: "Followers", sizes: sizes),
            column(value: Self.compact(profile.following), label: "Following", sizes: sizes),
        ]
        let row = UIStackView(arrangedSubviews: columns)
        row.distribution = .fillEqually
        row.translatesAutoresizingMaskIntoConstraints = false
        addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            row.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func column(value: String, label: String, sizes: [CGFloat]) -> UIStackView {
        let valueLabel = UILabel(); valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: sizes[0], weight: .bold).scaled(false) // already scaled
        valueLabel.textAlignment = .center
        let nameLabel = UILabel(); nameLabel.text = label
        nameLabel.font = .systemFont(ofSize: sizes[1], weight: .regular).scaled(false)
        nameLabel.textColor = .secondaryLabel
        nameLabel.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [valueLabel, nameLabel])
        stack.axis = .vertical
        stack.spacing = 2.h
        return stack
    }

    private static func compact(_ n: Int) -> String {
        n >= 1000 ? String(format: "%.1fk", Double(n) / 1000) : "\(n)"
    }
}

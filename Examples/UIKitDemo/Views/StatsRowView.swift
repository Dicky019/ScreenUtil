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
        backgroundColor = .card
        layer.cornerRadius = 16.r
        layoutMargins = .scaled(all: 14)          // UIEdgeInsets.scaled

        let sizes = ScreenUtil.shared.batchScaler.fontSizes([22, 13])  // [value, label]
        let columns = [
            column(value: profile.repos.compactText, label: "Repos", sizes: sizes),
            column(value: profile.followers.compactText, label: "Followers", sizes: sizes),
            column(value: profile.following.compactText, label: "Following", sizes: sizes),
        ]
        
        let row = UIStackView(arrangedSubviews: columns)
        row.distribution = .fillEqually
        addAutoLayout(row)

        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            row.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func column(value: String, label: String, sizes: [CGFloat]) -> UIStackView {
        // sizes are already scaled by batchScaler.fontSizes, so use preScaled fonts.
        let valueLabel = UILabel(); valueLabel.text = value
        valueLabel.font = .preScaled(sizes[0], weight: .bold)
        valueLabel.textAlignment = .center

        let nameLabel = UILabel(); nameLabel.text = label
        nameLabel.font = .preScaled(sizes[1])
        nameLabel.textColor = .secondaryText
        nameLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [valueLabel, nameLabel])
        stack.axis = .vertical
        stack.spacing = 2.h
        return stack
    }
}

//
//  ProfileHeaderView.swift
//  ScreenUtil Examples
//
//  Banner + avatar + identity (UIKit). All sizes scaled.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit

final class ProfileHeaderView: UIView {
    // Gradient banner to match the SwiftUI LinearGradient(blue → purple).
    private let banner: GradientView = {
        let banner = GradientView(colors: [.systemBlue, .systemPurple])
        banner.cornerRadius(20)        // .r scaled
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()

    private let avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.backgroundColor = .secondarySystemBackground
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.borderWidth(4)          // .w scaled
        avatar.layer.borderColor = UIColor.systemBackground.cgColor
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()

    private let nameLabel = makeLabel(size: 24, weight: .bold)
    private let handleLabel = makeLabel(size: 15, weight: .regular, color: .secondaryLabel)
    private let bioLabel = makeLabel(size: 15, weight: .regular, lines: 0)

    init(profile: Profile) {
        super.init(frame: .zero)
        nameLabel.text = profile.name
        handleLabel.text = "@\(profile.username)"
        bioLabel.text = profile.bio
        let avatarSize = CGSize.scaled(width: 96, height: 96)
        avatar.layer.cornerRadius = avatarSize.width / 2

        let identity = UIStackView(arrangedSubviews: [nameLabel, handleLabel, bioLabel])
        identity.axis = .vertical
        identity.spacing = 4.h
        identity.translatesAutoresizingMaskIntoConstraints = false

        addSubview(banner)
        addSubview(avatar)
        addSubview(identity)
        avatar.size(width: 96, height: 96)   // already-active scaled constraints
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: topAnchor),
            banner.leadingAnchor.constraint(equalTo: leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: trailingAnchor),
            banner.heightAnchor.constraint(equalToConstant: 140.h),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.w),
            avatar.centerYAnchor.constraint(equalTo: banner.bottomAnchor),
            identity.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 12.h),
            identity.leadingAnchor.constraint(equalTo: leadingAnchor),
            identity.trailingAnchor.constraint(equalTo: trailingAnchor),
            identity.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        loadAvatar(from: profile.avatar)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func loadAvatar(from url: URL) {
        Task { [weak self] in
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let image = UIImage(data: data) else { return }
            self?.avatar.image = image
        }
    }

    private static func makeLabel(size: CGFloat, weight: UIFont.Weight, color: UIColor = .label, lines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: size, weight: weight, scaled: true)
        label.textColor = color
        label.numberOfLines = lines
        return label
    }
}

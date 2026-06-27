//
//  ErrorStateView.swift
//  ScreenUtil Examples
//
//  Failure state (UIKit): message + Retry, sizes scaled via ScreenUtil.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit

final class ErrorStateView: UIView {
    private let onRetry: () -> Void

    private let messageLabel = UILabel.scaled(size: 15, color: .secondaryText, align: .center, lines: 0)

    private lazy var retryButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = "Retry"
        let button = UIButton(configuration: config)
        button.accessibilityLabel = "Retry loading profile"
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return button
    }()

    init(onRetry: @escaping () -> Void) {
        self.onRetry = onRetry
        super.init(frame: .zero)
        
        let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12.h
        addAutoLayout(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 32.w),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -32.w),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(message: String) { messageLabel.text = message }

    @objc private func retryTapped() { onRetry() }
}

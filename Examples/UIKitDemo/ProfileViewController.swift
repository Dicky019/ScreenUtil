//
//  ProfileViewController.swift
//  ScreenUtil Examples
//
//  The single scaled profile page (UIKit) — renders per LoadState; sizes scale.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit

final class ProfileViewController: UIViewController {
    // Same view model as the SwiftUI demo (Shared/). UIKit drives render() imperatively.
    private let model = ProfileViewModel(
        repository: LiveProfileRepository(username: ExampleProfile.username)
    )
    private var loadTask: Task<Void, Never>?
    private var didApplyContainerMetrics = false

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = false
        spinner.isAccessibilityElement = true
        spinner.accessibilityLabel = "Loading profile"
        return spinner
    }()

    private lazy var errorView = ErrorStateView { [weak self] in self?.startLoad() }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "UIKit Demo"
        navigationItem.largeTitleDisplayMode = .never
        contentStack.isLayoutMarginsRelativeArrangement = true

        view.addAutoLayout(scrollView)
        scrollView.addAutoLayout(contentStack)
        view.addAutoLayout(spinner)
        view.addAutoLayout(errorView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        render()
        startLoad()
    }

    /// Scaled container geometry needs valid ScreenUtil metrics, which only exist
    /// once the window does — so apply it in viewIsAppearing, not viewDidLoad.
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        guard !didApplyContainerMetrics else { return }
        didApplyContainerMetrics = true
        contentStack.spacing = 20.h
        contentStack.layoutMargins = .scaled(horizontal: 20, vertical: 12)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadTask?.cancel()
    }

    private func startLoad() {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            await self?.model.load()
            guard let self, !Task.isCancelled else { return }
            self.render()
        }
    }

    private func render() {
        switch model.state {
        case .idle, .loading:
            spinner.startAnimating()
            spinner.isHidden = false
            errorView.isHidden = true
            scrollView.isHidden = true
        case .failed(let error):
            spinner.stopAnimating()
            spinner.isHidden = true
            errorView.isHidden = false
            scrollView.isHidden = true
            errorView.configure(message: error.userMessage)
        case .loaded(let profile):
            spinner.stopAnimating()
            spinner.isHidden = true
            errorView.isHidden = true
            scrollView.isHidden = false
            rebuildSections(profile)
        }
    }

    private func rebuildSections(_ profile: Profile) {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentStack.addArrangedSubview(ProfileHeaderView(profile: profile))
        contentStack.addArrangedSubview(StatsRowView(profile: profile))
        contentStack.addArrangedSubview(HighlightsStripView())
        contentStack.addArrangedSubview(TagChipsView(tags: ExampleProfile.tags))
        contentStack.addArrangedSubview(DeviceCardView())
    }
}

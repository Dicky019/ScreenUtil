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
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.isAccessibilityElement = true
        spinner.accessibilityLabel = "Loading profile"
        return spinner
    }()

    private lazy var errorView: ErrorStateView = {
        let view = ErrorStateView { [weak self] in self?.startLoad() }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        contentStack.isLayoutMarginsRelativeArrangement = true

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(spinner)
        view.addSubview(errorView)
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
            errorView.configure(message: Self.message(for: error))
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

    private static func message(for error: Error) -> String {
        (error as? URLError)?.localizedDescription
            ?? "Please check your connection and try again."
    }
}

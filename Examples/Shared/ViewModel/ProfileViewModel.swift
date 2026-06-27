//
//  ProfileViewModel.swift
//  ScreenUtil Examples
//
//  Shared observable view model: drives profile loading as a LoadState machine
//  and publishes the live scale metrics. SwiftUI observes it; UIKit drives it.
//  Created by Dicky Darmawan on 27/06/26.
//

import Observation
import ScreenUtil

@MainActor
@Observable
final class ProfileViewModel {
    private(set) var state: LoadState<Profile> = .idle
    private(set) var metrics: ScreenMetrics = ScreenUtil.shared.getScreenMetrics()

    private let repository: ProfileRepository

    init(repository: ProfileRepository) {
        self.repository = repository
    }

    /// Loads the profile through the repository. Ignored if already loading
    /// (re-entrancy guard). Refreshes `metrics` afterwards: by now ScreenUtil's
    /// scene-activate observer has rebuilt the snapshot with the real window
    /// size + safe-area, and publishing it re-renders the metrics card.
    func load() async {
        if case .loading = state { return }
        state = .loading
        do {
            state = .loaded(try await repository.fetch())
        } catch {
            state = .failed(error)
        }
        metrics = ScreenUtil.shared.getScreenMetrics()
    }

    func retry() async { await load() }
}

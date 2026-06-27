//
//  ProfileView.swift
//  ScreenUtil Examples
//
//  The single scaled profile page — renders per LoadState; every dimension scales.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import SwiftUI

struct ProfileView: View {
    @State private var model: ProfileViewModel

    /// Repository is injected (Dependency Inversion); defaults to the live one.
    /// `State(wrappedValue:)` is the correct way to seed view-owned @State from init.
    init(repository: ProfileRepository =
         LiveProfileRepository(username: ExampleProfile.username)) {
        _model = State(wrappedValue: ProfileViewModel(repository: repository))
    }

    var body: some View {
        Group {
            switch model.state {
            case .idle, .loading:
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel("Loading profile")
            case .failed(let error):
                ContentUnavailableView {
                    Label("Couldn't Load Profile", systemImage: "wifi.slash")
                } description: {
                    Text(Self.message(for: error))
                } actions: {
                    Button("Retry") { Task { await model.retry() } }
                }
            case .loaded(let profile):
                loadedContent(profile)
            }
        }
        .task { await model.load() }
    }

    private func loadedContent(_ profile: Profile) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20.h) {
                ProfileHeader(profile: profile)
                StatsRow(profile: profile)
                Highlights()
                    .padding(.horizontal, -20.w)   // full-bleed: opt out of the page padding
                TagChips(tags: ExampleProfile.tags)
                DeviceCard(metrics: model.metrics)
            }
            .padding(.horizontal, 20.w)
            .padding(.top, 12.h)
        }
    }

    private static func message(for error: Error) -> String {
        (error as? URLError)?.localizedDescription
            ?? "Please check your connection and try again."
    }
}

#Preview("Loaded") {
    ProfileView(repository: StubProfileRepository { .preview })
}

#Preview("Failed") {
    ProfileView(repository: StubProfileRepository { throw URLError(.notConnectedToInternet) })
}

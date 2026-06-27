//
//  Profile.swift
//  ScreenUtil Examples
//
//  Domain model the views render — mapped from the GitHubUser DTO.
//  Created by Dicky Darmawan on 27/06/26.
//

import Foundation

/// A GitHub profile, in domain terms the UI cares about (no serialization detail).
struct Profile: Equatable, Sendable {
    let username: String
    let name: String
    let bio: String?
    let avatar: URL
    let repos: Int
    let followers: Int
    let following: Int
}

extension Profile {
    /// Self-contained sample for previews and tests (no network, no bundle).
    static let preview = Profile(
        username: "octocat",
        name: "The Octocat",
        bio: "Responsive layouts, scaled with ScreenUtil.",
        avatar: URL(string: "https://avatars.githubusercontent.com/u/583231")!,
        repos: 8,
        followers: 3400,
        following: 180
    )
}

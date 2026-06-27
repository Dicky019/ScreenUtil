//
//  GitHubUser.swift
//  ScreenUtil Examples
//
//  GitHub public-user DTO (mirrors the API JSON) + mapping to the domain Profile.
//  Created by Dicky Darmawan on 27/06/26.
//

import Foundation

/// A GitHub public user, decoded from `api.github.com/users/{login}`.
struct GitHubUser: Codable, Equatable, Sendable {
    let login: String
    let name: String?
    let bio: String?
    let avatarURL: URL
    let publicRepos: Int
    let followers: Int
    let following: Int
    let location: String?
    let company: String?
    let blog: String?

    enum CodingKeys: String, CodingKey {
        case login, name, bio, followers, following, location, company, blog
        case avatarURL = "avatar_url"
        case publicRepos = "public_repos"
    }
}

extension GitHubUser {
    /// Maps the API DTO to the domain `Profile`. Resolves the display name once
    /// (`name` falls back to `login`) so views never repeat the `?? login` dance.
    func toDomain() -> Profile {
        Profile(
            username: login,
            name: name ?? login,
            bio: bio,
            avatar: avatarURL,
            repos: publicRepos,
            followers: followers,
            following: following
        )
    }
}

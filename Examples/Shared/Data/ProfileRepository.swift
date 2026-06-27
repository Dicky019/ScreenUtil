//
//  ProfileRepository.swift
//  ScreenUtil Examples
//
//  Data layer: abstracts profile loading behind a protocol (Dependency Inversion).
//  Created by Dicky Darmawan on 27/06/26.
//

import Foundation

/// Loads a `Profile`. Abstraction the view model depends on (not URLSession).
protocol ProfileRepository: Sendable {
    func fetch() async throws -> Profile
}

/// Live implementation: GitHub public API → `GitHubUser` DTO → `Profile`.
/// Throws on bad URL, non-200, transport error, or decode failure (no fallback).
struct LiveProfileRepository: ProfileRepository {
    let username: String
    var session: URLSession = .shared

    func fetch() async throws -> Profile {
        guard let url = URL(string: "https://api.github.com/users/\(username)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(GitHubUser.self, from: data).toDomain()
    }
}

/// Stub for SwiftUI previews and unit tests (no network). Holds a `@Sendable`
/// closure rather than a `Result<Profile, any Error>` — `any Error` is not
/// Sendable, so a stored Result would break `ProfileRepository: Sendable`; a
/// `@Sendable` function type is Sendable and still lets callers throw any error.
struct StubProfileRepository: ProfileRepository {
    private let handler: @Sendable () throws -> Profile
    init(_ handler: @escaping @Sendable () throws -> Profile) { self.handler = handler }
    func fetch() async throws -> Profile { try handler() }
}

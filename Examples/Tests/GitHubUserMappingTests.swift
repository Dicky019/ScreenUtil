//
//  GitHubUserMappingTests.swift
//  ScreenUtil Examples
//
//  Created by Dicky Darmawan on 27/06/26.
//

import XCTest

final class GitHubUserMappingTests: XCTestCase {
    private func makeUser(name: String?) -> GitHubUser {
        GitHubUser(
            login: "octocat", name: name, bio: "bio",
            avatarURL: URL(string: "https://example.com/a.png")!,
            publicRepos: 3, followers: 10, following: 2,
            location: nil, company: nil, blog: nil
        )
    }

    func testMapsFieldsToDomain() {
        let profile = makeUser(name: "The Octocat").toDomain()
        XCTAssertEqual(profile.username, "octocat")
        XCTAssertEqual(profile.name, "The Octocat")
        XCTAssertEqual(profile.bio, "bio")
        XCTAssertEqual(profile.repos, 3)
        XCTAssertEqual(profile.followers, 10)
        XCTAssertEqual(profile.following, 2)
    }

    func testNameFallsBackToLogin() {
        XCTAssertEqual(makeUser(name: nil).toDomain().name, "octocat")
    }
}

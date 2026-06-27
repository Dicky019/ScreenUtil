//
//  ProfileRepositoryTests.swift
//  ScreenUtil Examples
//
//  Created by Dicky Darmawan on 27/06/26.
//

import XCTest

final class ProfileRepositoryTests: XCTestCase {
    func testStubReturnsConfiguredProfile() async throws {
        let repo = StubProfileRepository { .preview }
        let profile = try await repo.fetch()
        XCTAssertEqual(profile, .preview)
    }

    func testStubThrowsConfiguredError() async {
        let repo = StubProfileRepository { throw URLError(.notConnectedToInternet) }
        do {
            _ = try await repo.fetch()
            XCTFail("expected fetch to throw")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
}

//
//  ProfileViewModelTests.swift
//  ScreenUtil Examples
//
//  Created by Dicky Darmawan on 27/06/26.
//

import XCTest

@MainActor
final class ProfileViewModelTests: XCTestCase {
    func testLoadSuccessEndsLoaded() async {
        let model = ProfileViewModel(repository: StubProfileRepository { .preview })
        await model.load()
        XCTAssertEqual(model.state.value, .preview)
    }

    func testLoadFailureEndsFailed() async {
        let model = ProfileViewModel(repository: StubProfileRepository { throw URLError(.timedOut) })
        await model.load()
        guard case .failed = model.state else {
            return XCTFail("expected .failed, got \(model.state)")
        }
    }

    func testRetryReloads() async {
        let model = ProfileViewModel(repository: StubProfileRepository { .preview })
        await model.retry()
        XCTAssertEqual(model.state.value, .preview)
    }
}

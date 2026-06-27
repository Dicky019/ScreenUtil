//
//  LoadStateTests.swift
//  ScreenUtil Examples
//
//  Created by Dicky Darmawan on 27/06/26.
//

import XCTest

final class LoadStateTests: XCTestCase {
    func testValueIsNilUntilLoaded() {
        XCTAssertNil(LoadState<Profile>.idle.value)
        XCTAssertNil(LoadState<Profile>.loading.value)
        XCTAssertNil(LoadState<Profile>.failed(URLError(.badURL)).value)
    }

    func testValueReturnsLoadedPayload() {
        XCTAssertEqual(LoadState.loaded(Profile.preview).value, .preview)
    }
}

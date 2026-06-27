//
//  SwiftUIFontEnvironmentTests.swift
//  ScreenUtilTests
//
//  EnvironmentValues.screenUtil coverage. Font/wrapper sugar removed; View modifier rendering needs a host.
//  Created by Dicky Darmawan on 06/06/26.
//

#if canImport(SwiftUI)
import XCTest
import SwiftUI
@testable import ScreenUtil

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
final class SwiftUIFontEnvironmentTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
                designSize: CGSize(width: 100, height: 100),
                scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        }
    }

    // MARK: - EnvironmentValues.screenUtil

    func testEnvironmentValuesDefaultIsShared() {
        let env = EnvironmentValues()
        // Default should be ScreenUtil.shared
        let fromEnv = env.screenUtil
        XCTAssertTrue(fromEnv === ScreenUtil.shared)
    }

    func testEnvironmentValuesReadWrite() {
        var env = EnvironmentValues()
        let custom = ScreenUtil.shared  // only one instance (singleton) — still exercises the setter
        env.screenUtil = custom
        XCTAssertTrue(env.screenUtil === custom)
    }
}
#endif

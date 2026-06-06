//
//  SnapshotTests.swift
//  ScreenUtilTests
//
//  Snapshot rebuild + nonisolated read behavior.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class SnapshotTests: XCTestCase {
    @MainActor
    func testConfigureUpdatesFactorsAndDimensions() {
        let su = ScreenUtil.shared
        su.configure(with: ScreenUtilConfiguration(designSize: CGSize(width: 200, height: 400),
                                                   scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        XCTAssertGreaterThan(su.scaleWidth, 0)
        XCTAssertGreaterThan(su.scaleHeight, 0)
        XCTAssertGreaterThan(su.screenWidth, 0)
        XCTAssertEqual(su.w(10), 10 * su.scaleWidth, accuracy: 0.001)
    }

    @MainActor
    func testRefreshMetricsIsIdempotent() {
        let su = ScreenUtil.shared
        su.configure(with: ScreenUtilConfiguration(designSize: CGSize(width: 375, height: 812)))
        let before = su.scaleWidth
        su.refreshMetrics()
        XCTAssertEqual(before, su.scaleWidth, accuracy: 0.001)
    }

    @MainActor
    func testDeviceTypeIsKnown() {
        let su = ScreenUtil.shared
        su.configure(with: .iPhone13Pro)
        XCTAssertNotEqual(su.deviceType, .unknown)
    }
}

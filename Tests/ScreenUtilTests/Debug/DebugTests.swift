//
//  DebugTests.swift
//  ScreenUtilTests
//
//  Smoke coverage for ScreenUtilDebug.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class DebugTests: XCTestCase {
    @MainActor
    func testDebugUtilitiesRun() {
        let su = ScreenUtil.shared
        su.configure(with: .iPhone13Pro)
        ScreenUtilDebug.printCurrentConfiguration()
        let (result, avg) = ScreenUtilDebug.measurePerformance({ 10.w }, iterations: 100)
        XCTAssertGreaterThan(result, 0)
        XCTAssertGreaterThanOrEqual(avg, 0)
    }

    @MainActor
    func testBenchmarkScalingOperationsRuns() {
        // Exercises the benchmark path — no assertion needed beyond "no crash".
        ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
            designSize: CGSize(width: 100, height: 100),
            scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        ScreenUtilDebug.benchmarkScalingOperations()
    }
}

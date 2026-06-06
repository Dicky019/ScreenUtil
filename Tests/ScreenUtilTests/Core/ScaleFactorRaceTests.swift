//
//  ScaleFactorRaceTests.swift
//  ScreenUtilTests
//
//  Concurrent read-during-reconfigure race test (ThreadSanitizer gate)
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class ScaleFactorRaceTests: XCTestCase {

    /// Hammers scale-factor reads from many concurrent tasks while the main
    /// actor reconfigures the design size. Must be race-free under
    /// ThreadSanitizer, and every read must be finite and within the clamped
    /// scale bounds.
    ///
    /// Validity is collected per-reader and asserted once after the group:
    /// `XCTAssert` is not safe to call concurrently (it mutates shared
    /// `XCTestCase` state), so the concurrent tasks only do atomic reads.
    func testConcurrentReadsDuringReconfigure() async {
        let screenUtil = ScreenUtil.shared
        let limits = ScalingLimits(minScale: 0.5, maxScale: 2.0)
        let configA = ScreenUtilConfiguration(designSize: CGSize(width: 320, height: 640), scalingLimits: limits)
        let configB = ScreenUtilConfiguration(designSize: CGSize(width: 414, height: 896), scalingLimits: limits)
        await MainActor.run { screenUtil.configure(with: configA) }

        let base: CGFloat = 100
        let lower = base * 0.5
        let upper = base * 2.0

        let allValid = await withTaskGroup(of: Bool.self, returning: Bool.self) { group in
            // Concurrent nonisolated readers — return whether every read was in range.
            for _ in 0..<8 {
                group.addTask {
                    for _ in 0..<5_000 {
                        let w = base.w, h = base.h, s = base.sp
                        let ok = w.isFinite && h.isFinite && s.isFinite
                            && w >= lower && w <= upper
                            && h >= lower && h <= upper
                            && s >= lower && s <= upper
                        if !ok { return false }
                    }
                    return true
                }
            }
            // Writer: every reconfigure hops to the main actor.
            group.addTask {
                for i in 0..<500 {
                    await MainActor.run {
                        screenUtil.configure(with: i.isMultiple(of: 2) ? configA : configB)
                    }
                }
                return true
            }

            var valid = true
            for await result in group where !result { valid = false }
            return valid
        }

        XCTAssertTrue(allValid, "A concurrent read fell outside the clamped scale bounds")
    }
}

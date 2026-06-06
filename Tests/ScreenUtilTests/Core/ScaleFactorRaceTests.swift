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

    /// Hammers scale-factor reads from many threads while another thread
    /// reconfigures the design size. Must be race-free under ThreadSanitizer
    /// and every read must be finite and within the clamped scale bounds.
    func testConcurrentReadsDuringReconfigure() {
        let screenUtil = ScreenUtil.shared

        // Limits used by both configs below; reads must stay within these.
        let limits = ScalingLimits(minScale: 0.5, maxScale: 2.0)
        let configA = ScreenUtilConfiguration(designSize: CGSize(width: 320, height: 640), scalingLimits: limits)
        let configB = ScreenUtilConfiguration(designSize: CGSize(width: 414, height: 896), scalingLimits: limits)
        screenUtil.configure(with: configA)

        let readers = DispatchQueue(label: "race.readers", attributes: .concurrent)
        let writers = DispatchQueue(label: "race.writers")
        let group = DispatchGroup()

        // Writer: flip the configuration repeatedly.
        group.enter()
        writers.async {
            for i in 0..<2_000 {
                screenUtil.configure(with: i.isMultiple(of: 2) ? configA : configB)
            }
            group.leave()
        }

        // Readers: read scale factors concurrently and validate each result.
        let base: CGFloat = 100
        for _ in 0..<8 {
            group.enter()
            readers.async {
                for _ in 0..<5_000 {
                    let w = base.w
                    let h = base.h
                    let s = base.sp
                    XCTAssertTrue(w.isFinite && h.isFinite && s.isFinite)
                    // result = base * factor, factor clamped to [0.5, 2.0]
                    XCTAssertTrue(w >= base * 0.5 && w <= base * 2.0)
                    XCTAssertTrue(h >= base * 0.5 && h <= base * 2.0)
                    XCTAssertTrue(s >= base * 0.5 && s <= base * 2.0)
                }
                group.leave()
            }
        }

        let result = group.wait(timeout: .now() + 30)
        XCTAssertEqual(result, .success, "Race test timed out")
    }
}

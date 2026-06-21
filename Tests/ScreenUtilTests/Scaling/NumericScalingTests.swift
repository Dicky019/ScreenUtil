//
//  NumericScalingTests.swift
//  ScreenUtilTests
//
//  Exhaustive coverage for Numeric+Scaling: all 9 properties on Int, Float, Double, CGFloat.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class NumericScalingTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
                designSize: CGSize(width: 100, height: 100),
                scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        }
    }

    // MARK: - Int

    func testIntAllProperties() {
        let v: Int = 50
        let props: [CGFloat] = [v.w, v.h, v.sp, v.r, v.sw, v.sh]
        for (i, p) in props.enumerated() {
            XCTAssertTrue(p.isFinite, "Int property[\(i)] not finite")
            XCTAssertGreaterThan(p, 0, "Int property[\(i)] not > 0")
        }
    }

    func testIntWMatchesShared() {
        let su = ScreenUtil.shared
        let v: Int = 30
        XCTAssertEqual(v.w, su.w(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.h, su.h(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.sp, su.sp(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.r, su.r(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.sw, su.sw(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.sh, su.sh(CGFloat(v)), accuracy: 0.001)
    }

    // MARK: - Float

    func testFloatAllProperties() {
        let v: Float = 50.0
        let props: [CGFloat] = [v.w, v.h, v.sp, v.r, v.sw, v.sh]
        for (i, p) in props.enumerated() {
            XCTAssertTrue(p.isFinite, "Float property[\(i)] not finite")
            XCTAssertGreaterThan(p, 0, "Float property[\(i)] not > 0")
        }
    }

    func testFloatMatchesShared() {
        let su = ScreenUtil.shared
        let v: Float = 25.0
        XCTAssertEqual(v.w, su.w(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.h, su.h(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.sp, su.sp(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.r, su.r(CGFloat(v)), accuracy: 0.001)
    }

    // MARK: - Double

    func testDoubleAllProperties() {
        let v: Double = 50.0
        let props: [CGFloat] = [v.w, v.h, v.sp, v.r, v.sw, v.sh]
        for (i, p) in props.enumerated() {
            XCTAssertTrue(p.isFinite, "Double property[\(i)] not finite")
            XCTAssertGreaterThan(p, 0, "Double property[\(i)] not > 0")
        }
    }

    func testDoubleMatchesShared() {
        let su = ScreenUtil.shared
        let v: Double = 60.0
        XCTAssertEqual(v.w, su.w(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.h, su.h(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.sp, su.sp(CGFloat(v)), accuracy: 0.001)
        XCTAssertEqual(v.r, su.r(CGFloat(v)), accuracy: 0.001)
    }

    // MARK: - CGFloat

    func testCGFloatAllProperties() {
        let v: CGFloat = 50.0
        let props: [CGFloat] = [v.w, v.h, v.sp, v.r, v.sw, v.sh]
        for (i, p) in props.enumerated() {
            XCTAssertTrue(p.isFinite, "CGFloat property[\(i)] not finite")
            XCTAssertGreaterThan(p, 0, "CGFloat property[\(i)] not > 0")
        }
    }

    func testCGFloatMatchesShared() {
        let su = ScreenUtil.shared
        let v: CGFloat = 80.0
        XCTAssertEqual(v.w, su.w(v), accuracy: 0.001)
        XCTAssertEqual(v.h, su.h(v), accuracy: 0.001)
        XCTAssertEqual(v.sp, su.sp(v), accuracy: 0.001)
        XCTAssertEqual(v.r, su.r(v), accuracy: 0.001)
        XCTAssertEqual(v.sw, su.sw(v), accuracy: 0.001)
        XCTAssertEqual(v.sh, su.sh(v), accuracy: 0.001)
    }

    // MARK: - Proportional correctness

    func testDoubleScalesProportionally() {
        let a: Double = 10.0
        let b: Double = 20.0
        XCTAssertEqual(b.w / a.w, 2.0, accuracy: 0.001, "scaling must be linear")
        XCTAssertEqual(b.h / a.h, 2.0, accuracy: 0.001)
    }

    func testIntSwShAreScreenPercentages() {
        let su = ScreenUtil.shared
        let v: Int = 50
        XCTAssertEqual(v.sw, su.screenWidth * 0.5, accuracy: 0.001)
        XCTAssertEqual(v.sh, su.screenHeight * 0.5, accuracy: 0.001)
    }
}

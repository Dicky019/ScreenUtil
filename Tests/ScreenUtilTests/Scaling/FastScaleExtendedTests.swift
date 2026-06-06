//
//  FastScaleExtendedTests.swift
//  ScreenUtilTests
//
//  FastScale coverage for point(_:) and rect(_:) — the previously uncovered branches.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class FastScaleExtendedTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
                designSize: CGSize(width: 100, height: 100),
                scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        }
    }

    func testFastScalePoint() {
        let fs = ScreenUtil.shared.fastScale
        let su = ScreenUtil.shared
        let p = CGPoint(x: 20, y: 35)
        let result = fs.point(p)
        XCTAssertEqual(result.x, p.x * su.scaleWidth, accuracy: 0.001)
        XCTAssertEqual(result.y, p.y * su.scaleHeight, accuracy: 0.001)
        XCTAssertTrue(result.x.isFinite)
        XCTAssertTrue(result.y.isFinite)
    }

    func testFastScaleRect() {
        let fs = ScreenUtil.shared.fastScale
        let su = ScreenUtil.shared
        let r = CGRect(x: 5, y: 10, width: 40, height: 80)
        let result = fs.rect(r)
        XCTAssertEqual(result.origin.x, r.origin.x * su.scaleWidth, accuracy: 0.001)
        XCTAssertEqual(result.origin.y, r.origin.y * su.scaleHeight, accuracy: 0.001)
        XCTAssertEqual(result.size.width, r.size.width * su.scaleWidth, accuracy: 0.001)
        XCTAssertEqual(result.size.height, r.size.height * su.scaleHeight, accuracy: 0.001)
        XCTAssertTrue(result.width.isFinite)
        XCTAssertTrue(result.height.isFinite)
    }

    func testFastScalePointZeroOrigin() {
        let fs = ScreenUtil.shared.fastScale
        let result = fs.point(CGPoint(x: 0, y: 0))
        XCTAssertEqual(result.x, 0, accuracy: 0.001)
        XCTAssertEqual(result.y, 0, accuracy: 0.001)
    }

    func testFastScaleRectZero() {
        let fs = ScreenUtil.shared.fastScale
        let result = fs.rect(CGRect(x: 0, y: 0, width: 0, height: 0))
        XCTAssertEqual(result.origin.x, 0, accuracy: 0.001)
        XCTAssertEqual(result.size.width, 0, accuracy: 0.001)
    }

    func testFastScalePointMatchesFastScaledCGPoint() {
        let fs = ScreenUtil.shared.fastScale
        let p = CGPoint(x: 15, y: 25)
        let viaFastScale = fs.point(p)
        let viaCGPointExt = p.fastScaled()
        XCTAssertEqual(viaFastScale.x, viaCGPointExt.x, accuracy: 0.001)
        XCTAssertEqual(viaFastScale.y, viaCGPointExt.y, accuracy: 0.001)
    }

    func testFastScaleRectMatchesFastScaledCGRect() {
        let fs = ScreenUtil.shared.fastScale
        let r = CGRect(x: 2, y: 3, width: 50, height: 60)
        let viaFastScale = fs.rect(r)
        let viaCGRectExt = r.fastScaled()
        XCTAssertEqual(viaFastScale.origin.x, viaCGRectExt.origin.x, accuracy: 0.001)
        XCTAssertEqual(viaFastScale.origin.y, viaCGRectExt.origin.y, accuracy: 0.001)
        XCTAssertEqual(viaFastScale.size.width, viaCGRectExt.size.width, accuracy: 0.001)
        XCTAssertEqual(viaFastScale.size.height, viaCGRectExt.size.height, accuracy: 0.001)
    }

    // Cover remaining FastScale methods for completeness

    func testFastScaleWidthHeightTextRadius() {
        let fs = ScreenUtil.shared.fastScale
        let su = ScreenUtil.shared
        XCTAssertEqual(fs.width(100), su.fastW(100), accuracy: 0.001)
        XCTAssertEqual(fs.height(100), su.fastH(100), accuracy: 0.001)
        XCTAssertEqual(fs.text(100), su.fastSp(100), accuracy: 0.001)
        XCTAssertGreaterThan(fs.radius(100), 0)
    }

    func testFastScaleSizeStruct() {
        let fs = ScreenUtil.shared.fastScale
        let s = CGSize(width: 10, height: 20)
        let result = fs.size(s)
        XCTAssertEqual(result.width, fs.width(10), accuracy: 0.001)
        XCTAssertEqual(result.height, fs.height(20), accuracy: 0.001)
    }
}

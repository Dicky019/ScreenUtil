//
//  GeometryScalingExtendedTests.swift
//  ScreenUtilTests
//
//  Extended CGSize/CGPoint/CGRect scaling coverage: scaled(for:), static factories, fastScaled.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class GeometryScalingExtendedTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
                designSize: CGSize(width: 100, height: 100),
                scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        }
    }

    // MARK: - CGSize

    func testSizeScaledForInstance() {
        let su = ScreenUtil.shared
        let s = CGSize(width: 40, height: 80)
        let result = s.scaled(for: su)
        XCTAssertEqual(result.width, su.w(40), accuracy: 0.001)
        XCTAssertEqual(result.height, su.h(80), accuracy: 0.001)
    }

    func testSizeStaticScaled() {
        let su = ScreenUtil.shared
        let s = CGSize.scaled(width: 50, height: 60)
        XCTAssertEqual(s.width, su.w(50), accuracy: 0.001)
        XCTAssertEqual(s.height, su.h(60), accuracy: 0.001)
    }

    func testSizeFastScaledFinite() {
        let s = CGSize(width: 10, height: 20)
        let fs = s.fastScaled()
        XCTAssertTrue(fs.width.isFinite)
        XCTAssertTrue(fs.height.isFinite)
        XCTAssertGreaterThan(fs.width, 0)
        XCTAssertGreaterThan(fs.height, 0)
    }

    func testSizeFastScaledMatchesScaled() {
        let s = CGSize(width: 30, height: 45)
        XCTAssertEqual(s.fastScaled().width, s.scaled.width, accuracy: 0.001)
        XCTAssertEqual(s.fastScaled().height, s.scaled.height, accuracy: 0.001)
    }

    // MARK: - CGPoint

    func testPointScaledForInstance() {
        let su = ScreenUtil.shared
        let p = CGPoint(x: 15, y: 25)
        let result = p.scaled(for: su)
        XCTAssertEqual(result.x, su.w(15), accuracy: 0.001)
        XCTAssertEqual(result.y, su.h(25), accuracy: 0.001)
    }

    func testPointStaticScaled() {
        let su = ScreenUtil.shared
        let p = CGPoint.scaled(x: 10, y: 20)
        XCTAssertEqual(p.x, su.w(10), accuracy: 0.001)
        XCTAssertEqual(p.y, su.h(20), accuracy: 0.001)
    }

    func testPointResponsiveFactory() {
        let su = ScreenUtil.shared
        let p = CGPoint.responsive(x: 5, y: 7)
        XCTAssertEqual(p.x, su.w(5), accuracy: 0.001)
        XCTAssertEqual(p.y, su.h(7), accuracy: 0.001)
    }

    func testPointFastScaled() {
        let p = CGPoint(x: 20, y: 30)
        let fs = p.fastScaled()
        XCTAssertTrue(fs.x.isFinite)
        XCTAssertTrue(fs.y.isFinite)
        XCTAssertGreaterThan(fs.x, 0)
        XCTAssertGreaterThan(fs.y, 0)
    }

    func testPointFastScaledMatchesScaled() {
        let p = CGPoint(x: 8, y: 12)
        XCTAssertEqual(p.fastScaled().x, p.scaled.x, accuracy: 0.001)
        XCTAssertEqual(p.fastScaled().y, p.scaled.y, accuracy: 0.001)
    }

    // MARK: - CGRect

    func testRectScaledForInstance() {
        let su = ScreenUtil.shared
        let r = CGRect(x: 5, y: 10, width: 100, height: 200)
        let result = r.scaled(for: su)
        XCTAssertEqual(result.origin.x, su.w(5), accuracy: 0.001)
        XCTAssertEqual(result.origin.y, su.h(10), accuracy: 0.001)
        XCTAssertEqual(result.size.width, su.w(100), accuracy: 0.001)
        XCTAssertEqual(result.size.height, su.h(200), accuracy: 0.001)
    }

    func testRectStaticScaled() {
        let su = ScreenUtil.shared
        let r = CGRect.scaled(x: 2, y: 3, width: 40, height: 50)
        XCTAssertEqual(r.origin.x, su.w(2), accuracy: 0.001)
        XCTAssertEqual(r.origin.y, su.h(3), accuracy: 0.001)
        XCTAssertEqual(r.size.width, su.w(40), accuracy: 0.001)
        XCTAssertEqual(r.size.height, su.h(50), accuracy: 0.001)
    }

    func testRectResponsiveFactory() {
        let su = ScreenUtil.shared
        let r = CGRect.responsive(x: 1, y: 2, width: 30, height: 40)
        XCTAssertEqual(r.origin.x, su.w(1), accuracy: 0.001)
        XCTAssertEqual(r.origin.y, su.h(2), accuracy: 0.001)
        XCTAssertEqual(r.size.width, su.w(30), accuracy: 0.001)
        XCTAssertEqual(r.size.height, su.h(40), accuracy: 0.001)
    }

    func testRectFastScaled() {
        let r = CGRect(x: 1, y: 2, width: 50, height: 60)
        let fs = r.fastScaled()
        XCTAssertTrue(fs.width.isFinite)
        XCTAssertTrue(fs.height.isFinite)
        XCTAssertGreaterThan(fs.width, 0)
        XCTAssertGreaterThan(fs.height, 0)
    }

    func testRectFastScaledMatchesScaled() {
        let r = CGRect(x: 3, y: 4, width: 20, height: 25)
        XCTAssertEqual(r.fastScaled().width, r.scaled.width, accuracy: 0.001)
        XCTAssertEqual(r.fastScaled().height, r.scaled.height, accuracy: 0.001)
        XCTAssertEqual(r.fastScaled().origin.x, r.scaled.origin.x, accuracy: 0.001)
        XCTAssertEqual(r.fastScaled().origin.y, r.scaled.origin.y, accuracy: 0.001)
    }
}

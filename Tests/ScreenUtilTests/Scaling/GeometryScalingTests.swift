//
//  GeometryScalingTests.swift
//  ScreenUtilTests
//
//  CGSize/CGPoint/CGRect scaling.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class GeometryScalingTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
                designSize: CGSize(width: 100, height: 100),
                scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        }
    }

    func testSizeScaled() {
        let s = CGSize(width: 10, height: 20).scaled
        XCTAssertEqual(s.width, 10 * ScreenUtil.shared.scaleWidth, accuracy: 0.001)
        XCTAssertEqual(s.height, 20 * ScreenUtil.shared.scaleHeight, accuracy: 0.001)
    }

    func testPointAndRectScaled() {
        let p = CGPoint(x: 5, y: 6).scaled
        XCTAssertEqual(p.x, 5 * ScreenUtil.shared.scaleWidth, accuracy: 0.001)
        let r = CGRect(x: 1, y: 2, width: 3, height: 4).scaled
        XCTAssertEqual(r.width, 3 * ScreenUtil.shared.scaleWidth, accuracy: 0.001)
        XCTAssertEqual(r.height, 4 * ScreenUtil.shared.scaleHeight, accuracy: 0.001)
    }

    func testResponsiveFactories() {
        let s = CGSize.responsive(width: 8, height: 9)
        XCTAssertEqual(s.width, 8 * ScreenUtil.shared.scaleWidth, accuracy: 0.001)
    }

    func testFastScaledMatchesScaled() {
        let r = CGRect(x: 1, y: 2, width: 3, height: 4)
        XCTAssertEqual(r.fastScaled().width, r.scaled.width, accuracy: 0.001)
    }
}

//
//  FastBatchTests.swift
//  ScreenUtilTests
//
//  FastScale + BatchScaler + numeric bridging.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class FastBatchTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
                designSize: CGSize(width: 100, height: 100),
                scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        }
    }

    func testFastScaleStruct() {
        let f = ScreenUtil.shared.fastScale
        XCTAssertEqual(f.width(10), 10 * ScreenUtil.shared.scaleWidth, accuracy: 0.001)
        XCTAssertEqual(f.radius(10), 10 * min(ScreenUtil.shared.scaleWidth, ScreenUtil.shared.scaleHeight), accuracy: 0.001)
        XCTAssertEqual(f.size(CGSize(width: 2, height: 3)).height, 3 * ScreenUtil.shared.scaleHeight, accuracy: 0.001)
    }

    func testBatchNumericTypesNeverZero() {
        let su = ScreenUtil.shared
        XCTAssertTrue(su.batchScaler.widths([CGFloat(10), 20, 30]).allSatisfy { $0 > 0 })
        XCTAssertTrue(su.batchScaler.widths([Int64(10), 20, 30]).allSatisfy { $0 > 0 })
        XCTAssertTrue(su.batchScaler.heights([10, 20]).allSatisfy { $0 > 0 })
        XCTAssertTrue(su.batchScaler.fontSizes([Float(12), 14]).allSatisfy { $0 > 0 })
    }

    func testBatchScalerWidths() {
        let scaler = ScreenUtil.shared.batchScaler
        let out = scaler.widths([10, 20])
        XCTAssertEqual(out[0], 10 * ScreenUtil.shared.scaleWidth, accuracy: 0.001)
    }

    func testBatchScaleAllTypes() {
        let su = ScreenUtil.shared
        for t: ScaleType in [.width, .height, .text, .radius] {
            XCTAssertTrue(su.batchScaler.scale([10, 20], scaleType: t).allSatisfy { $0 > 0 })
        }
    }
}

//
//  BatchScalingTests.swift
//  ScreenUtilTests
//
//  Full BatchScaling coverage: batchScale all ScaleTypes, batch collection methods,
//  BatchScaler struct, withBatchScaler, withFastScale.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class BatchScalingTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
                designSize: CGSize(width: 100, height: 100),
                scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        }
    }

    // MARK: - batchScale all ScaleTypes

    func testBatchScaleWidth() {
        let su = ScreenUtil.shared
        let input: [CGFloat] = [10, 20, 30]
        let out = su.batchScale(input, scaleType: .width)
        XCTAssertEqual(out.count, 3)
        XCTAssertEqual(out[0], su.w(10), accuracy: 0.001)
        XCTAssertEqual(out[1], su.w(20), accuracy: 0.001)
        XCTAssertEqual(out[2], su.w(30), accuracy: 0.001)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })
    }

    func testBatchScaleHeight() {
        let su = ScreenUtil.shared
        let input: [CGFloat] = [5, 15, 25]
        let out = su.batchScale(input, scaleType: .height)
        XCTAssertEqual(out.count, 3)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })
        XCTAssertEqual(out[0], su.h(5), accuracy: 0.001)
    }

    func testBatchScaleText() {
        let su = ScreenUtil.shared
        let input: [CGFloat] = [12, 14, 16, 18]
        let out = su.batchScale(input, scaleType: .text)
        XCTAssertEqual(out.count, 4)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })
        XCTAssertEqual(out[0], su.sp(12), accuracy: 0.001)
    }

    func testBatchScaleRadius() {
        let su = ScreenUtil.shared
        let input: [CGFloat] = [4, 8, 12]
        let out = su.batchScale(input, scaleType: .radius)
        XCTAssertEqual(out.count, 3)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })
        XCTAssertEqual(out[0], su.r(4), accuracy: 0.001)
    }

    // MARK: - batchWidths / batchHeights / batchFontSizes

    func testBatchWidthsMixedNumericTypes() {
        let su = ScreenUtil.shared
        let intOut = su.batchWidths([Int(10), 20, 30])
        XCTAssertEqual(intOut.count, 3)
        XCTAssertTrue(intOut.allSatisfy { $0.isFinite && $0 > 0 })

        let cgOut = su.batchWidths([CGFloat(5), 15])
        XCTAssertTrue(cgOut.allSatisfy { $0.isFinite && $0 > 0 })

        let int64Out = su.batchWidths([Int64(100), 200])
        XCTAssertTrue(int64Out.allSatisfy { $0.isFinite && $0 > 0 })
    }

    func testBatchHeightsMixedNumericTypes() {
        let su = ScreenUtil.shared
        let out = su.batchHeights([Int(50), 60, 70])
        XCTAssertEqual(out.count, 3)
        XCTAssertTrue(out.allSatisfy { $0 > 0 })

        let floatOut = su.batchHeights([Float(10), 20])
        XCTAssertTrue(floatOut.allSatisfy { $0 > 0 })
    }

    func testBatchFontSizesMixedTypes() {
        let su = ScreenUtil.shared
        let out = su.batchFontSizes([CGFloat(12), 14, 16])
        XCTAssertEqual(out.count, 3)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })

        let intOut = su.batchFontSizes([Int(10), 12])
        XCTAssertTrue(intOut.allSatisfy { $0 > 0 })
    }

    // MARK: - batchSizes

    func testBatchSizes() {
        let su = ScreenUtil.shared
        let sizes = [CGSize(width: 10, height: 20), CGSize(width: 30, height: 40)]
        let out = su.batchSizes(sizes)
        XCTAssertEqual(out.count, 2)
        XCTAssertEqual(out[0].width, su.w(10), accuracy: 0.001)
        XCTAssertEqual(out[0].height, su.h(20), accuracy: 0.001)
        XCTAssertEqual(out[1].width, su.w(30), accuracy: 0.001)
        XCTAssertTrue(out.allSatisfy { $0.width.isFinite && $0.height.isFinite })
    }

    func testBatchSizesEmpty() {
        let out = ScreenUtil.shared.batchSizes([])
        XCTAssertEqual(out.count, 0)
    }

    // MARK: - batchPoints

    func testBatchPoints() {
        let su = ScreenUtil.shared
        let points = [CGPoint(x: 5, y: 10), CGPoint(x: 15, y: 25)]
        let out = su.batchPoints(points)
        XCTAssertEqual(out.count, 2)
        XCTAssertEqual(out[0].x, su.w(5), accuracy: 0.001)
        XCTAssertEqual(out[0].y, su.h(10), accuracy: 0.001)
        XCTAssertTrue(out.allSatisfy { $0.x.isFinite && $0.y.isFinite })
    }

    // MARK: - batchRects

    func testBatchRects() {
        let su = ScreenUtil.shared
        let rects = [
            CGRect(x: 1, y: 2, width: 10, height: 20),
            CGRect(x: 3, y: 4, width: 30, height: 40)
        ]
        let out = su.batchRects(rects)
        XCTAssertEqual(out.count, 2)
        XCTAssertEqual(out[0].origin.x, su.w(1), accuracy: 0.001)
        XCTAssertEqual(out[0].origin.y, su.h(2), accuracy: 0.001)
        XCTAssertEqual(out[0].size.width, su.w(10), accuracy: 0.001)
        XCTAssertEqual(out[0].size.height, su.h(20), accuracy: 0.001)
        XCTAssertTrue(out.allSatisfy { $0.width.isFinite && $0.height.isFinite })
    }

    // MARK: - BatchScaler struct

    func testBatchScalerWidths() {
        let scaler = ScreenUtil.shared.batchScaler
        let out = scaler.widths([CGFloat(10), 20, 30])
        XCTAssertEqual(out.count, 3)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })
    }

    func testBatchScalerHeights() {
        let scaler = ScreenUtil.shared.batchScaler
        let out = scaler.heights([Int(10), 20])
        XCTAssertEqual(out.count, 2)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })
    }

    func testBatchScalerFontSizes() {
        let scaler = ScreenUtil.shared.batchScaler
        let out = scaler.fontSizes([Float(12), 14, 16])
        XCTAssertEqual(out.count, 3)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })
    }

    func testBatchScalerRadii() {
        let scaler = ScreenUtil.shared.batchScaler
        let out = scaler.radii([CGFloat(4), 8, 12])
        XCTAssertEqual(out.count, 3)
        XCTAssertTrue(out.allSatisfy { $0.isFinite && $0 > 0 })
    }

    func testBatchScalerSizes() {
        let scaler = ScreenUtil.shared.batchScaler
        let sizes = [CGSize(width: 10, height: 20), CGSize(width: 30, height: 40)]
        let out = scaler.sizes(sizes)
        XCTAssertEqual(out.count, 2)
        XCTAssertTrue(out.allSatisfy { $0.width.isFinite && $0.height.isFinite && $0.width > 0 })
    }

    func testBatchScalerInt64NeverZero() {
        let scaler = ScreenUtil.shared.batchScaler
        let out = scaler.widths([Int64(10), 20, 30])
        XCTAssertTrue(out.allSatisfy { $0 > 0 }, "Int64 must not silently scale to zero")
    }

    // MARK: - withBatchScaler

    func testWithBatchScalerReturnsValue() {
        let result: [CGFloat] = withBatchScaler { scaler in
            scaler.widths([CGFloat(5), 10, 15])
        }
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result.allSatisfy { $0.isFinite && $0 > 0 })
    }

    func testWithBatchScalerHeights() {
        let result: [CGFloat] = withBatchScaler { $0.heights([CGFloat(10), 20]) }
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.allSatisfy { $0 > 0 })
    }

    // MARK: - withFastScale

    func testWithFastScaleReturnsValue() {
        let result = withFastScale { fs in fs.width(100) }
        XCTAssertTrue(result.isFinite)
        XCTAssertGreaterThan(result, 0)
    }

    func testWithFastScaleHeight() {
        let result = withFastScale { $0.height(50) }
        XCTAssertTrue(result.isFinite)
        XCTAssertGreaterThan(result, 0)
    }
}

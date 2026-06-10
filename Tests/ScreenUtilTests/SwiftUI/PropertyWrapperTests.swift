//
//  PropertyWrapperTests.swift
//  ScreenUtilTests
//
//  @ScaledValue / @ScreenPercentage resolution.
//  Created by Dicky Darmawan on 06/06/26.
//

#if canImport(SwiftUI)
import XCTest
@testable import ScreenUtil

final class PropertyWrapperTests: XCTestCase {
    @MainActor
    func testScaledValueResolves() {
        let su = ScreenUtil.shared
        su.configure(with: ScreenUtilConfiguration(designSize: CGSize(width: 100, height: 100),
                                                   scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        let w = ScaledValue(wrappedValue: 10, .width)
        XCTAssertEqual(w.wrappedValue, 10 * su.scaleWidth, accuracy: 0.001)
        let f = ScaledValue(wrappedValue: 16, .text)
        XCTAssertEqual(f.wrappedValue, 16 * su.scaleText, accuracy: 0.001)
    }

    @MainActor
    func testScreenPercentageResolves() {
        let su = ScreenUtil.shared
        su.configure(with: ScreenUtilConfiguration(designSize: CGSize(width: 100, height: 100)))
        let p = ScreenPercentage(wrappedValue: 50, .width)
        XCTAssertEqual(p.wrappedValue, su.screenWidth * 0.5, accuracy: 0.001)
    }

    @MainActor
    func testScaledValueHeightRadius() {
        let su = ScreenUtil.shared
        su.configure(with: ScreenUtilConfiguration(designSize: CGSize(width: 100, height: 100),
                                                   scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        let h = ScaledValue(wrappedValue: 20, .height)
        XCTAssertEqual(h.wrappedValue, 20 * su.scaleHeight, accuracy: 0.001)

        let r = ScaledValue(wrappedValue: 8, .radius)
        XCTAssertEqual(r.wrappedValue, su.r(8), accuracy: 0.001)
    }

    @MainActor
    func testScreenPercentageHeight() {
        let su = ScreenUtil.shared
        su.configure(with: ScreenUtilConfiguration(designSize: CGSize(width: 100, height: 100)))
        let p = ScreenPercentage(wrappedValue: 25, .height)
        XCTAssertEqual(p.wrappedValue, su.screenHeight * 0.25, accuracy: 0.001)
    }
}
#endif

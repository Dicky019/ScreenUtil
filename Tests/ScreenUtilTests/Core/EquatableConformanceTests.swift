//
//  EquatableConformanceTests.swift
//  ScreenUtilTests
//
//  Equatable/Hashable conformance for public value types
//  Created by Dicky Darmawan on 09/06/26.
//

import XCTest
@testable import ScreenUtil

final class EquatableConformanceTests: XCTestCase {

    func testScalingLimitsEquatable() {
        XCTAssertEqual(ScalingLimits(minScale: 0.5, maxScale: 2.0),
                       ScalingLimits(minScale: 0.5, maxScale: 2.0))
        XCTAssertNotEqual(ScalingLimits.strict, ScalingLimits.relaxed)
    }

    func testConfigurationEquatable() {
        XCTAssertEqual(ScreenUtilConfiguration.iPhoneX, ScreenUtilConfiguration.iPhoneX)
        XCTAssertNotEqual(ScreenUtilConfiguration.iPhoneX, ScreenUtilConfiguration.iPhone8)
    }

    func testScaleTypeHashable() {
        let set: Set<ScaleType> = [.width, .height, .text, .radius, .width]
        XCTAssertEqual(set.count, 4)
    }

    func testDeviceTypeEquatable() {
        XCTAssertEqual(DeviceType.iPhone, DeviceType.iPhone)
        XCTAssertNotEqual(DeviceType.iPhone, DeviceType.iPad)
    }

    func testScreenMetricsEquatable() {
        let a = ScreenMetrics(width: 100, height: 200, scale: 2,
                              safeAreaInsets: (1, 2, 3, 4), statusBarHeight: 5)
        let b = ScreenMetrics(width: 100, height: 200, scale: 2,
                              safeAreaInsets: (1, 2, 3, 4), statusBarHeight: 5)
        let c = ScreenMetrics(width: 100, height: 200, scale: 2,
                              safeAreaInsets: (9, 2, 3, 4), statusBarHeight: 5)
        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
    }

    func testDimensionsEquatable() {
        XCTAssertEqual(ScreenDimensions(width: 10, height: 20, scale: 2),
                       ScreenDimensions(width: 10, height: 20, scale: 2))
    }
}

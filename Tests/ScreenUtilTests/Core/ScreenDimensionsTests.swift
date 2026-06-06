//
//  ScreenDimensionsTests.swift
//  ScreenUtilTests
//
//  ScreenDimensions struct coverage: computed properties and platformDefault.
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class ScreenDimensionsTests: XCTestCase {

    // MARK: - Portrait fixture (width < height)

    func testPortraitDimensions() {
        let d = ScreenDimensions(width: 375, height: 812, scale: 3.0)
        XCTAssertEqual(d.width, 375)
        XCTAssertEqual(d.height, 812)
        XCTAssertEqual(d.scale, 3.0)
        XCTAssertEqual(d.nativeWidth, 375 * 3.0, accuracy: 0.001)
        XCTAssertEqual(d.nativeHeight, 812 * 3.0, accuracy: 0.001)
        XCTAssertEqual(d.aspectRatio, 375.0 / 812.0, accuracy: 0.0001)
        XCTAssertTrue(d.isPortrait)
        XCTAssertFalse(d.isLandscape)
        XCTAssertEqual(d.minDimension, 375)
        XCTAssertEqual(d.maxDimension, 812)
    }

    // MARK: - Landscape fixture (width > height)

    func testLandscapeDimensions() {
        let d = ScreenDimensions(width: 812, height: 375, scale: 2.0)
        XCTAssertTrue(d.isLandscape)
        XCTAssertFalse(d.isPortrait)
        XCTAssertEqual(d.minDimension, 375)
        XCTAssertEqual(d.maxDimension, 812)
        XCTAssertEqual(d.aspectRatio, 812.0 / 375.0, accuracy: 0.0001)
    }

    // MARK: - Square (width == height)

    func testSquareDimensions() {
        let d = ScreenDimensions(width: 200, height: 200, scale: 1.0)
        XCTAssertFalse(d.isPortrait)   // height > width required
        XCTAssertFalse(d.isLandscape)  // width > height required
        XCTAssertEqual(d.aspectRatio, 1.0, accuracy: 0.0001)
        XCTAssertEqual(d.minDimension, 200)
        XCTAssertEqual(d.maxDimension, 200)
    }

    // MARK: - nativeWidth / nativeHeight

    func testNativeDimensionsComputedCorrectly() {
        let d = ScreenDimensions(width: 390, height: 844, scale: 3.0)
        XCTAssertEqual(d.nativeWidth, 390 * 3, accuracy: 0.001)
        XCTAssertEqual(d.nativeHeight, 844 * 3, accuracy: 0.001)
    }

    // MARK: - platformDefault

    func testPlatformDefaultPositive() {
        let d = ScreenDimensions.platformDefault
        XCTAssertGreaterThan(d.width, 0)
        XCTAssertGreaterThan(d.height, 0)
        XCTAssertGreaterThan(d.scale, 0)
        XCTAssertGreaterThan(d.nativeWidth, 0)
        XCTAssertGreaterThan(d.nativeHeight, 0)
        XCTAssertGreaterThan(d.aspectRatio, 0)
    }

    func testPlatformDefaultNativeDimensionsConsistent() {
        let d = ScreenDimensions.platformDefault
        XCTAssertEqual(d.nativeWidth, d.width * d.scale, accuracy: 0.001)
        XCTAssertEqual(d.nativeHeight, d.height * d.scale, accuracy: 0.001)
    }

    // MARK: - Edge cases

    func testTinyDimensions() {
        let d = ScreenDimensions(width: 1, height: 1, scale: 1)
        XCTAssertEqual(d.aspectRatio, 1.0, accuracy: 0.0001)
        XCTAssertEqual(d.minDimension, 1)
        XCTAssertEqual(d.maxDimension, 1)
    }

    func testLargeDimensions() {
        let d = ScreenDimensions(width: 2048, height: 1536, scale: 2.0)
        XCTAssertTrue(d.isLandscape)
        XCTAssertEqual(d.nativeWidth, 4096, accuracy: 0.001)
        XCTAssertEqual(d.nativeHeight, 3072, accuracy: 0.001)
    }
}

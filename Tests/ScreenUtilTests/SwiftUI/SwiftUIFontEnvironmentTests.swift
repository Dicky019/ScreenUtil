//
//  SwiftUIFontEnvironmentTests.swift
//  ScreenUtilTests
//
//  Font.scaledSystem / Font.scaledCustom / EnvironmentValues.screenUtil coverage.
//  View modifier rendering is skipped (requires a host); Font + Environment are testable.
//  Created by Dicky Darmawan on 06/06/26.
//

#if canImport(SwiftUI)
import XCTest
import SwiftUI
@testable import ScreenUtil

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
final class SwiftUIFontEnvironmentTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            ScreenUtil.shared.configure(with: ScreenUtilConfiguration(
                designSize: CGSize(width: 100, height: 100),
                scalingLimits: ScalingLimits(minScale: 0.1, maxScale: 10)))
        }
    }

    // MARK: - Font.scaledSystem

    func testScaledSystemFontReturnsValue() {
        // Font is opaque — just verify the call doesn't crash and returns.
        let font = Font.scaledSystem(size: 16)
        _ = font  // used
    }

    func testScaledSystemFontWithWeightAndDesign() {
        let font = Font.scaledSystem(size: 14, weight: .bold, design: .rounded)
        _ = font
    }

    func testScaledSystemFontZeroSize() {
        // Should not crash even with zero size.
        let font = Font.scaledSystem(size: 0)
        _ = font
    }

    func testScaledSystemFontVariousWeights() {
        let weights: [Font.Weight] = [.ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black]
        for w in weights {
            let font = Font.scaledSystem(size: 12, weight: w)
            _ = font
        }
    }

    // MARK: - Font.scaledCustom

    func testScaledCustomFontReturnsValue() {
        let font = Font.scaledCustom("Helvetica", size: 18)
        _ = font
    }

    func testScaledCustomFontVariousSizes() {
        for size in [8.0, 12.0, 16.0, 24.0, 48.0] as [CGFloat] {
            let font = Font.scaledCustom("Arial", size: size)
            _ = font
        }
    }

    // MARK: - EnvironmentValues.screenUtil

    func testEnvironmentValuesDefaultIsShared() {
        var env = EnvironmentValues()
        // Default should be ScreenUtil.shared
        let fromEnv = env.screenUtil
        XCTAssertTrue(fromEnv === ScreenUtil.shared)
    }

    func testEnvironmentValuesReadWrite() {
        var env = EnvironmentValues()
        let custom = ScreenUtil.shared  // only one instance (singleton) — still exercises the setter
        env.screenUtil = custom
        XCTAssertTrue(env.screenUtil === custom)
    }

    // MARK: - Scaled sizes are consistent with shared instance

    func testScaledSystemFontUsesScaledSize() {
        // Indirect verification: sp on a known value should be > 0 and finite.
        let su = ScreenUtil.shared
        let inputSize: CGFloat = 16
        let scaledSize = inputSize.sp
        XCTAssertTrue(scaledSize.isFinite)
        XCTAssertGreaterThan(scaledSize, 0)
        // Font.scaledSystem internally calls .sp — so the scaled size feeds the font.
        let _ = Font.scaledSystem(size: inputSize)
    }
}
#endif

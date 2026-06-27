//
//  ScreenUtilConfiguration.swift
//  ScreenUtil
//
//  Configuration management for ScreenUtil
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

/// Configuration for the ScreenUtil scaling engine, specifying the design canvas and scaling behaviour.
public struct ScreenUtilConfiguration: ScreenUtilConfigurable, Sendable, Equatable, Hashable {
    /// The reference design canvas size used to compute scale factors.
    public var designSize: CGSize
    /// When `true`, font scaling uses the minimum of width/height factors to prevent text from becoming too large.
    public var minTextAdapt: Bool
    /// The min/max bounds clamped onto all computed scale factors.
    public var scalingLimits: ScalingLimits

    /// Creates a configuration with the given design size, text adaptation flag, and scaling limits.
    public init(
        designSize: CGSize = CGSize(width: 375, height: 812),
        minTextAdapt: Bool = true,
        scalingLimits: ScalingLimits = .default
    ) {
        self.designSize = designSize
        self.minTextAdapt = minTextAdapt
        self.scalingLimits = scalingLimits
    }

    /// Preset for designs targeting the iPhone 12 / 12 Pro / 13 / 14 (390×844 pt).
    public static let iPhone12 = ScreenUtilConfiguration(
        designSize: CGSize(width: 390, height: 844)
    )

    /// Preset for designs targeting the iPhone 13 Pro (390×844 pt).
    public static let iPhone13Pro = ScreenUtilConfiguration(
        designSize: CGSize(width: 390, height: 844)
    )

    /// Preset for designs targeting the iPhone 14 Pro (393×852 pt).
    public static let iPhone14Pro = ScreenUtilConfiguration(
        designSize: CGSize(width: 393, height: 852)
    )

    /// Preset for designs targeting the iPhone 15 Pro (393×852 pt).
    public static let iPhone15Pro = ScreenUtilConfiguration(
        designSize: CGSize(width: 393, height: 852)
    )

    /// Preset for designs targeting the iPhone X / 11 Pro / 12 mini (375×812 pt).
    public static let iPhoneX = ScreenUtilConfiguration(
        designSize: CGSize(width: 375, height: 812)
    )

    /// Preset for designs targeting the iPhone 8 / SE 2nd gen (375×667 pt).
    public static let iPhone8 = ScreenUtilConfiguration(
        designSize: CGSize(width: 375, height: 667)
    )

    /// Preset for designs targeting the 11-inch iPad Pro (834×1194 pt) with strict scaling limits.
    public static let iPadPro11 = ScreenUtilConfiguration(
        designSize: CGSize(width: 834, height: 1194),
        scalingLimits: .strict
    )

    /// Preset for designs targeting the 12.9-inch iPad Pro (1024×1366 pt) with strict scaling limits.
    public static let iPadPro12_9 = ScreenUtilConfiguration(
        designSize: CGSize(width: 1024, height: 1366),
        scalingLimits: .strict
    )

    /// Returns `true` when `designSize` has positive, in-range dimensions (width ≤ 2000, height ≤ 3000).
    public func isValidDesignSize() -> Bool {
        return designSize.width > 0 && designSize.height > 0 &&
               designSize.width <= 2000 && designSize.height <= 3000
    }
}

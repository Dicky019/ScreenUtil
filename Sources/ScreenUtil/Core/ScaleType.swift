//
//  ScaleType.swift
//  ScreenUtil
//
//  Core protocols and scale types for ScreenUtil
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

/// Describes a type that holds the core ScreenUtil configuration values.
public protocol ScreenUtilConfigurable: Sendable {
    /// The reference design canvas size (e.g. 375×812 from Figma).
    var designSize: CGSize { get set }
    /// When `true`, text scaling uses the minimum of the width and height factors to prevent oversized text.
    var minTextAdapt: Bool { get set }
    /// The min/max bounds applied to all computed scale factors.
    var scalingLimits: ScalingLimits { get set }
}

/// Describes a type that can scale a value using a given `ScaleType`.
public protocol ScreenScalable: Sendable {
    /// Returns the scaled value for `value` using the specified `scaleType`.
    func scale(for value: CGFloat, scaleType: ScaleType) -> CGFloat
    /// Returns a fast (cached-factor) scaled value for `value` using the specified `scaleType`.
    func fastScale(for value: CGFloat, scaleType: ScaleType) -> CGFloat
}

/// Describes a type that exposes current device screen dimensions and inset metrics.
public protocol ScreenDimensionProvider: Sendable {
    /// The logical screen width in points.
    var screenWidth: CGFloat { get }
    /// The logical screen height in points.
    var screenHeight: CGFloat { get }
    /// The safe-area inset at the top of the screen in points.
    var safeAreaTop: CGFloat { get }
    /// The safe-area inset at the bottom of the screen in points.
    var safeAreaBottom: CGFloat { get }
    /// The status bar height in points.
    var statusBarHeight: CGFloat { get }
}

/// The dimension axis a value is scaled against.
public enum ScaleType: Sendable, Equatable, Hashable {
    /// Scale by the width factor (design width → device width).
    case width
    /// Scale by the height factor (design height → device height).
    case height
    /// Scale by the text factor (min of width/height when `minTextAdapt` is enabled).
    case text
    /// Scale by the smaller of the width and height factors, suitable for corner radii.
    case radius
}

//
//  ScreenMetrics.swift
//  ScreenUtil
//
//  Snapshot of current screen metrics
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

/// A point-in-time snapshot of the device screen metrics used for scaling.
public struct ScreenMetrics: Sendable, Equatable, Hashable {
    /// Logical screen width in points.
    public let width: CGFloat
    /// Logical screen height in points.
    public let height: CGFloat
    /// Native pixel density scale factor (e.g. 2.0 for @2x displays).
    public let scale: CGFloat
    /// Safe-area insets (top, bottom, left, right) in points.
    public let safeAreaInsets: (top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat)
    /// Status bar height in points.
    public let statusBarHeight: CGFloat

    /// Creates a `ScreenMetrics` snapshot with the given screen dimensions and insets.
    public init(
        width: CGFloat,
        height: CGFloat,
        scale: CGFloat,
        safeAreaInsets: (top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat),
        statusBarHeight: CGFloat
    ) {
        self.width = width
        self.height = height
        self.scale = scale
        self.safeAreaInsets = safeAreaInsets
        self.statusBarHeight = statusBarHeight
    }

    public static func == (lhs: ScreenMetrics, rhs: ScreenMetrics) -> Bool {
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.scale == rhs.scale &&
        lhs.safeAreaInsets == rhs.safeAreaInsets &&
        lhs.statusBarHeight == rhs.statusBarHeight
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(scale)
        hasher.combine(safeAreaInsets.top)
        hasher.combine(safeAreaInsets.bottom)
        hasher.combine(safeAreaInsets.left)
        hasher.combine(safeAreaInsets.right)
        hasher.combine(statusBarHeight)
    }
}

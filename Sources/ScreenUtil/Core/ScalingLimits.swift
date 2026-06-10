//
//  ScalingLimits.swift
//  ScreenUtil
//
//  Bounds applied to computed scale factors
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

/// Defines the minimum and maximum bounds that are clamped onto computed scale factors.
public struct ScalingLimits: Sendable, Equatable, Hashable {
    /// The lower bound for any scale factor; clamped to a minimum of 0.1 at initialisation.
    public let minScale: CGFloat
    /// The upper bound for any scale factor; clamped to a maximum of 5.0 at initialisation.
    public let maxScale: CGFloat

    /// Creates a `ScalingLimits` with the given min/max bounds (clamped to the absolute safe range 0.1–5.0).
    public init(minScale: CGFloat = 0.5, maxScale: CGFloat = 2.0) {
        self.minScale = max(0.1, minScale)
        self.maxScale = min(5.0, maxScale)
    }

    /// Returns `value` clamped to `[minScale, maxScale]`.
    public func clamp(_ value: CGFloat) -> CGFloat {
        return min(maxScale, max(minScale, value))
    }

    /// Default limits: 0.5–2.0, suitable for most iPhone designs.
    public static let `default` = ScalingLimits()

    /// Strict limits: 0.8–1.25, recommended for iPad and large-canvas designs.
    public static let strict = ScalingLimits(minScale: 0.8, maxScale: 1.25)

    /// Relaxed limits: 0.3–3.0, allowing wider scaling for experimental or TV layouts.
    public static let relaxed = ScalingLimits(minScale: 0.3, maxScale: 3.0)
}

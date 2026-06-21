//
//  FastScale.swift
//  ScreenUtil
//
//  High-performance scaling operations for hot paths
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

/// Capture-once scaling context that pre-stores scale factors for use in hot loops.
public struct FastScale: Sendable {
    private let cache: ScaleFactorCache

    internal init(cache: ScaleFactorCache) {
        self.cache = cache
    }

    /// Returns `value` scaled by the captured width factor.
    @inline(__always)
    public func width(_ value: CGFloat) -> CGFloat { cache.scaleWidth(value) }

    /// Returns `value` scaled by the captured height factor.
    @inline(__always)
    public func height(_ value: CGFloat) -> CGFloat { cache.scaleHeight(value) }

    /// Returns `value` scaled by the captured text factor.
    @inline(__always)
    public func text(_ value: CGFloat) -> CGFloat { cache.scaleText(value) }

    /// Returns `value` scaled by the smaller of the captured width and height factors.
    @inline(__always)
    public func radius(_ value: CGFloat) -> CGFloat { cache.scaleRadius(value) }

    /// Returns `value` with width and height each scaled by their respective captured factors.
    @inline(__always)
    public func size(_ value: CGSize) -> CGSize {
        CGSize(width: cache.scaleWidth(value.width), height: cache.scaleHeight(value.height))
    }

    /// Returns `value` with x scaled by the width factor and y by the height factor.
    @inline(__always)
    public func point(_ value: CGPoint) -> CGPoint {
        CGPoint(x: cache.scaleWidth(value.x), y: cache.scaleHeight(value.y))
    }

    /// Returns `value` with origin and size each scaled by their respective captured factors.
    @inline(__always)
    public func rect(_ value: CGRect) -> CGRect {
        CGRect(
            x: cache.scaleWidth(value.origin.x),
            y: cache.scaleHeight(value.origin.y),
            width: cache.scaleWidth(value.size.width),
            height: cache.scaleHeight(value.size.height)
        )
    }
}

public extension ScreenUtil {
    /// A `FastScale` instance pre-loaded with the current scale factors; use this to avoid per-value singleton lookups.
    @inline(__always)
    var fastScale: FastScale {
        FastScale(cache: ScaleFactorCache(from: self))
    }
}

/// Captures the current scale factors once and passes a `FastScale` to `operation`, returning its result.
@inline(__always)
public func withFastScale<T>(_ operation: (FastScale) -> T) -> T {
    return operation(ScreenUtil.shared.fastScale)
}

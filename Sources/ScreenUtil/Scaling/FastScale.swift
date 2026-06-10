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
    private let widthScale: CGFloat
    private let heightScale: CGFloat
    private let textScale: CGFloat

    internal init(widthScale: CGFloat, heightScale: CGFloat, textScale: CGFloat) {
        self.widthScale = widthScale
        self.heightScale = heightScale
        self.textScale = textScale
    }

    /// Returns `value` scaled by the captured width factor.
    @inline(__always)
    public func width(_ value: CGFloat) -> CGFloat {
        return value * widthScale
    }

    /// Returns `value` scaled by the captured height factor.
    @inline(__always)
    public func height(_ value: CGFloat) -> CGFloat {
        return value * heightScale
    }

    /// Returns `value` scaled by the captured text factor.
    @inline(__always)
    public func text(_ value: CGFloat) -> CGFloat {
        return value * textScale
    }

    /// Returns `value` scaled by the smaller of the captured width and height factors.
    @inline(__always)
    public func radius(_ value: CGFloat) -> CGFloat {
        return value * min(widthScale, heightScale)
    }

    /// Returns `value` with width and height each scaled by their respective captured factors.
    @inline(__always)
    public func size(_ value: CGSize) -> CGSize {
        return CGSize(width: value.width * widthScale, height: value.height * heightScale)
    }

    /// Returns `value` with x scaled by the width factor and y by the height factor.
    @inline(__always)
    public func point(_ value: CGPoint) -> CGPoint {
        return CGPoint(x: value.x * widthScale, y: value.y * heightScale)
    }

    /// Returns `value` with origin and size each scaled by their respective captured factors.
    @inline(__always)
    public func rect(_ value: CGRect) -> CGRect {
        return CGRect(
            x: value.origin.x * widthScale,
            y: value.origin.y * heightScale,
            width: value.size.width * widthScale,
            height: value.size.height * heightScale
        )
    }
}

public extension ScreenUtil {
    /// A `FastScale` instance pre-loaded with the current scale factors; use this to avoid per-value singleton lookups.
    @inline(__always)
    var fastScale: FastScale {
        let s = _snapshot
        return FastScale(widthScale: s.scaleWidth, heightScale: s.scaleHeight, textScale: s.scaleText)
    }
}

/// Captures the current scale factors once and passes a `FastScale` to `operation`, returning its result.
@inline(__always)
public func withFastScale<T>(_ operation: (FastScale) -> T) -> T {
    return operation(ScreenUtil.shared.fastScale)
}

//
//  ScaleFactorCache.swift
//  ScreenUtil
//
//  Captures scale factors once for repeated/batched scaling
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

@usableFromInline
struct ScaleFactorCache: Sendable {
    @usableFromInline let widthScale: CGFloat
    @usableFromInline let heightScale: CGFloat
    @usableFromInline let textScale: CGFloat
    @usableFromInline let radiusScale: CGFloat

    @usableFromInline
    init(from screenUtil: ScreenUtil) {
        let s = screenUtil._snapshot
        self.widthScale = s.scaleWidth
        self.heightScale = s.scaleHeight
        self.textScale = s.scaleText
        self.radiusScale = min(s.scaleWidth, s.scaleHeight)
    }

    @inlinable @inline(__always)
    func scaleWidth(_ value: CGFloat) -> CGFloat {
        return value * widthScale
    }

    @inlinable @inline(__always)
    func scaleHeight(_ value: CGFloat) -> CGFloat {
        return value * heightScale
    }

    @inlinable @inline(__always)
    func scaleText(_ value: CGFloat) -> CGFloat {
        return value * textScale
    }

    @inlinable @inline(__always)
    func scaleRadius(_ value: CGFloat) -> CGFloat {
        return value * radiusScale
    }
}

/// Bridges any `Numeric` value to `CGFloat` for batch scaling.
/// Handles the integer, floating-point, and `CGFloat` cases explicitly so
/// `CGFloat` arrays no longer silently scale to zero.
@inline(__always)
internal func cgFloatValue<T: Numeric>(_ value: T) -> CGFloat {
    switch value {
    case let v as CGFloat:
        return v
    case let v as Double:
        return CGFloat(v)
    case let v as Float:
        return CGFloat(v)
    case let v as Int:
        return CGFloat(v)
    default:
        if let v = value as? any BinaryInteger {
            return CGFloat(v)
        }
        if let v = value as? any BinaryFloatingPoint {
            return CGFloat(Double(v))
        }
        return 0
    }
}

//
//  ScaleFactorCache.swift
//  ScreenUtil
//
//  Captures scale factors once for repeated/batched scaling
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

internal struct ScaleFactorCache: Sendable {
    let widthScale: CGFloat
    let heightScale: CGFloat
    let textScale: CGFloat
    let radiusScale: CGFloat

    init(from screenUtil: ScreenUtil) {
        let s = screenUtil._snapshot
        self.widthScale = s.scaleWidth
        self.heightScale = s.scaleHeight
        self.textScale = s.scaleText
        self.radiusScale = min(s.scaleWidth, s.scaleHeight)
    }

    @inline(__always)
    func scaleWidth(_ value: CGFloat) -> CGFloat {
        return value * widthScale
    }

    @inline(__always)
    func scaleHeight(_ value: CGFloat) -> CGFloat {
        return value * heightScale
    }

    @inline(__always)
    func scaleText(_ value: CGFloat) -> CGFloat {
        return value * textScale
    }

    @inline(__always)
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
            return CGFloat(Int(v))
        }
        if let v = value as? any BinaryFloatingPoint {
            return CGFloat(Double(v))
        }
        return 0
    }
}

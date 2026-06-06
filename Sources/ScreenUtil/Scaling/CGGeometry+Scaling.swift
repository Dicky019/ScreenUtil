//
//  CGGeometry+Scaling.swift
//  ScreenUtil
//
//  Cross-platform scaling for CGSize / CGPoint / CGRect
//

import Foundation
import CoreGraphics

public extension CGSize {
    /// Scale this size using the shared ScreenUtil instance.
    @inline(__always)
    func scaled(for screenUtil: ScreenUtil = .shared) -> CGSize {
        return CGSize(width: screenUtil.w(width), height: screenUtil.h(height))
    }

    /// Build a scaled size from design values.
    @inline(__always)
    static func responsive(width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: width.w, height: height.h)
    }

    /// Scaled size from explicit design width/height.
    static func scaled(width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: width.w, height: height.h)
    }

    /// Scaled copy of the current size.
    var scaled: CGSize {
        return CGSize(width: width.w, height: height.h)
    }

    /// Fast (no-safety) scaled copy for hot paths.
    @inline(__always)
    func fastScaled() -> CGSize {
        return ScreenUtil.shared.fastScale.size(self)
    }
}

public extension CGPoint {
    @inline(__always)
    func scaled(for screenUtil: ScreenUtil = .shared) -> CGPoint {
        return CGPoint(x: screenUtil.w(x), y: screenUtil.h(y))
    }

    @inline(__always)
    static func responsive(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: x.w, y: y.h)
    }

    static func scaled(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: x.w, y: y.h)
    }

    var scaled: CGPoint {
        return CGPoint(x: x.w, y: y.h)
    }

    @inline(__always)
    func fastScaled() -> CGPoint {
        return ScreenUtil.shared.fastScale.point(self)
    }
}

public extension CGRect {
    @inline(__always)
    func scaled(for screenUtil: ScreenUtil = .shared) -> CGRect {
        return CGRect(
            x: screenUtil.w(origin.x),
            y: screenUtil.h(origin.y),
            width: screenUtil.w(size.width),
            height: screenUtil.h(size.height)
        )
    }

    @inline(__always)
    static func responsive(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x.w, y: y.h, width: width.w, height: height.h)
    }

    static func scaled(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x.w, y: y.h, width: width.w, height: height.h)
    }

    var scaled: CGRect {
        return CGRect(x: origin.x.w, y: origin.y.h, width: size.width.w, height: size.height.h)
    }

    @inline(__always)
    func fastScaled() -> CGRect {
        return ScreenUtil.shared.fastScale.rect(self)
    }
}

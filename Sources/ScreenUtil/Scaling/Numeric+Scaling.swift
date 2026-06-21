//
//  Numeric+Scaling.swift
//  ScreenUtil
//
//  Convenient numeric extensions for responsive design
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

// Scaling extensions for every integer and floating-point numeric type.
// Direct numeric-to-CGFloat conversion: BinaryInteger via CGFloat(self),
// BinaryFloatingPoint via CGFloat(Double(self)).

public extension BinaryInteger {
    /// Value scaled by the width factor (design width → device width).
    @inlinable @inline(__always) var w: CGFloat { ScreenUtil.shared.w(CGFloat(self)) }
    /// Value scaled by the height factor (design height → device height).
    @inlinable @inline(__always) var h: CGFloat { ScreenUtil.shared.h(CGFloat(self)) }
    /// Value scaled as a font size (min of width/height when `minTextAdapt` is enabled).
    @inlinable @inline(__always) var sp: CGFloat { ScreenUtil.shared.sp(CGFloat(self)) }
    /// Value scaled by the smaller of width/height factors, suitable for corner radii.
    @inlinable @inline(__always) var r: CGFloat { ScreenUtil.shared.r(CGFloat(self)) }
    /// Value expressed as a percentage of the screen width.
    @inlinable @inline(__always) var sw: CGFloat { ScreenUtil.shared.sw(CGFloat(self)) }
    /// Value expressed as a percentage of the screen height.
    @inlinable @inline(__always) var sh: CGFloat { ScreenUtil.shared.sh(CGFloat(self)) }
}

public extension BinaryFloatingPoint {
    /// Value scaled by the width factor (design width → device width).
    @inlinable @inline(__always) var w: CGFloat { ScreenUtil.shared.w(CGFloat(Double(self))) }
    /// Value scaled by the height factor (design height → device height).
    @inlinable @inline(__always) var h: CGFloat { ScreenUtil.shared.h(CGFloat(Double(self))) }
    /// Value scaled as a font size (min of width/height when `minTextAdapt` is enabled).
    @inlinable @inline(__always) var sp: CGFloat { ScreenUtil.shared.sp(CGFloat(Double(self))) }
    /// Value scaled by the smaller of width/height factors, suitable for corner radii.
    @inlinable @inline(__always) var r: CGFloat { ScreenUtil.shared.r(CGFloat(Double(self))) }
    /// Value expressed as a percentage of the screen width.
    @inlinable @inline(__always) var sw: CGFloat { ScreenUtil.shared.sw(CGFloat(Double(self))) }
    /// Value expressed as a percentage of the screen height.
    @inlinable @inline(__always) var sh: CGFloat { ScreenUtil.shared.sh(CGFloat(Double(self))) }
}

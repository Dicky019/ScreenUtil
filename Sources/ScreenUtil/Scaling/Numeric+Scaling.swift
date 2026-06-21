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
// `cgFloatValue` is the single Numeric→CGFloat bridge (Int64/UInt/CGFloat safe).

public extension BinaryInteger {
    /// Value scaled by the width factor (design width → device width).
    @inline(__always) var w: CGFloat { ScreenUtil.shared.w(cgFloatValue(self)) }
    /// Value scaled by the height factor (design height → device height).
    @inline(__always) var h: CGFloat { ScreenUtil.shared.h(cgFloatValue(self)) }
    /// Value scaled as a font size (min of width/height when `minTextAdapt` is enabled).
    @inline(__always) var sp: CGFloat { ScreenUtil.shared.sp(cgFloatValue(self)) }
    /// Value scaled by the smaller of width/height factors, suitable for corner radii.
    @inline(__always) var r: CGFloat { ScreenUtil.shared.r(cgFloatValue(self)) }
    /// Value expressed as a fraction of the screen width (0…1 → 0…screenWidth).
    @inline(__always) var sw: CGFloat { ScreenUtil.shared.sw(cgFloatValue(self)) }
    /// Value expressed as a fraction of the screen height (0…1 → 0…screenHeight).
    @inline(__always) var sh: CGFloat { ScreenUtil.shared.sh(cgFloatValue(self)) }
}

public extension BinaryFloatingPoint {
    /// Value scaled by the width factor (design width → device width).
    @inline(__always) var w: CGFloat { ScreenUtil.shared.w(cgFloatValue(self)) }
    /// Value scaled by the height factor (design height → device height).
    @inline(__always) var h: CGFloat { ScreenUtil.shared.h(cgFloatValue(self)) }
    /// Value scaled as a font size (min of width/height when `minTextAdapt` is enabled).
    @inline(__always) var sp: CGFloat { ScreenUtil.shared.sp(cgFloatValue(self)) }
    /// Value scaled by the smaller of width/height factors, suitable for corner radii.
    @inline(__always) var r: CGFloat { ScreenUtil.shared.r(cgFloatValue(self)) }
    /// Value expressed as a fraction of the screen width (0…1 → 0…screenWidth).
    @inline(__always) var sw: CGFloat { ScreenUtil.shared.sw(cgFloatValue(self)) }
    /// Value expressed as a fraction of the screen height (0…1 → 0…screenHeight).
    @inline(__always) var sh: CGFloat { ScreenUtil.shared.sh(cgFloatValue(self)) }
}

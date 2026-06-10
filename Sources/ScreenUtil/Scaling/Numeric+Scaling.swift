//
//  Numeric+Scaling.swift
//  ScreenUtil
//
//  Convenient numeric extensions for responsive design
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

public extension Int {
    /// Value scaled by the width factor (design width → device width).
    @inline(__always)
    var w: CGFloat {
        return ScreenUtil.shared.w(CGFloat(self))
    }

    /// Value scaled by the height factor (design height → device height).
    @inline(__always)
    var h: CGFloat {
        return ScreenUtil.shared.h(CGFloat(self))
    }

    /// Value scaled as a font size (uses min of width/height when `minTextAdapt` is enabled).
    @inline(__always)
    var sp: CGFloat {
        return ScreenUtil.shared.sp(CGFloat(self))
    }

    /// Value scaled by the smaller of width/height factors, suitable for corner radii.
    @inline(__always)
    var r: CGFloat {
        return ScreenUtil.shared.r(CGFloat(self))
    }

    /// Value expressed as a fraction of the screen width (0…1 → 0…screenWidth).
    @inline(__always)
    var sw: CGFloat {
        return ScreenUtil.shared.sw(CGFloat(self))
    }

    /// Value expressed as a fraction of the screen height (0…1 → 0…screenHeight).
    @inline(__always)
    var sh: CGFloat {
        return ScreenUtil.shared.sh(CGFloat(self))
    }

    /// Width-scaled value using the cached fast path (lower overhead than `.w` for tight loops).
    @inline(__always)
    var fastW: CGFloat {
        return ScreenUtil.shared.fastW(CGFloat(self))
    }

    /// Height-scaled value using the cached fast path (lower overhead than `.h` for tight loops).
    @inline(__always)
    var fastH: CGFloat {
        return ScreenUtil.shared.fastH(CGFloat(self))
    }

    /// Font-size-scaled value using the cached fast path (lower overhead than `.sp` for tight loops).
    @inline(__always)
    var fastSp: CGFloat {
        return ScreenUtil.shared.fastSp(CGFloat(self))
    }
}

public extension Float {
    /// Value scaled by the width factor (design width → device width).
    @inline(__always)
    var w: CGFloat {
        return ScreenUtil.shared.w(CGFloat(self))
    }

    /// Value scaled by the height factor (design height → device height).
    @inline(__always)
    var h: CGFloat {
        return ScreenUtil.shared.h(CGFloat(self))
    }

    /// Value scaled as a font size (uses min of width/height when `minTextAdapt` is enabled).
    @inline(__always)
    var sp: CGFloat {
        return ScreenUtil.shared.sp(CGFloat(self))
    }

    /// Value scaled by the smaller of width/height factors, suitable for corner radii.
    @inline(__always)
    var r: CGFloat {
        return ScreenUtil.shared.r(CGFloat(self))
    }

    /// Value expressed as a fraction of the screen width (0…1 → 0…screenWidth).
    @inline(__always)
    var sw: CGFloat {
        return ScreenUtil.shared.sw(CGFloat(self))
    }

    /// Value expressed as a fraction of the screen height (0…1 → 0…screenHeight).
    @inline(__always)
    var sh: CGFloat {
        return ScreenUtil.shared.sh(CGFloat(self))
    }

    /// Width-scaled value using the cached fast path (lower overhead than `.w` for tight loops).
    @inline(__always)
    var fastW: CGFloat {
        return ScreenUtil.shared.fastW(CGFloat(self))
    }

    /// Height-scaled value using the cached fast path (lower overhead than `.h` for tight loops).
    @inline(__always)
    var fastH: CGFloat {
        return ScreenUtil.shared.fastH(CGFloat(self))
    }

    /// Font-size-scaled value using the cached fast path (lower overhead than `.sp` for tight loops).
    @inline(__always)
    var fastSp: CGFloat {
        return ScreenUtil.shared.fastSp(CGFloat(self))
    }
}

public extension Double {
    /// Value scaled by the width factor (design width → device width).
    @inline(__always)
    var w: CGFloat {
        return ScreenUtil.shared.w(CGFloat(self))
    }

    /// Value scaled by the height factor (design height → device height).
    @inline(__always)
    var h: CGFloat {
        return ScreenUtil.shared.h(CGFloat(self))
    }

    /// Value scaled as a font size (uses min of width/height when `minTextAdapt` is enabled).
    @inline(__always)
    var sp: CGFloat {
        return ScreenUtil.shared.sp(CGFloat(self))
    }

    /// Value scaled by the smaller of width/height factors, suitable for corner radii.
    @inline(__always)
    var r: CGFloat {
        return ScreenUtil.shared.r(CGFloat(self))
    }

    /// Value expressed as a fraction of the screen width (0…1 → 0…screenWidth).
    @inline(__always)
    var sw: CGFloat {
        return ScreenUtil.shared.sw(CGFloat(self))
    }

    /// Value expressed as a fraction of the screen height (0…1 → 0…screenHeight).
    @inline(__always)
    var sh: CGFloat {
        return ScreenUtil.shared.sh(CGFloat(self))
    }

    /// Width-scaled value using the cached fast path (lower overhead than `.w` for tight loops).
    @inline(__always)
    var fastW: CGFloat {
        return ScreenUtil.shared.fastW(CGFloat(self))
    }

    /// Height-scaled value using the cached fast path (lower overhead than `.h` for tight loops).
    @inline(__always)
    var fastH: CGFloat {
        return ScreenUtil.shared.fastH(CGFloat(self))
    }

    /// Font-size-scaled value using the cached fast path (lower overhead than `.sp` for tight loops).
    @inline(__always)
    var fastSp: CGFloat {
        return ScreenUtil.shared.fastSp(CGFloat(self))
    }
}

public extension CGFloat {
    /// Value scaled by the width factor (design width → device width).
    @inline(__always)
    var w: CGFloat {
        return ScreenUtil.shared.w(self)
    }

    /// Value scaled by the height factor (design height → device height).
    @inline(__always)
    var h: CGFloat {
        return ScreenUtil.shared.h(self)
    }

    /// Value scaled as a font size (uses min of width/height when `minTextAdapt` is enabled).
    @inline(__always)
    var sp: CGFloat {
        return ScreenUtil.shared.sp(self)
    }

    /// Value scaled by the smaller of width/height factors, suitable for corner radii.
    @inline(__always)
    var r: CGFloat {
        return ScreenUtil.shared.r(self)
    }

    /// Value expressed as a fraction of the screen width (0…1 → 0…screenWidth).
    @inline(__always)
    var sw: CGFloat {
        return ScreenUtil.shared.sw(self)
    }

    /// Value expressed as a fraction of the screen height (0…1 → 0…screenHeight).
    @inline(__always)
    var sh: CGFloat {
        return ScreenUtil.shared.sh(self)
    }

    /// Width-scaled value using the cached fast path (lower overhead than `.w` for tight loops).
    @inline(__always)
    var fastW: CGFloat {
        return ScreenUtil.shared.fastW(self)
    }

    /// Height-scaled value using the cached fast path (lower overhead than `.h` for tight loops).
    @inline(__always)
    var fastH: CGFloat {
        return ScreenUtil.shared.fastH(self)
    }

    /// Font-size-scaled value using the cached fast path (lower overhead than `.sp` for tight loops).
    @inline(__always)
    var fastSp: CGFloat {
        return ScreenUtil.shared.fastSp(self)
    }
}

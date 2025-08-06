//
//  NumericExtensions.swift
//  ScreenUtil
//
//  Convenient numeric extensions for responsive design
//

import Foundation
import CoreGraphics

public extension Int {
    @inline(__always)
    var w: CGFloat {
        return ScreenUtil.shared.w(CGFloat(self))
    }
    
    @inline(__always)
    var h: CGFloat {
        return ScreenUtil.shared.h(CGFloat(self))
    }
    
    @inline(__always)
    var sp: CGFloat {
        return ScreenUtil.shared.sp(CGFloat(self))
    }
    
    @inline(__always)
    var r: CGFloat {
        return ScreenUtil.shared.r(CGFloat(self))
    }
    
    @inline(__always)
    var sw: CGFloat {
        return ScreenUtil.shared.sw(CGFloat(self))
    }
    
    @inline(__always)
    var sh: CGFloat {
        return ScreenUtil.shared.sh(CGFloat(self))
    }
    
    @inline(__always)
    var fastW: CGFloat {
        return ScreenUtil.shared.fastW(CGFloat(self))
    }
    
    @inline(__always)
    var fastH: CGFloat {
        return ScreenUtil.shared.fastH(CGFloat(self))
    }
    
    @inline(__always)
    var fastSp: CGFloat {
        return ScreenUtil.shared.fastSp(CGFloat(self))
    }
}

public extension Float {
    @inline(__always)
    var w: CGFloat {
        return ScreenUtil.shared.w(CGFloat(self))
    }
    
    @inline(__always)
    var h: CGFloat {
        return ScreenUtil.shared.h(CGFloat(self))
    }
    
    @inline(__always)
    var sp: CGFloat {
        return ScreenUtil.shared.sp(CGFloat(self))
    }
    
    @inline(__always)
    var r: CGFloat {
        return ScreenUtil.shared.r(CGFloat(self))
    }
    
    @inline(__always)
    var sw: CGFloat {
        return ScreenUtil.shared.sw(CGFloat(self))
    }
    
    @inline(__always)
    var sh: CGFloat {
        return ScreenUtil.shared.sh(CGFloat(self))
    }
    
    @inline(__always)
    var fastW: CGFloat {
        return ScreenUtil.shared.fastW(CGFloat(self))
    }
    
    @inline(__always)
    var fastH: CGFloat {
        return ScreenUtil.shared.fastH(CGFloat(self))
    }
    
    @inline(__always)
    var fastSp: CGFloat {
        return ScreenUtil.shared.fastSp(CGFloat(self))
    }
}

public extension Double {
    @inline(__always)
    var w: CGFloat {
        return ScreenUtil.shared.w(CGFloat(self))
    }
    
    @inline(__always)
    var h: CGFloat {
        return ScreenUtil.shared.h(CGFloat(self))
    }
    
    @inline(__always)
    var sp: CGFloat {
        return ScreenUtil.shared.sp(CGFloat(self))
    }
    
    @inline(__always)
    var r: CGFloat {
        return ScreenUtil.shared.r(CGFloat(self))
    }
    
    @inline(__always)
    var sw: CGFloat {
        return ScreenUtil.shared.sw(CGFloat(self))
    }
    
    @inline(__always)
    var sh: CGFloat {
        return ScreenUtil.shared.sh(CGFloat(self))
    }
    
    @inline(__always)
    var fastW: CGFloat {
        return ScreenUtil.shared.fastW(CGFloat(self))
    }
    
    @inline(__always)
    var fastH: CGFloat {
        return ScreenUtil.shared.fastH(CGFloat(self))
    }
    
    @inline(__always)
    var fastSp: CGFloat {
        return ScreenUtil.shared.fastSp(CGFloat(self))
    }
}

public extension CGFloat {
    @inline(__always)
    var w: CGFloat {
        return ScreenUtil.shared.w(self)
    }
    
    @inline(__always)
    var h: CGFloat {
        return ScreenUtil.shared.h(self)
    }
    
    @inline(__always)
    var sp: CGFloat {
        return ScreenUtil.shared.sp(self)
    }
    
    @inline(__always)
    var r: CGFloat {
        return ScreenUtil.shared.r(self)
    }
    
    @inline(__always)
    var sw: CGFloat {
        return ScreenUtil.shared.sw(self)
    }
    
    @inline(__always)
    var sh: CGFloat {
        return ScreenUtil.shared.sh(self)
    }
    
    @inline(__always)
    var fastW: CGFloat {
        return ScreenUtil.shared.fastW(self)
    }
    
    @inline(__always)
    var fastH: CGFloat {
        return ScreenUtil.shared.fastH(self)
    }
    
    @inline(__always)
    var fastSp: CGFloat {
        return ScreenUtil.shared.fastSp(self)
    }
}

public extension Array where Element: Numeric {
    @inline(__always)
    func scaled(by scaleType: ScaleType) -> [CGFloat] {
        return self.map { value in
            let cgValue = CGFloat(Double("\(value)") ?? 0)
            return ScreenUtil.shared.scale(for: cgValue, scaleType: scaleType)
        }
    }
    
    @inline(__always)
    func scaledWidths() -> [CGFloat] {
        return scaled(by: .width)
    }
    
    @inline(__always)
    func scaledHeights() -> [CGFloat] {
        return scaled(by: .height)
    }
}
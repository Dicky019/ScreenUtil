//
//  FastScale.swift
//  ScreenUtil
//
//  High-performance scaling operations for hot paths
//

import Foundation
import CoreGraphics

public struct FastScale: Sendable {
    private let widthScale: CGFloat
    private let heightScale: CGFloat
    private let textScale: CGFloat
    
    internal init(widthScale: CGFloat, heightScale: CGFloat, textScale: CGFloat) {
        self.widthScale = widthScale
        self.heightScale = heightScale
        self.textScale = textScale
    }
    
    @inline(__always)
    public func width(_ value: CGFloat) -> CGFloat {
        return value * widthScale
    }
    
    @inline(__always)
    public func height(_ value: CGFloat) -> CGFloat {
        return value * heightScale
    }
    
    @inline(__always)
    public func text(_ value: CGFloat) -> CGFloat {
        return value * textScale
    }
    
    @inline(__always)
    public func radius(_ value: CGFloat) -> CGFloat {
        let minScale = min(widthScale, heightScale)
        return value * minScale
    }
    
    @inline(__always)
    public func size(_ value: CGSize) -> CGSize {
        return CGSize(width: value.width * widthScale, height: value.height * heightScale)
    }
    
    @inline(__always)
    public func point(_ value: CGPoint) -> CGPoint {
        return CGPoint(x: value.x * widthScale, y: value.y * heightScale)
    }
    
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
    @inline(__always)
    var fastScale: FastScale {
        return FastScale(
            widthScale: _scaleWidth,
            heightScale: _scaleHeight,
            textScale: _scaleText
        )
    }
}

@inline(__always)
public func withFastScale<T>(_ operation: (FastScale) -> T) -> T {
    return operation(ScreenUtil.shared.fastScale)
}

internal struct ScaleFactorCache: Sendable {
    private let widthScale: CGFloat
    private let heightScale: CGFloat
    private let textScale: CGFloat
    private let radiusScale: CGFloat
    
    init(from screenUtil: ScreenUtil) {
        self.widthScale = screenUtil._scaleWidth
        self.heightScale = screenUtil._scaleHeight
        self.textScale = screenUtil._scaleText
        self.radiusScale = min(screenUtil._scaleWidth, screenUtil._scaleHeight)
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
    
    @inline(__always)
    func scale(_ value: CGFloat, type: ScaleType) -> CGFloat {
        switch type {
        case .width:
            return scaleWidth(value)
        case .height:
            return scaleHeight(value)
        case .text, .font:
            return scaleText(value)
        case .radius:
            return scaleRadius(value)
        case .min:
            return scaleRadius(value)
        case .max:
            return value * max(widthScale, heightScale)
        case .auto:
            return scaleWidth(value) // Default to width scaling for auto
        }
    }
}
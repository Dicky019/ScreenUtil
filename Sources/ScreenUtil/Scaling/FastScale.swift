//
//  FastScale.swift
//  ScreenUtil
//
//  High-performance scaling operations for hot paths
//  Created by Dicky Darmawan on 06/06/26.
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
        return value * min(widthScale, heightScale)
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
        let s = _snapshot
        return FastScale(widthScale: s.scaleWidth, heightScale: s.scaleHeight, textScale: s.scaleText)
    }
}

@inline(__always)
public func withFastScale<T>(_ operation: (FastScale) -> T) -> T {
    return operation(ScreenUtil.shared.fastScale)
}

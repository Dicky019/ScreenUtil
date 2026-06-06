//
//  BatchScaling.swift
//  ScreenUtil
//
//  High-performance batch scaling operations
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics
#if canImport(UIKit)
import UIKit
#endif

public extension ScreenUtil {
    @inline(__always)
    func batchScale<T: Numeric>(_ values: [T], scaleType: ScaleType) -> [CGFloat] {
        let cache = ScaleFactorCache(from: self)
        return values.map { value in
            let cgValue = cgFloatValue(value)
            switch scaleType {
            case .width:
                return cache.scaleWidth(cgValue)
            case .height:
                return cache.scaleHeight(cgValue)
            case .text, .font:
                return cache.scaleText(cgValue)
            case .radius, .min:
                return cache.scaleRadius(cgValue)
            case .max:
                return cgValue * max(cache.widthScale, cache.heightScale)
            case .auto:
                return cache.scaleWidth(cgValue)
            }
        }
    }

    @inline(__always)
    func batchWidths<T: Numeric>(_ values: [T]) -> [CGFloat] {
        let cache = ScaleFactorCache(from: self)
        return values.map { cache.scaleWidth(cgFloatValue($0)) }
    }

    @inline(__always)
    func batchHeights<T: Numeric>(_ values: [T]) -> [CGFloat] {
        let cache = ScaleFactorCache(from: self)
        return values.map { cache.scaleHeight(cgFloatValue($0)) }
    }

    @inline(__always)
    func batchFontSizes<T: Numeric>(_ values: [T]) -> [CGFloat] {
        let cache = ScaleFactorCache(from: self)
        return values.map { cache.scaleText(cgFloatValue($0)) }
    }

    @inline(__always)
    func batchSizes(_ sizes: [CGSize]) -> [CGSize] {
        let cache = ScaleFactorCache(from: self)
        return sizes.map { CGSize(width: cache.scaleWidth($0.width), height: cache.scaleHeight($0.height)) }
    }

    @inline(__always)
    func batchPoints(_ points: [CGPoint]) -> [CGPoint] {
        let cache = ScaleFactorCache(from: self)
        return points.map { CGPoint(x: cache.scaleWidth($0.x), y: cache.scaleHeight($0.y)) }
    }

    @inline(__always)
    func batchRects(_ rects: [CGRect]) -> [CGRect] {
        let cache = ScaleFactorCache(from: self)
        return rects.map { rect in
            CGRect(
                x: cache.scaleWidth(rect.origin.x),
                y: cache.scaleHeight(rect.origin.y),
                width: cache.scaleWidth(rect.size.width),
                height: cache.scaleHeight(rect.size.height)
            )
        }
    }

    #if canImport(UIKit)
    @inline(__always)
    func batchEdgeInsets(_ insets: [UIEdgeInsets]) -> [UIEdgeInsets] {
        let cache = ScaleFactorCache(from: self)
        return insets.map { inset in
            UIEdgeInsets(
                top: cache.scaleHeight(inset.top),
                left: cache.scaleWidth(inset.left),
                bottom: cache.scaleHeight(inset.bottom),
                right: cache.scaleWidth(inset.right)
            )
        }
    }
    #endif
}

public struct BatchScaler: Sendable {
    private let cache: ScaleFactorCache

    internal init(from screenUtil: ScreenUtil) {
        self.cache = ScaleFactorCache(from: screenUtil)
    }

    @inline(__always)
    public func widths<T: Numeric>(_ values: [T]) -> [CGFloat] {
        return values.map { cache.scaleWidth(cgFloatValue($0)) }
    }

    @inline(__always)
    public func heights<T: Numeric>(_ values: [T]) -> [CGFloat] {
        return values.map { cache.scaleHeight(cgFloatValue($0)) }
    }

    @inline(__always)
    public func fontSizes<T: Numeric>(_ values: [T]) -> [CGFloat] {
        return values.map { cache.scaleText(cgFloatValue($0)) }
    }

    @inline(__always)
    public func radii<T: Numeric>(_ values: [T]) -> [CGFloat] {
        return values.map { cache.scaleRadius(cgFloatValue($0)) }
    }

    @inline(__always)
    public func sizes(_ sizes: [CGSize]) -> [CGSize] {
        return sizes.map { CGSize(width: cache.scaleWidth($0.width), height: cache.scaleHeight($0.height)) }
    }

    #if canImport(UIKit)
    @inline(__always)
    public func edgeInsets(_ insets: [UIEdgeInsets]) -> [UIEdgeInsets] {
        return insets.map { inset in
            UIEdgeInsets(
                top: cache.scaleHeight(inset.top),
                left: cache.scaleWidth(inset.left),
                bottom: cache.scaleHeight(inset.bottom),
                right: cache.scaleWidth(inset.right)
            )
        }
    }
    #endif
}

public extension ScreenUtil {
    var batchScaler: BatchScaler {
        return BatchScaler(from: self)
    }
}

@inline(__always)
public func withBatchScaler<T>(_ operation: (BatchScaler) -> T) -> T {
    return operation(ScreenUtil.shared.batchScaler)
}

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
    /// Scales an array of numeric values using the specified `scaleType`, returning scaled `CGFloat` values.
    @inline(__always)
    func batchScale<T: Numeric>(_ values: [T], scaleType: ScaleType) -> [CGFloat] {
        let cache = ScaleFactorCache(from: self)
        return values.map { value in
            let cgValue = cgFloatValue(value)
            switch scaleType {
            case .width:  return cache.scaleWidth(cgValue)
            case .height: return cache.scaleHeight(cgValue)
            case .text:   return cache.scaleText(cgValue)
            case .radius: return cache.scaleRadius(cgValue)
            }
        }
    }

    /// Scales an array of numeric values by the width factor, returning scaled `CGFloat` values.
    @inline(__always)
    func batchWidths<T: Numeric>(_ values: [T]) -> [CGFloat] {
        let cache = ScaleFactorCache(from: self)
        return values.map { cache.scaleWidth(cgFloatValue($0)) }
    }

    /// Scales an array of numeric values by the height factor, returning scaled `CGFloat` values.
    @inline(__always)
    func batchHeights<T: Numeric>(_ values: [T]) -> [CGFloat] {
        let cache = ScaleFactorCache(from: self)
        return values.map { cache.scaleHeight(cgFloatValue($0)) }
    }

    /// Scales an array of numeric values as font sizes using the text scale factor, returning scaled `CGFloat` values.
    @inline(__always)
    func batchFontSizes<T: Numeric>(_ values: [T]) -> [CGFloat] {
        let cache = ScaleFactorCache(from: self)
        return values.map { cache.scaleText(cgFloatValue($0)) }
    }

    /// Scales an array of `CGSize` values, applying width and height factors independently.
    @inline(__always)
    func batchSizes(_ sizes: [CGSize]) -> [CGSize] {
        let cache = ScaleFactorCache(from: self)
        return sizes.map { CGSize(width: cache.scaleWidth($0.width), height: cache.scaleHeight($0.height)) }
    }

    /// Scales an array of `CGPoint` values, applying width factor to x and height factor to y.
    @inline(__always)
    func batchPoints(_ points: [CGPoint]) -> [CGPoint] {
        let cache = ScaleFactorCache(from: self)
        return points.map { CGPoint(x: cache.scaleWidth($0.x), y: cache.scaleHeight($0.y)) }
    }

    /// Scales an array of `CGRect` values, applying width and height factors to origin and size.
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
    /// Scales an array of `UIEdgeInsets` values, applying width factor to left/right and height factor to top/bottom.
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

/// Reusable batch-scaling context that captures scale factors once for efficient repeated scaling.
public struct BatchScaler: Sendable {
    private let cache: ScaleFactorCache

    internal init(from screenUtil: ScreenUtil) {
        self.cache = ScaleFactorCache(from: screenUtil)
    }

    /// Scales an array of numeric values by the captured width factor.
    @inline(__always)
    public func widths<T: Numeric>(_ values: [T]) -> [CGFloat] {
        return values.map { cache.scaleWidth(cgFloatValue($0)) }
    }

    /// Scales an array of numeric values by the captured height factor.
    @inline(__always)
    public func heights<T: Numeric>(_ values: [T]) -> [CGFloat] {
        return values.map { cache.scaleHeight(cgFloatValue($0)) }
    }

    /// Scales an array of numeric values as font sizes using the captured text scale factor.
    @inline(__always)
    public func fontSizes<T: Numeric>(_ values: [T]) -> [CGFloat] {
        return values.map { cache.scaleText(cgFloatValue($0)) }
    }

    /// Scales an array of numeric values using the smaller of the captured width/height factors.
    @inline(__always)
    public func radii<T: Numeric>(_ values: [T]) -> [CGFloat] {
        return values.map { cache.scaleRadius(cgFloatValue($0)) }
    }

    /// Scales an array of `CGSize` values using the captured width and height factors.
    @inline(__always)
    public func sizes(_ sizes: [CGSize]) -> [CGSize] {
        return sizes.map { CGSize(width: cache.scaleWidth($0.width), height: cache.scaleHeight($0.height)) }
    }

    #if canImport(UIKit)
    /// Scales an array of `UIEdgeInsets` values using the captured width and height factors.
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
    /// A `BatchScaler` pre-loaded with the current scale factors; reuse across multiple batch calls to amortise setup cost.
    var batchScaler: BatchScaler {
        return BatchScaler(from: self)
    }
}

/// Captures the current scale factors once, passes a `BatchScaler` to `operation`, and returns its result.
@inline(__always)
public func withBatchScaler<T>(_ operation: (BatchScaler) -> T) -> T {
    return operation(ScreenUtil.shared.batchScaler)
}

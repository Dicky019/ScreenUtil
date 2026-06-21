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

    /// Scales an array of numeric values by the captured factor for `scaleType`.
    @inline(__always)
    public func scale<T: Numeric>(_ values: [T], scaleType: ScaleType) -> [CGFloat] {
        values.map { value in
            let v = cgFloatValue(value)
            switch scaleType {
            case .width:  return cache.scaleWidth(v)
            case .height: return cache.scaleHeight(v)
            case .text:   return cache.scaleText(v)
            case .radius: return cache.scaleRadius(v)
            }
        }
    }

    /// Scales an array of `CGSize` values using the captured width and height factors.
    @inline(__always)
    public func sizes(_ sizes: [CGSize]) -> [CGSize] {
        return sizes.map { CGSize(width: cache.scaleWidth($0.width), height: cache.scaleHeight($0.height)) }
    }

    /// Scales an array of `CGPoint` values using the captured width and height factors.
    @inline(__always)
    public func points(_ points: [CGPoint]) -> [CGPoint] {
        points.map { CGPoint(x: cache.scaleWidth($0.x), y: cache.scaleHeight($0.y)) }
    }

    /// Scales an array of `CGRect` values using the captured width and height factors.
    @inline(__always)
    public func rects(_ rects: [CGRect]) -> [CGRect] {
        rects.map {
            CGRect(x: cache.scaleWidth($0.origin.x), y: cache.scaleHeight($0.origin.y),
                   width: cache.scaleWidth($0.size.width), height: cache.scaleHeight($0.size.height))
        }
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

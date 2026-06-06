//
//  ScreenUtil.swift
//  ScreenUtil
//
//  High-performance, thread-safe screen adaptation engine with lock-free reads
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics
import Atomics

public final class ScreenUtil: ScreenScalable, ScreenDimensionProvider, @unchecked Sendable {
    public static let shared = ScreenUtil()

    @Atomic private var configuration: ScreenUtilConfiguration
    private let dimensionsCache = ScreenDimensionsCache()
    private let safeAreaCache = SafeAreaCacheManager()

    private let factors = ManagedAtomic<ScaleFactors>(
        ScaleFactors(width: 1.0, height: 1.0, text: 1.0, screenWidth: 375.0, screenHeight: 812.0)
    )

    /// Single consistent snapshot of the current scale factors.
    internal var _factors: ScaleFactors {
        factors.load(ordering: .acquiring)
    }

    internal var _scaleWidth: CGFloat { _factors.width }
    internal var _scaleHeight: CGFloat { _factors.height }
    internal var _scaleText: CGFloat { _factors.text }

    private let configurationLock = os_unfair_lock_t.allocate(capacity: 1)

    private init() {
        self.configuration = ScreenUtilConfiguration()
        configurationLock.initialize(to: os_unfair_lock())
        updateScaleFactors()
        preWarmCaches()
    }

    deinit {
        configurationLock.deinitialize(count: 1)
        configurationLock.deallocate()
    }

    public func configure(with config: ScreenUtilConfiguration) {
        os_unfair_lock_lock(configurationLock)
        defer { os_unfair_lock_unlock(configurationLock) }

        guard config.isValidDesignSize() else {
            assertionFailure("Invalid design size: \(config.designSize)")
            return
        }

        configuration = config
        updateScaleFactors()
    }

    private func updateScaleFactors() {
        let screenDimensions = dimensionsCache.getDimensions()
        let designSize = configuration.designSize

        let scaleWidth = screenDimensions.width / designSize.width
        let scaleHeight = screenDimensions.height / designSize.height
        let scaleText = configuration.minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth

        let limits = configuration.scalingLimits

        let snapshot = ScaleFactors(
            width: limits.clamp(scaleWidth),
            height: limits.clamp(scaleHeight),
            text: limits.clamp(scaleText),
            screenWidth: screenDimensions.width,
            screenHeight: screenDimensions.height
        )
        factors.store(snapshot, ordering: .releasing)
    }

    private func preWarmCaches() {
        _ = dimensionsCache.getDimensions()
        safeAreaCache.preWarm()
    }

    @inline(__always)
    private func scaleFactor(for scaleType: ScaleType) -> CGFloat {
        let f = _factors
        switch scaleType {
        case .width:
            return f.width
        case .height:
            return f.height
        case .text, .font:
            return f.text
        case .radius, .min:
            return min(f.width, f.height)
        case .max:
            return max(f.width, f.height)
        case .auto:
            return f.width // Default to width scaling
        }
    }

    @inline(__always)
    public func scale(for value: CGFloat, scaleType: ScaleType) -> CGFloat {
        guard value.isFinite else {
            #if DEBUG
            print("⚠️ ScreenUtil: Invalid input value \(value) for scale type \(scaleType)")
            #endif
            return 0
        }
        return value * scaleFactor(for: scaleType)
    }

    @inline(__always)
    public func fastScale(for value: CGFloat, scaleType: ScaleType) -> CGFloat {
        return value * scaleFactor(for: scaleType)
    }

    public var screenWidth: CGFloat {
        return _factors.screenWidth
    }

    public var screenHeight: CGFloat {
        return _factors.screenHeight
    }

    public var safeAreaTop: CGFloat {
        return safeAreaCache.getSafeAreaInsets().top
    }

    public var safeAreaBottom: CGFloat {
        return safeAreaCache.getSafeAreaInsets().bottom
    }

    public var safeAreaLeft: CGFloat {
        return safeAreaCache.getSafeAreaInsets().left
    }

    public var safeAreaRight: CGFloat {
        return safeAreaCache.getSafeAreaInsets().right
    }

    public var statusBarHeight: CGFloat {
        return safeAreaCache.getSafeAreaInsets().statusBarHeight
    }

    public var scaleWidth: CGFloat {
        return _scaleWidth
    }

    public var scaleHeight: CGFloat {
        return _scaleHeight
    }

    public var scaleText: CGFloat {
        return _scaleText
    }

    public var deviceType: DeviceType {
        return configuration.deviceType
    }

    public func refreshMetrics() {
        updateScaleFactors()
    }

    public func getScreenMetrics() -> ScreenMetrics {
        let dimensions = dimensionsCache.getDimensions()
        let safeArea = safeAreaCache.getSafeAreaInsets()

        return ScreenMetrics(
            width: dimensions.width,
            height: dimensions.height,
            scale: dimensions.scale,
            safeAreaInsets: (safeArea.top, safeArea.bottom, safeArea.left, safeArea.right),
            statusBarHeight: safeArea.statusBarHeight
        )
    }
}

public extension ScreenUtil {
    @inline(__always)
    func w(_ value: CGFloat) -> CGFloat {
        return scale(for: value, scaleType: .width)
    }

    @inline(__always)
    func h(_ value: CGFloat) -> CGFloat {
        return scale(for: value, scaleType: .height)
    }

    @inline(__always)
    func sp(_ value: CGFloat) -> CGFloat {
        return scale(for: value, scaleType: .text)
    }

    @inline(__always)
    func r(_ value: CGFloat) -> CGFloat {
        return scale(for: value, scaleType: .radius)
    }

    @inline(__always)
    func sw(_ percentage: CGFloat) -> CGFloat {
        return screenWidth * (percentage / 100.0)
    }

    @inline(__always)
    func sh(_ percentage: CGFloat) -> CGFloat {
        return screenHeight * (percentage / 100.0)
    }

    @inline(__always)
    func fastW(_ value: CGFloat) -> CGFloat {
        return value * _scaleWidth
    }

    @inline(__always)
    func fastH(_ value: CGFloat) -> CGFloat {
        return value * _scaleHeight
    }

    @inline(__always)
    func fastSp(_ value: CGFloat) -> CGFloat {
        return value * _scaleText
    }
}

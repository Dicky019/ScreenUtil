//
//  ScreenUtil.swift
//  ScreenUtil
//
//  High-performance screen adaptation utility for iOS
//  Thread-safe singleton with lock-free reads
//

import Foundation
import CoreGraphics

public final class ScreenUtil: ScreenScalable, ScreenDimensionProvider, @unchecked Sendable {
    public static let shared = ScreenUtil()

    @Atomic private var configuration: ScreenUtilConfiguration
    private let dimensionsCache = ScreenDimensionsCache()
    private let safeAreaCache = SafeAreaCacheManager()

    internal private(set) var _scaleWidth: CGFloat = 1.0
    internal private(set) var _scaleHeight: CGFloat = 1.0
    internal private(set) var _scaleText: CGFloat = 1.0

    @UnsafeAtomicDouble private var _cachedScreenWidth: Double = 375.0
    @UnsafeAtomicDouble private var _cachedScreenHeight: Double = 812.0

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

        self._scaleWidth = limits.clamp(scaleWidth)
        self._scaleHeight = limits.clamp(scaleHeight)
        self._scaleText = limits.clamp(scaleText)

        self._cachedScreenWidth = Double(screenDimensions.width)
        self._cachedScreenHeight = Double(screenDimensions.height)
    }

    private func preWarmCaches() {
        _ = dimensionsCache.getDimensions()
        safeAreaCache.preWarm()
    }

    @inline(__always)
    private func scaleFactor(for scaleType: ScaleType) -> CGFloat {
        switch scaleType {
        case .width:
            return _scaleWidth
        case .height:
            return _scaleHeight
        case .text, .font:
            return _scaleText
        case .radius, .min:
            return min(_scaleWidth, _scaleHeight)
        case .max:
            return max(_scaleWidth, _scaleHeight)
        case .auto:
            return _scaleWidth // Default to width scaling
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
        return CGFloat(_cachedScreenWidth)
    }

    public var screenHeight: CGFloat {
        return CGFloat(_cachedScreenHeight)
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

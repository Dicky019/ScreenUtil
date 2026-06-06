//
//  ScreenUtil.swift
//  ScreenUtil
//
//  Thread-safe screen adaptation engine.
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics
import Atomics
#if canImport(UIKit)
import UIKit
#endif

/// Thread-safe screen-adaptation engine.
///
/// Configure once on the main actor at launch (`ScreenUtil.shared.configure(with:)`);
/// before that, all scaling returns identity (scale 1.0).
///
/// - Note: `Sendable` is compiler-verified: the only nonisolated state is `snapshot`
///   (a `ManagedAtomic<Snapshot>`, itself `Sendable`); `configuration` and `isObserving`
///   are isolated to the main actor.
public final class ScreenUtil: ScreenScalable, ScreenDimensionProvider, Sendable {
    public static let shared = ScreenUtil()

    private let snapshot = ManagedAtomic<Snapshot>(.default)
    @MainActor private var configuration = ScreenUtilConfiguration()
    @MainActor private var isObserving = false

    private init() {}

    /// One consistent, nonisolated snapshot read.
    internal var _snapshot: Snapshot { snapshot.load(ordering: .acquiring) }

    // MARK: Configuration (main actor)

    @MainActor
    public func configure(with config: ScreenUtilConfiguration) {
        guard config.isValidDesignSize() else {
            assertionFailure("Invalid design size: \(config.designSize)")
            return
        }
        configuration = config
        startObservingIfNeeded()
        rebuildSnapshot()
    }

    @MainActor
    public func refreshMetrics() {
        rebuildSnapshot()
    }

    @MainActor
    private func rebuildSnapshot() {
        let dims = ScreenDimensions.current
        let safe = SafeAreaInsets.current
        let device = DeviceType.current
        let design = configuration.designSize

        let sw = dims.width / design.width
        let sh = dims.height / design.height
        let st = configuration.minTextAdapt ? min(sw, sh) : sw
        let limits = configuration.scalingLimits

        snapshot.store(
            Snapshot(
                scaleWidth: limits.clamp(sw),
                scaleHeight: limits.clamp(sh),
                scaleText: limits.clamp(st),
                screenWidth: dims.width,
                screenHeight: dims.height,
                screenScale: dims.scale,
                safeArea: safe,
                deviceType: device
            ),
            ordering: .releasing
        )
    }

    @MainActor
    private func startObservingIfNeeded() {
        guard !isObserving else { return }
        isObserving = true
        #if canImport(UIKit)
        let center = NotificationCenter.default
        // queue: nil → delivered synchronously on the posting thread; hop to the
        // main actor explicitly via Task (do NOT use MainActor.assumeIsolated here:
        // an OperationQueue.main callback is not guaranteed to run on the MainActor
        // executor and assumeIsolated would crash).
        center.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [weak self] _ in
            Task { @MainActor in self?.rebuildSnapshot() }
        }
        center.addObserver(forName: UIScene.didActivateNotification, object: nil, queue: nil) { [weak self] _ in
            Task { @MainActor in self?.rebuildSnapshot() }
        }
        #endif
    }

    // MARK: Scaling (nonisolated)

    @inline(__always)
    private func scaleFactor(for scaleType: ScaleType) -> CGFloat {
        let s = _snapshot
        switch scaleType {
        case .width:  return s.scaleWidth
        case .height: return s.scaleHeight
        case .text:   return s.scaleText
        case .radius: return min(s.scaleWidth, s.scaleHeight)
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

    // MARK: Dimensions & factors (nonisolated)

    public var screenWidth: CGFloat { _snapshot.screenWidth }
    public var screenHeight: CGFloat { _snapshot.screenHeight }
    public var safeAreaTop: CGFloat { _snapshot.safeArea.top }
    public var safeAreaBottom: CGFloat { _snapshot.safeArea.bottom }
    public var safeAreaLeft: CGFloat { _snapshot.safeArea.left }
    public var safeAreaRight: CGFloat { _snapshot.safeArea.right }
    public var statusBarHeight: CGFloat { _snapshot.safeArea.statusBarHeight }
    public var scaleWidth: CGFloat { _snapshot.scaleWidth }
    public var scaleHeight: CGFloat { _snapshot.scaleHeight }
    public var scaleText: CGFloat { _snapshot.scaleText }
    public var deviceType: DeviceType { _snapshot.deviceType }

    public func getScreenMetrics() -> ScreenMetrics {
        let s = _snapshot
        return ScreenMetrics(
            width: s.screenWidth,
            height: s.screenHeight,
            scale: s.screenScale,
            safeAreaInsets: (s.safeArea.top, s.safeArea.bottom, s.safeArea.left, s.safeArea.right),
            statusBarHeight: s.safeArea.statusBarHeight
        )
    }
}

public extension ScreenUtil {
    @inline(__always) func w(_ value: CGFloat) -> CGFloat { scale(for: value, scaleType: .width) }
    @inline(__always) func h(_ value: CGFloat) -> CGFloat { scale(for: value, scaleType: .height) }
    @inline(__always) func sp(_ value: CGFloat) -> CGFloat { scale(for: value, scaleType: .text) }
    @inline(__always) func r(_ value: CGFloat) -> CGFloat { scale(for: value, scaleType: .radius) }
    @inline(__always) func sw(_ percentage: CGFloat) -> CGFloat { screenWidth * (percentage / 100.0) }
    @inline(__always) func sh(_ percentage: CGFloat) -> CGFloat { screenHeight * (percentage / 100.0) }
    @inline(__always) func fastW(_ value: CGFloat) -> CGFloat { value * _snapshot.scaleWidth }
    @inline(__always) func fastH(_ value: CGFloat) -> CGFloat { value * _snapshot.scaleHeight }
    @inline(__always) func fastSp(_ value: CGFloat) -> CGFloat { value * _snapshot.scaleText }
}

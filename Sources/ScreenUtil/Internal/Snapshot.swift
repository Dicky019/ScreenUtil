//
//  Snapshot.swift
//  ScreenUtil
//
//  Immutable, atomically-publishable snapshot of all nonisolated-readable state.
//  Created by Dicky Darmawan on 06/06/26.
//

import CoreGraphics
import Atomics

@usableFromInline
final class Snapshot: AtomicReference, Sendable {
    @usableFromInline let scaleWidth: CGFloat
    @usableFromInline let scaleHeight: CGFloat
    @usableFromInline let scaleText: CGFloat
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let screenScale: CGFloat
    // Native safe-area values, captured from the window at rebuild time (0 when unavailable).
    let safeAreaTop: CGFloat
    let safeAreaBottom: CGFloat
    let safeAreaLeft: CGFloat
    let safeAreaRight: CGFloat
    let statusBarHeight: CGFloat
    let deviceType: DeviceType

    init(
        scaleWidth: CGFloat,
        scaleHeight: CGFloat,
        scaleText: CGFloat,
        screenWidth: CGFloat,
        screenHeight: CGFloat,
        screenScale: CGFloat,
        safeAreaTop: CGFloat,
        safeAreaBottom: CGFloat,
        safeAreaLeft: CGFloat,
        safeAreaRight: CGFloat,
        statusBarHeight: CGFloat,
        deviceType: DeviceType
    ) {
        self.scaleWidth = scaleWidth
        self.scaleHeight = scaleHeight
        self.scaleText = scaleText
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.screenScale = screenScale
        self.safeAreaTop = safeAreaTop
        self.safeAreaBottom = safeAreaBottom
        self.safeAreaLeft = safeAreaLeft
        self.safeAreaRight = safeAreaRight
        self.statusBarHeight = statusBarHeight
        self.deviceType = deviceType
    }

    static let `default`: Snapshot = {
        let dims = ScreenDimensions.platformDefault
        return Snapshot(
            scaleWidth: 1, scaleHeight: 1, scaleText: 1,
            screenWidth: dims.width, screenHeight: dims.height, screenScale: dims.scale,
            safeAreaTop: 0, safeAreaBottom: 0, safeAreaLeft: 0, safeAreaRight: 0, statusBarHeight: 0,
            deviceType: .platformDefault
        )
    }()
}

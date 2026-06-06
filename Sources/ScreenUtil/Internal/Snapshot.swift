//
//  Snapshot.swift
//  ScreenUtil
//
//  Immutable, atomically-publishable snapshot of all nonisolated-readable state.
//  Created by Dicky Darmawan on 06/06/26.
//

import CoreGraphics
import Atomics

final class Snapshot: AtomicReference, Sendable {
    let scaleWidth: CGFloat
    let scaleHeight: CGFloat
    let scaleText: CGFloat
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let screenScale: CGFloat
    let safeArea: SafeAreaInsets
    let deviceType: DeviceType

    init(
        scaleWidth: CGFloat,
        scaleHeight: CGFloat,
        scaleText: CGFloat,
        screenWidth: CGFloat,
        screenHeight: CGFloat,
        screenScale: CGFloat,
        safeArea: SafeAreaInsets,
        deviceType: DeviceType
    ) {
        self.scaleWidth = scaleWidth
        self.scaleHeight = scaleHeight
        self.scaleText = scaleText
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.screenScale = screenScale
        self.safeArea = safeArea
        self.deviceType = deviceType
    }

    static let `default` = Snapshot(
        scaleWidth: 1, scaleHeight: 1, scaleText: 1,
        screenWidth: 375, screenHeight: 812, screenScale: 2,
        safeArea: .zero, deviceType: .platformDefault
    )
}

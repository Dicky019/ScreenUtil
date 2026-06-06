//
//  ScaleType.swift
//  ScreenUtil
//
//  Core protocols and scale types for ScreenUtil
//

import Foundation
import CoreGraphics

public protocol ScreenUtilConfigurable {
    var designSize: CGSize { get set }
    var minTextAdapt: Bool { get set }
    var splitScreenMode: Bool { get set }
    var scalingLimits: ScalingLimits { get set }
    var deviceType: DeviceType { get }
}

public protocol ScreenScalable {
    func scale(for value: CGFloat, scaleType: ScaleType) -> CGFloat
    func fastScale(for value: CGFloat, scaleType: ScaleType) -> CGFloat
}

public protocol ScreenDimensionProvider {
    var screenWidth: CGFloat { get }
    var screenHeight: CGFloat { get }
    var safeAreaTop: CGFloat { get }
    var safeAreaBottom: CGFloat { get }
    var statusBarHeight: CGFloat { get }
}

public enum ScaleType: Sendable {
    case width
    case height
    case text
    case font // Alias for text
    case radius
    case min
    case max
    case auto // Auto-detect based on context
}

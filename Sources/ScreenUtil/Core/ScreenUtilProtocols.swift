//
//  ScreenUtilProtocols.swift
//  ScreenUtil
//
//  Core protocols and types for ScreenUtil
//

import Foundation
import CoreGraphics
import UIKit

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
    case auto // Currently defaults to width scaling
}

public enum DeviceType {
    case iPhone
    case iPad
    case mac
    case tv
    case watch
    case unknown
    
    public static var current: DeviceType {
        #if os(iOS)
            #if canImport(UIKit)
            if UIDevice.current.userInterfaceIdiom == .pad {
                return .iPad
            } else {
                return .iPhone
            }
            #else
            return .iPhone // Default fallback for iOS without UIKit
            #endif
        #elseif os(macOS)
        return .mac
        #elseif os(tvOS)
        return .tv
        #elseif os(watchOS)
        return .watch
        #else
        return .unknown
        #endif
    }
}

public struct ScalingLimits: Sendable {
    public let minScale: CGFloat
    public let maxScale: CGFloat
    
    public init(minScale: CGFloat = 0.5, maxScale: CGFloat = 2.0) {
        self.minScale = max(0.1, minScale)
        self.maxScale = min(5.0, maxScale)
    }
    
    public func clamp(_ value: CGFloat) -> CGFloat {
        return min(maxScale, max(minScale, value))
    }
    
    public static let `default` = ScalingLimits()

    public static let strict = ScalingLimits(minScale: 0.8, maxScale: 1.25)

    public static let relaxed = ScalingLimits(minScale: 0.3, maxScale: 3.0)
}

public struct ScreenMetrics: Sendable {
    public let width: CGFloat
    public let height: CGFloat
    public let scale: CGFloat
    public let safeAreaInsets: (top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat)
    public let statusBarHeight: CGFloat
    
    public init(
        width: CGFloat,
        height: CGFloat,
        scale: CGFloat,
        safeAreaInsets: (top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat),
        statusBarHeight: CGFloat
    ) {
        self.width = width
        self.height = height
        self.scale = scale
        self.safeAreaInsets = safeAreaInsets
        self.statusBarHeight = statusBarHeight
    }
}

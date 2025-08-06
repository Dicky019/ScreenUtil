//
//  ScreenUtilConfiguration.swift
//  ScreenUtil
//
//  Configuration management for ScreenUtil
//

import Foundation
import CoreGraphics

public struct ScreenUtilConfiguration: ScreenUtilConfigurable, Sendable {
    public var designSize: CGSize
    public var minTextAdapt: Bool
    public var splitScreenMode: Bool
    public var scalingLimits: ScalingLimits
    
    public var deviceType: DeviceType {
        return DeviceType.current
    }
    
    public init(
        designSize: CGSize = CGSize(width: 375, height: 812),
        minTextAdapt: Bool = true,
        splitScreenMode: Bool = true,
        scalingLimits: ScalingLimits = .default
    ) {
        self.designSize = designSize
        self.minTextAdapt = minTextAdapt
        self.splitScreenMode = splitScreenMode
        self.scalingLimits = scalingLimits
    }
    
    public static let iPhone13Pro = ScreenUtilConfiguration(
        designSize: CGSize(width: 390, height: 844)
    )
    
    public static let iPhone14Pro = ScreenUtilConfiguration(
        designSize: CGSize(width: 393, height: 852)
    )
    
    public static let iPhone15Pro = ScreenUtilConfiguration(
        designSize: CGSize(width: 393, height: 852)
    )
    
    public static let iPhoneX = ScreenUtilConfiguration(
        designSize: CGSize(width: 375, height: 812)
    )
    
    public static let iPhone8 = ScreenUtilConfiguration(
        designSize: CGSize(width: 375, height: 667)
    )
    
    public static let iPadPro11 = ScreenUtilConfiguration(
        designSize: CGSize(width: 834, height: 1194),
        scalingLimits: .strict
    )
    
    public static let iPadPro12_9 = ScreenUtilConfiguration(
        designSize: CGSize(width: 1024, height: 1366),
        scalingLimits: .strict
    )
    
    public func isValidDesignSize() -> Bool {
        return designSize.width > 0 && designSize.height > 0 &&
               designSize.width <= 2000 && designSize.height <= 3000
    }
    
    public func aspectRatio() -> CGFloat {
        return designSize.width / designSize.height
    }
    
    public mutating func updateDesignSize(_ size: CGSize) {
        guard size.width > 0 && size.height > 0 else { return }
        self.designSize = size
    }
    
    public func shouldAdaptText(for fontSize: CGFloat) -> Bool {
        return minTextAdapt || fontSize >= 12.0
    }
}

public enum ConfigurationPreset {
    case iPhoneStandard
    case iPhoneCompact
    case iPadStandard
    case custom(ScreenUtilConfiguration)
    
    public var configuration: ScreenUtilConfiguration {
        switch self {
        case .iPhoneStandard:
            return .iPhone13Pro
        case .iPhoneCompact:
            return .iPhone8
        case .iPadStandard:
            return .iPadPro11
        case .custom(let config):
            return config
        }
    }
}
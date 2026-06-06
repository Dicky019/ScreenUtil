//
//  ScreenDimensions.swift
//  ScreenUtil
//
//  Platform screen dimensions snapshot
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics
#if canImport(UIKit)
import UIKit
#endif

public struct ScreenDimensions: Sendable {
    public let width: CGFloat
    public let height: CGFloat
    public let scale: CGFloat
    public let nativeWidth: CGFloat
    public let nativeHeight: CGFloat

    public init(width: CGFloat, height: CGFloat, scale: CGFloat) {
        self.width = width
        self.height = height
        self.scale = scale
        self.nativeWidth = width * scale
        self.nativeHeight = height * scale
    }

    #if canImport(UIKit) && !os(watchOS)
    @MainActor
    public static var current: ScreenDimensions {
        let screen = UIScreen.main
        let bounds = screen.bounds
        return ScreenDimensions(width: bounds.width, height: bounds.height, scale: screen.scale)
    }
    #else
    @MainActor
    public static var current: ScreenDimensions { platformDefault }
    #endif

    /// Nonisolated, compile-time default (safe to read off the main actor).
    public static var platformDefault: ScreenDimensions {
        #if os(iOS)
        return ScreenDimensions(width: 375, height: 812, scale: 3.0)
        #elseif os(macOS)
        return ScreenDimensions(width: 1440, height: 900, scale: 2.0)
        #elseif os(tvOS)
        return ScreenDimensions(width: 1920, height: 1080, scale: 1.0)
        #elseif os(watchOS)
        return ScreenDimensions(width: 184, height: 224, scale: 2.0)
        #else
        return ScreenDimensions(width: 375, height: 812, scale: 2.0)
        #endif
    }

    public var aspectRatio: CGFloat {
        return width / height
    }

    public var isLandscape: Bool {
        return width > height
    }

    public var isPortrait: Bool {
        return height > width
    }

    public var minDimension: CGFloat {
        return min(width, height)
    }

    public var maxDimension: CGFloat {
        return max(width, height)
    }
}

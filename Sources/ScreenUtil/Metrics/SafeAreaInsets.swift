//
//  SafeAreaInsets.swift
//  ScreenUtil
//
//  Platform safe-area insets snapshot
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics
#if canImport(UIKit)
import UIKit
#endif

/// A value-type snapshot of the device safe-area insets and status bar height.
public struct SafeAreaInsets: Sendable, Equatable, Hashable {
    /// Safe-area inset at the top of the screen in points.
    public let top: CGFloat
    /// Safe-area inset at the bottom of the screen in points.
    public let bottom: CGFloat
    /// Safe-area inset on the left side of the screen in points.
    public let left: CGFloat
    /// Safe-area inset on the right side of the screen in points.
    public let right: CGFloat
    /// Height of the status bar in points (0 when not applicable).
    public let statusBarHeight: CGFloat

    /// Creates a `SafeAreaInsets` with explicit inset values and an optional status bar height.
    public init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat, statusBarHeight: CGFloat = 0) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
        self.statusBarHeight = statusBarHeight
    }

    /// All-zero insets, useful as a safe default when no window is available.
    public static let zero = SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0)

    #if canImport(UIKit)
    @MainActor
    public static var current: SafeAreaInsets {
        guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene }).first,
              let window = scene.windows.first else {
            return defaultInsets
        }
        let safe = window.safeAreaInsets
        let statusBar = scene.statusBarManager?.statusBarFrame.height ?? 0
        return SafeAreaInsets(top: safe.top, bottom: safe.bottom, left: safe.left, right: safe.right, statusBarHeight: statusBar)
    }
    #else
    @MainActor
    public static var current: SafeAreaInsets { defaultInsets }
    #endif

    public static var defaultInsets: SafeAreaInsets {
        #if os(iOS)
        return SafeAreaInsets(top: 44, bottom: 34, left: 0, right: 0, statusBarHeight: 44)
        #elseif os(macOS)
        return SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0, statusBarHeight: 24)
        #elseif os(tvOS)
        return SafeAreaInsets(top: 60, bottom: 60, left: 90, right: 90, statusBarHeight: 0)
        #elseif os(watchOS)
        return SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0, statusBarHeight: 0)
        #else
        return SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0, statusBarHeight: 0)
        #endif
    }
}

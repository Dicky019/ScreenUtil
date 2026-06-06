//
//  ScreenMetrics.swift
//  ScreenUtil
//
//  Snapshot of current screen metrics
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

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

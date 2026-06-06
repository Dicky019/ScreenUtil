//
//  ScalingLimits.swift
//  ScreenUtil
//
//  Bounds applied to computed scale factors
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics

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

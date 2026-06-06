//
//  ScaleFactors.swift
//  ScreenUtil
//
//  Immutable, atomically-publishable snapshot of the scale factors
//  Created by Dicky Darmawan on 06/06/26.
//

import CoreGraphics
import Atomics

final class ScaleFactors: AtomicReference, Sendable {
    let width: CGFloat
    let height: CGFloat
    let text: CGFloat
    let screenWidth: CGFloat
    let screenHeight: CGFloat

    init(
        width: CGFloat,
        height: CGFloat,
        text: CGFloat,
        screenWidth: CGFloat,
        screenHeight: CGFloat
    ) {
        self.width = width
        self.height = height
        self.text = text
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }
}

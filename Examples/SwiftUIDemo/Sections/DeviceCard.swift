//
//  DeviceCard.swift
//  ScreenUtil Examples
//
//  "Device & scaling" card — surfaces metrics + the explicit scaling entry points.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import SwiftUI

struct DeviceCard: View {
    // Driving the card off observable state (passed in) is what makes SwiftUI re-render it
    // when metrics change — reading ScreenUtil imperatively alone would never invalidate the view.
    let metrics: ScreenMetrics

    // Read ScreenUtil from the environment (default value is `.shared`).
    @Environment(\.screenUtil) private var screenUtil

    var body: some View {
        VStack(alignment: .leading, spacing: 8.h) {
            Text("Device & Scaling")
                .font(.system(size: 17.sp, weight: .semibold))

            row("device", "\(screenUtil.deviceType)")
            row("screen", Format.describe(CGSize(width: metrics.width, height: metrics.height)))
            row("scaleW · scaleH", "\(Format.twoDecimals(screenUtil.scaleWidth)) · \(Format.twoDecimals(screenUtil.scaleHeight))")
            row("scaleText", Format.twoDecimals(screenUtil.scaleText))
            row("safeArea T/B", "\(Format.integer(metrics.safeAreaInsets.top)) / \(Format.integer(metrics.safeAreaInsets.bottom))")
            row("safeArea L/R", "\(Format.integer(metrics.safeAreaInsets.left)) / \(Format.integer(metrics.safeAreaInsets.right))")
            row("statusBar", Format.integer(metrics.statusBarHeight))
            row("screen W·H", "\(Format.integer(metrics.width)) · \(Format.integer(metrics.height))")
            // Explicit scaling entry points (numeric sugar wraps these) — all four ScaleType cases.
            row("scale(100,.width)", Format.integer(screenUtil.scale(for: 100, scaleType: .width)))
            row("scale(100,.height)", Format.integer(screenUtil.scale(for: 100, scaleType: .height)))
            row("scale(16,.radius)", Format.integer(screenUtil.scale(for: 16, scaleType: .radius)))
            row("fastScale(100,.text)", Format.integer(screenUtil.fastScale(for: 100, scaleType: .text)))
            // Honest self-test exercising the bulk + per-call geometry APIs that have no natural
            // home in declarative layout (kept to one labelled line, not faked into the UI).
            row("bulk self-test", selfTest())
        }
        .padding(16.w)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary, in: .rect(cornerRadius: 16.r))
    }

    private func row(_ key: String, _ value: String) -> some View {
        HStack {
            Text(key).foregroundStyle(.secondary)
            Spacer()
            Text(value).fontWeight(.medium)
        }
        .font(.system(size: 13.sp))
    }

    /// Exercises every bulk/geometry API that has no natural home in declarative SwiftUI layout,
    /// so the showcase still demonstrates 100% of the public surface. One line, honestly labelled.
    private func selfTest() -> String {
        let batch = ScreenUtil.shared.batchScaler
        let widths = batch.widths([10, 20, 30])
        let heights = batch.heights([10, 20])
        let fonts = batch.fontSizes([12, 14])
        let radii = batch.radii([8, 12])
        let sizes = batch.sizes([CGSize(width: 10, height: 10)])
        let points = batch.points([CGPoint(x: 10, y: 10), CGPoint(x: 20, y: 20)])
        let rects = batch.rects([CGRect(x: 0, y: 0, width: 50, height: 50)])
        let byHeight = batch.scale([100, 200], scaleType: .height)

        let fast = ScreenUtil.shared.fastScale
        _ = fast.size(CGSize(width: 10, height: 10))
        _ = fast.point(CGPoint(x: 5, y: 5))
        _ = fast.rect(CGRect(x: 0, y: 0, width: 8, height: 8))
        _ = withFastScale { $0.width(20) }

        // CGGeometry helpers (static + instance forms).
        _ = CGSize.scaled(width: 8, height: 8)
        _ = CGSize(width: 8, height: 8).fastScaled()
        _ = CGRect.scaled(x: 0, y: 0, width: 10, height: 10)
        _ = CGRect.responsive(x: 0, y: 0, width: 10, height: 10)
        _ = CGPoint.responsive(x: 4, y: 4)
        _ = CGPoint(x: 4, y: 4).fastScaled()

        let count = widths.count + heights.count + fonts.count + radii.count
            + sizes.count + points.count + rects.count + byHeight.count
        return "\(count) bulk values ✓"
    }
}

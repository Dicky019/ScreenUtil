//
//  DeviceMetricsRows.swift
//  ScreenUtil Examples
//
//  Single source of truth for the "Device & Scaling" rows, so the SwiftUI and UIKit
//  cards render identical data. Snapshot fields come from the passed `metrics` (which
//  SwiftUI observes, driving re-render); scale factors come from `screenUtil`.
//  Created by Dicky Darmawan on 27/06/26.
//

import CoreGraphics
import ScreenUtil

/// One label/value line in the Device card.
struct MetricRow: Identifiable {
    let label: String
    let value: String
    var id: String { label }
}

enum DeviceMetricsRows {
    /// The rows describing the current device + scaling state.
    static func make(metrics: ScreenMetrics, scaling screenUtil: ScreenUtil) -> [MetricRow] {
        [
            MetricRow(label: "device", value: "\(screenUtil.deviceType)"),
            MetricRow(label: "screen", value: CGSize(width: metrics.width, height: metrics.height).dimensionsText),
            MetricRow(label: "scaleW · scaleH", value: "\(screenUtil.scaleWidth.twoDecimalText) · \(screenUtil.scaleHeight.twoDecimalText)"),
            MetricRow(label: "scaleText", value: screenUtil.scaleText.twoDecimalText),
            MetricRow(label: "safeArea T/B", value: "\(metrics.safeAreaInsets.top.integerText) / \(metrics.safeAreaInsets.bottom.integerText)"),
            MetricRow(label: "safeArea L/R", value: "\(metrics.safeAreaInsets.left.integerText) / \(metrics.safeAreaInsets.right.integerText)"),
            MetricRow(label: "statusBar", value: metrics.statusBarHeight.integerText),
            MetricRow(label: "screen W·H", value: "\(metrics.width.integerText) · \(metrics.height.integerText)"),
            // All four ScaleType cases via the explicit entry points.
            MetricRow(label: "scale(100,.width)", value: screenUtil.scale(for: 100, scaleType: .width).integerText),
            MetricRow(label: "scale(100,.height)", value: screenUtil.scale(for: 100, scaleType: .height).integerText),
            MetricRow(label: "scale(16,.radius)", value: screenUtil.scale(for: 16, scaleType: .radius).integerText),
            MetricRow(label: "fastScale(100,.text)", value: screenUtil.fastScale(for: 100, scaleType: .text).integerText),
        ]
    }
}

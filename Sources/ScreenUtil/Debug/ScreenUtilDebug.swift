//
//  ScreenUtilDebug.swift
//  ScreenUtil
//
//  Debug and development utilities
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics
#if canImport(UIKit)
import UIKit
#endif

/// Debug and development utilities for inspecting ScreenUtil's active configuration and scaling behaviour.
public enum ScreenUtilDebug {
    /// Logs the current screen metrics and scale factors via `os.Logger`.
    public static func printCurrentConfiguration() {
        let screenUtil = ScreenUtil.shared
        let metrics = screenUtil.getScreenMetrics()

        let message = """
        ScreenUtil Debug Info
        Screen Dimensions: \(metrics.width) x \(metrics.height) pts
        Scale Factor: \(metrics.scale)x
        Safe Area: T:\(metrics.safeAreaInsets.0) B:\(metrics.safeAreaInsets.1) L:\(metrics.safeAreaInsets.2) R:\(metrics.safeAreaInsets.3)
        Status Bar Height: \(metrics.statusBarHeight) pts
        Width Scale: \(screenUtil.scaleWidth)
        Height Scale: \(screenUtil.scaleHeight)
        Text Scale: \(screenUtil.scaleText)
        Device Type: \(screenUtil.deviceType)
        """
        Log(.debug, message)
    }

    #if DEBUG
    /// Runs `operation` `iterations` times and returns the last result alongside the average execution time.
    public static func measurePerformance<T>(_ operation: () -> T, iterations: Int = 10000) -> (result: T, averageTime: TimeInterval) {
        precondition(iterations > 0, "iterations must be > 0")
        var totalTime: TimeInterval = 0
        var result: T!

        for _ in 0..<iterations {
            let startTime = CFAbsoluteTimeGetCurrent()
            result = operation()
            let endTime = CFAbsoluteTimeGetCurrent()
            totalTime += (endTime - startTime)
        }

        let averageTime = totalTime / Double(iterations)
        return (result, averageTime)
    }

    /// Benchmarks standard, FastScale, and batch scaling paths and logs the results.
    public static func benchmarkScalingOperations() {
        let testValue: CGFloat = 100.0
        let iterations = 100000

        Log(.benchmark, "ScreenUtil Performance Benchmark — \(iterations) iterations")

        let standardW = measurePerformance({
            testValue.w
        }, iterations: iterations)

        let fastW = measurePerformance({
            withFastScale { $0.width(testValue) }
        }, iterations: iterations)

        let batchOperation = measurePerformance({
            withBatchScaler { $0.widths([10, 20, 30, 40, 50]) }
        }, iterations: iterations / 10)

        Log(.benchmark, "Standard .w: \(String(format: "%.2f", standardW.averageTime * 1_000_000)) μs")
        Log(.benchmark, "FastScale .width: \(String(format: "%.2f", fastW.averageTime * 1_000_000)) μs")
        Log(.benchmark, "Batch operation: \(String(format: "%.2f", batchOperation.averageTime * 1_000_000)) μs")

        let speedup = standardW.averageTime / fastW.averageTime
        Log(.benchmark, "FastScale path is \(String(format: "%.1f", speedup))x faster")
    }
    #endif

    #if canImport(UIKit) && DEBUG
    /// Adds a semi-transparent overlay showing current screen metrics and scale factors to `view`.
    @MainActor public static func showDebugOverlay(on view: UIView) {
        let overlayView = createDebugOverlay()
        view.addSubview(overlayView)

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.w),
            overlayView.widthAnchor.constraint(equalToConstant: 200.w),
            overlayView.heightAnchor.constraint(equalToConstant: 150.h)
        ])
    }

    @MainActor private static func createDebugOverlay() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        containerView.layer.cornerRadius = 8.r

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.h
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let screenUtil = ScreenUtil.shared
        let metrics = screenUtil.getScreenMetrics()

        let labels = [
            "Screen: \(Int(metrics.width))x\(Int(metrics.height))",
            "Scale: \(metrics.scale)x",
            "W: \(String(format: "%.2f", screenUtil.scaleWidth))",
            "H: \(String(format: "%.2f", screenUtil.scaleHeight))",
            "T: \(String(format: "%.2f", screenUtil.scaleText))"
        ]

        for text in labels {
            let label = UILabel()
            label.text = text
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 10.sp)
            stackView.addArrangedSubview(label)
        }

        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.h),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.w),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.w),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.h)
        ])

        return containerView
    }
    #endif
}

//
//  DebugSupport.swift
//  ScreenUtil
//
//  Debug and development utilities
//

import Foundation
import CoreGraphics
import UIKit

public struct ScreenUtilDebug: Sendable {
    public static let shared = ScreenUtilDebug()
    
    private init() {}
    
    public func printCurrentConfiguration() {
        let screenUtil = ScreenUtil.shared
        let metrics = screenUtil.getScreenMetrics()
        
        print("""
        ╔══════════════════════════════════════════════════════════╗
        ║                    ScreenUtil Debug Info                 ║
        ╠══════════════════════════════════════════════════════════╣
        ║ Screen Dimensions: \(metrics.width) x \(metrics.height) pts          ║
        ║ Scale Factor: \(metrics.scale)x                              ║
        ║ Safe Area: T:\(metrics.safeAreaInsets.0) B:\(metrics.safeAreaInsets.1) L:\(metrics.safeAreaInsets.2) R:\(metrics.safeAreaInsets.3)     ║
        ║ Status Bar Height: \(metrics.statusBarHeight) pts                 ║
        ║                                                          ║
        ║ Scale Factors:                                           ║
        ║   Width Scale: \(screenUtil.scaleWidth)                        ║
        ║   Height Scale: \(screenUtil.scaleHeight)                       ║
        ║   Text Scale: \(screenUtil.scaleText)                         ║
        ║                                                          ║
        ║ Device Type: \(screenUtil.deviceType)                           ║
        ╚══════════════════════════════════════════════════════════╝
        """)
    }
    
    public func measurePerformance<T>(_ operation: () -> T, iterations: Int = 10000) -> (result: T, averageTime: TimeInterval) {
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
    
    public func benchmarkScalingOperations() {
        let testValue: CGFloat = 100.0
        let iterations = 100000
        
        print("\n🚀 ScreenUtil Performance Benchmark")
        print("Testing \(iterations) iterations...\n")
        
        let standardW = measurePerformance({
            testValue.w
        }, iterations: iterations)
        
        let fastW = measurePerformance({
            testValue.fastW
        }, iterations: iterations)
        
        let batchOperation = measurePerformance({
            ScreenUtil.shared.batchWidths([10, 20, 30, 40, 50])
        }, iterations: iterations / 10)
        
        print("📊 Results:")
        print("  Standard .w: \(String(format: "%.2f", standardW.averageTime * 1_000_000)) μs")
        print("  Fast .fastW: \(String(format: "%.2f", fastW.averageTime * 1_000_000)) μs")
        print("  Batch operation: \(String(format: "%.2f", batchOperation.averageTime * 1_000_000)) μs")
        
        let speedup = standardW.averageTime / fastW.averageTime
        print("\n⚡ Fast path is \(String(format: "%.1f", speedup))x faster")
    }
    
    public func validateScaling() -> Bool {
        let screenUtil = ScreenUtil.shared
        var allValid = true
        
        let testCases: [(input: CGFloat, expected: String)] = [
            (100, "Width scaling"),
            (50, "Height scaling"),
            (16, "Font scaling"),
            (12, "Radius scaling")
        ]
        
        print("\n✅ Validation Tests:")
        
        for testCase in testCases {
            let widthResult = screenUtil.w(testCase.input)
            let heightResult = screenUtil.h(testCase.input)
            let textResult = screenUtil.sp(testCase.input)
            let radiusResult = screenUtil.r(testCase.input)
            
            let isValid = widthResult > 0 && heightResult > 0 && textResult > 0 && radiusResult > 0
            if !isValid {
                allValid = false
                print("  ❌ \(testCase.expected) failed for input \(testCase.input)")
            } else {
                print("  ✅ \(testCase.expected) passed")
            }
        }
        
        return allValid
    }
    
    public func generateTestReport() -> String {
        let screenUtil = ScreenUtil.shared
        let metrics = screenUtil.getScreenMetrics()
        let timestamp = Date()
        
        return """
        # ScreenUtil Test Report
        
        **Generated:** \(timestamp)
        
        ## Device Information
        - Screen Size: \(metrics.width) x \(metrics.height) pts
        - Scale Factor: \(metrics.scale)x
        - Device Type: \(screenUtil.deviceType)
        
        ## Scaling Factors
        - Width Scale: \(screenUtil.scaleWidth)
        - Height Scale: \(screenUtil.scaleHeight)
        - Text Scale: \(screenUtil.scaleText)
        
        ## Safe Area
        - Top: \(metrics.safeAreaInsets.0) pts
        - Bottom: \(metrics.safeAreaInsets.1) pts
        - Left: \(metrics.safeAreaInsets.2) pts
        - Right: \(metrics.safeAreaInsets.3) pts
        
        ## Status Bar
        - Height: \(metrics.statusBarHeight) pts
        
        ## Test Values
        | Input | Width (.w) | Height (.h) | Font (.sp) | Radius (.r) |
        |-------|------------|-------------|------------|--------------|
        | 10    | \(screenUtil.w(10))     | \(screenUtil.h(10))      | \(screenUtil.sp(10))     | \(screenUtil.r(10))       |
        | 20    | \(screenUtil.w(20))     | \(screenUtil.h(20))      | \(screenUtil.sp(20))     | \(screenUtil.r(20))       |
        | 50    | \(screenUtil.w(50))     | \(screenUtil.h(50))      | \(screenUtil.sp(50))     | \(screenUtil.r(50))       |
        | 100   | \(screenUtil.w(100))    | \(screenUtil.h(100))     | \(screenUtil.sp(100))    | \(screenUtil.r(100))      |
        
        ---
        Generated by ScreenUtil Debug
        """
    }
    
    #if canImport(UIKit) && DEBUG
    public func showDebugOverlay(on view: UIView) {
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
    
    private func createDebugOverlay() -> UIView {
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

public extension ScreenUtil {
    var debug: ScreenUtilDebug {
        return ScreenUtilDebug.shared
    }
}

#if DEBUG
public func printScreenUtilInfo() {
    ScreenUtilDebug.shared.printCurrentConfiguration()
}

public func benchmarkScreenUtil() {
    ScreenUtilDebug.shared.benchmarkScalingOperations()
}
#endif

//
//  PerformanceTests.swift
//  ScreenUtilTests
//
//  Performance and benchmark tests
//  Created by Dicky Darmawan on 06/06/26.
//

import XCTest
@testable import ScreenUtil

final class PerformanceTests: XCTestCase {
    var screenUtil: ScreenUtil!
    
    override func setUp() {
        super.setUp()
        screenUtil = ScreenUtil.shared
    }
    
    func testStandardScalingPerformance() {
        let testValue: CGFloat = 100.0
        
        measure {
            for _ in 0..<10000 {
                _ = testValue.w
            }
        }
    }
    
    func testBatchOperationsPerformance() {
        let testValues = Array(1...100).map { CGFloat($0) }
        
        measure {
            for _ in 0..<100 {
                _ = screenUtil.batchScaler.widths(testValues)
            }
        }
    }
    
    func testConcurrentAccessPerformance() {
        let testValue: CGFloat = 50.0
        
        measure {
            DispatchQueue.concurrentPerform(iterations: 1000) { _ in
                _ = testValue.w
                _ = testValue.h
                _ = testValue.sp
            }
        }
    }
    
    @MainActor
    func testConfigurationChangePerformance() {
        let configs = [
            ScreenUtilConfiguration(designSize: CGSize(width: 375, height: 812)),
            ScreenUtilConfiguration(designSize: CGSize(width: 390, height: 844)),
            ScreenUtilConfiguration(designSize: CGSize(width: 414, height: 896))
        ]

        measure {
            for config in configs {
                screenUtil.configure(with: config)
                _ = 100.0.w
                _ = 50.0.h
                _ = 16.0.sp
            }
        }
    }
    
    func testMemoryUsage() {
        let testValues = Array(1...1000).map { CGFloat($0) }
        
        measure {
            autoreleasepool {
                for value in testValues {
                    _ = value.w
                    _ = value.h
                    _ = value.sp
                    _ = value.r
                }
            }
        }
    }
    
    func testSafeAreaCachePerformance() {
        measure {
            for _ in 0..<1000 {
                _ = screenUtil.safeAreaTop
                _ = screenUtil.safeAreaBottom
                _ = screenUtil.statusBarHeight
            }
        }
    }
    
    func testScreenDimensionsCachePerformance() {
        measure {
            for _ in 0..<1000 {
                _ = screenUtil.screenWidth
                _ = screenUtil.screenHeight
            }
        }
    }
    
    func testFastScaleStructPerformance() {
        let fastScale = screenUtil.fastScale
        let testValue: CGFloat = 100.0
        
        measure {
            for _ in 0..<10000 {
                _ = fastScale.width(testValue)
                _ = fastScale.height(testValue)
                _ = fastScale.text(testValue)
            }
        }
    }
    
    func testBatchScalerPerformance() {
        let batchScaler = screenUtil.batchScaler
        let testValues = Array(1...50).map { CGFloat($0) }
        
        measure {
            for _ in 0..<100 {
                _ = batchScaler.widths(testValues)
                _ = batchScaler.heights(testValues)
                _ = batchScaler.fontSizes(testValues)
            }
        }
    }
    
    private func measureTime(_ block: () -> Void) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let endTime = CFAbsoluteTimeGetCurrent()
        return endTime - startTime
    }
}
//
//  ScreenUtilTests.swift
//  ScreenUtilTests
//
//  Core ScreenUtil functionality tests
//

import XCTest
@testable import ScreenUtil

final class ScreenUtilTests: XCTestCase {
    var screenUtil: ScreenUtil!
    
    @MainActor
    override func setUp() {
        super.setUp()
        screenUtil = ScreenUtil.shared
        
        let testConfig = ScreenUtilConfiguration(
            designSize: CGSize(width: 375, height: 812),
            minTextAdapt: true,
            splitScreenMode: true,
            scalingLimits: ScalingLimits()
        )
        screenUtil.configure(with: testConfig)
    }
    
    override func tearDown() {
        screenUtil = nil
        super.tearDown()
    }
    
    @MainActor
    func testSingletonInstance() {
        let instance1 = ScreenUtil.shared
        let instance2 = ScreenUtil.shared
        XCTAssertTrue(instance1 === instance2, "ScreenUtil should be a singleton")
    }
    
     @MainActor
    func testConfiguration() {
        let config = ScreenUtilConfiguration(
            designSize: CGSize(width: 390, height: 844),
            minTextAdapt: false,
            splitScreenMode: false,
            scalingLimits: ScalingLimits(minScale: 0.8, maxScale: 1.5)
        )
        
        screenUtil.configure(with: config)
        
        XCTAssertTrue(screenUtil.scaleWidth > 0, "Width scale should be positive")
        XCTAssertTrue(screenUtil.scaleHeight > 0, "Height scale should be positive")
        XCTAssertTrue(screenUtil.scaleText > 0, "Text scale should be positive")
    }
    
    func testScalingOperations() {
        let testValue: CGFloat = 100.0
        
        let widthResult = screenUtil.w(testValue)
        let heightResult = screenUtil.h(testValue)
        let textResult = screenUtil.sp(testValue)
        let radiusResult = screenUtil.r(testValue)
        
        XCTAssertTrue(widthResult > 0, "Width scaling should return positive value")
        XCTAssertTrue(heightResult > 0, "Height scaling should return positive value")
        XCTAssertTrue(textResult > 0, "Text scaling should return positive value")
        XCTAssertTrue(radiusResult > 0, "Radius scaling should return positive value")
        
        XCTAssertEqual(widthResult, testValue * screenUtil.scaleWidth, accuracy: 0.01)
        XCTAssertEqual(heightResult, testValue * screenUtil.scaleHeight, accuracy: 0.01)
        XCTAssertEqual(textResult, testValue * screenUtil.scaleText, accuracy: 0.01)
    }
    
    func testFastScalingOperations() {
        let testValue: CGFloat = 50.0
        
        let fastWidthResult = screenUtil.fastW(testValue)
        let fastHeightResult = screenUtil.fastH(testValue)
        let fastTextResult = screenUtil.fastSp(testValue)
        
        let normalWidthResult = screenUtil.w(testValue)
        let normalHeightResult = screenUtil.h(testValue)
        let normalTextResult = screenUtil.sp(testValue)
        
        XCTAssertEqual(fastWidthResult, normalWidthResult, accuracy: 0.01)
        XCTAssertEqual(fastHeightResult, normalHeightResult, accuracy: 0.01)
        XCTAssertEqual(fastTextResult, normalTextResult, accuracy: 0.01)
    }
    
    func testScreenPercentages() {
        let screenWidth = screenUtil.screenWidth
        let screenHeight = screenUtil.screenHeight
        
        XCTAssertEqual(screenUtil.sw(50), screenWidth * 0.5, accuracy: 0.01)
        XCTAssertEqual(screenUtil.sh(25), screenHeight * 0.25, accuracy: 0.01)
        XCTAssertEqual(screenUtil.sw(100), screenWidth, accuracy: 0.01)
        XCTAssertEqual(screenUtil.sh(100), screenHeight, accuracy: 0.01)
    }
    
    @MainActor
    func testNumericExtensions() {
        let intValue = 10
        let floatValue: Float = 20.0
        let doubleValue: Double = 30.0
        let cgFloatValue: CGFloat = 40.0
        
        XCTAssertTrue(intValue.w > 0)
        XCTAssertTrue(floatValue.h > 0)
        XCTAssertTrue(doubleValue.sp > 0)
        XCTAssertTrue(cgFloatValue.r > 0)
        
        XCTAssertEqual(intValue.w, CGFloat(intValue) * screenUtil.scaleWidth, accuracy: 0.01)
        XCTAssertEqual(floatValue.h, CGFloat(floatValue) * screenUtil.scaleHeight, accuracy: 0.01)
        XCTAssertEqual(doubleValue.sp, CGFloat(doubleValue) * screenUtil.scaleText, accuracy: 0.01)
    }
    
    @MainActor
    func testScaleLimits() {
        let extremeConfig = ScreenUtilConfiguration(
            designSize: CGSize(width: 1000, height: 2000),
            scalingLimits: ScalingLimits(minScale: 0.5, maxScale: 2.0)
        )
        
        screenUtil.configure(with: extremeConfig)
        
        XCTAssertGreaterThanOrEqual(screenUtil.scaleWidth, 0.5)
        XCTAssertLessThanOrEqual(screenUtil.scaleWidth, 2.0)
        XCTAssertGreaterThanOrEqual(screenUtil.scaleHeight, 0.5)
        XCTAssertLessThanOrEqual(screenUtil.scaleHeight, 2.0)
    }
    
    func testInvalidInputHandling() {
        let infiniteResult = screenUtil.w(CGFloat.infinity)
        let nanResult = screenUtil.w(CGFloat.nan)
        let negativeResult = screenUtil.w(-100)
        
        XCTAssertEqual(infiniteResult, 0, "Infinite values should return 0")
        XCTAssertEqual(nanResult, 0, "NaN values should return 0")
        XCTAssertTrue(negativeResult < 0, "Negative values should remain negative but scaled")
    }
    
    func testThreadSafety() {
        let expectation = XCTestExpectation(description: "Thread safety test")
        let iterations = 1000
        let concurrentQueue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)
        var completedTasks = 0
        
        for i in 0..<iterations {
            concurrentQueue.async {
                let testValue = CGFloat(i % 100 + 1)
                let result = self.screenUtil.w(testValue)
                XCTAssertTrue(result > 0, "Result should be positive")
                
                DispatchQueue.main.async {
                    completedTasks += 1
                    if completedTasks == iterations {
                        expectation.fulfill()
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testBatchOperations() {
        let testValues = [10, 20, 30, 40, 50]
        
        let batchWidths = screenUtil.batchWidths(testValues)
        let batchHeights = screenUtil.batchHeights(testValues)
        let batchFontSizes = screenUtil.batchFontSizes(testValues)
        
        XCTAssertEqual(batchWidths.count, testValues.count)
        XCTAssertEqual(batchHeights.count, testValues.count)
        XCTAssertEqual(batchFontSizes.count, testValues.count)
        
        for (index, value) in testValues.enumerated() {
            let expectedWidth = screenUtil.w(CGFloat(value))
            let expectedHeight = screenUtil.h(CGFloat(value))
            let expectedFontSize = screenUtil.sp(CGFloat(value))
            
            XCTAssertEqual(batchWidths[index], expectedWidth, accuracy: 0.01)
            XCTAssertEqual(batchHeights[index], expectedHeight, accuracy: 0.01)
            XCTAssertEqual(batchFontSizes[index], expectedFontSize, accuracy: 0.01)
        }
    }
    
    func testSafeAreaAccess() {
        let safeAreaTop = screenUtil.safeAreaTop
        let safeAreaBottom = screenUtil.safeAreaBottom
        let safeAreaLeft = screenUtil.safeAreaLeft
        let safeAreaRight = screenUtil.safeAreaRight
        let statusBarHeight = screenUtil.statusBarHeight
        
        XCTAssertGreaterThanOrEqual(safeAreaTop, 0)
        XCTAssertGreaterThanOrEqual(safeAreaBottom, 0)
        XCTAssertGreaterThanOrEqual(safeAreaLeft, 0)
        XCTAssertGreaterThanOrEqual(safeAreaRight, 0)
        XCTAssertGreaterThanOrEqual(statusBarHeight, 0)
    }
    
    func testDeviceTypeDetection() {
        let deviceType = screenUtil.deviceType
        XCTAssertNotEqual(deviceType, .unknown, "Device type should be detected")
        
        switch deviceType {
        case .iPhone, .iPad, .mac, .tv, .watch:
            break // Valid device types
        case .unknown:
            XCTFail("Device type should not be unknown")
        }
    }
    
    func testScreenMetrics() {
        let metrics = screenUtil.getScreenMetrics()
        
        XCTAssertTrue(metrics.width > 0, "Screen width should be positive")
        XCTAssertTrue(metrics.height > 0, "Screen height should be positive")
        XCTAssertTrue(metrics.scale > 0, "Screen scale should be positive")
        XCTAssertGreaterThanOrEqual(metrics.safeAreaInsets.0, 0, "Safe area top should be non-negative")
        XCTAssertGreaterThanOrEqual(metrics.safeAreaInsets.1, 0, "Safe area bottom should be non-negative")
        XCTAssertGreaterThanOrEqual(metrics.statusBarHeight, 0, "Status bar height should be non-negative")
    }
    
    func testRefreshMetrics() {
        let initialWidthScale = screenUtil.scaleWidth
        screenUtil.refreshMetrics()
        let refreshedWidthScale = screenUtil.scaleWidth
        
        XCTAssertEqual(initialWidthScale, refreshedWidthScale, accuracy: 0.01, "Scale factors should remain consistent after refresh")
    }
}
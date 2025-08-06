//
//  ScreenDimensions.swift
//  ScreenUtil
//
//  Cached screen dimensions for optimal performance
//

import Foundation
import CoreGraphics
import UIKit
import QuartzCore

public struct ScreenDimensions: Sendable {
    public let width: CGFloat
    public let height: CGFloat
    public let scale: CGFloat
    public let nativeWidth: CGFloat
    public let nativeHeight: CGFloat
    
    public init(width: CGFloat, height: CGFloat, scale: CGFloat) {
        self.width = width
        self.height = height
        self.scale = scale
        self.nativeWidth = width * scale
        self.nativeHeight = height * scale
    }
    
    #if canImport(UIKit)
    public static var current: ScreenDimensions {
        let screen = UIScreen.main
        let bounds = screen.bounds
        return ScreenDimensions(
            width: bounds.width,
            height: bounds.height,
            scale: screen.scale
        )
    }
    #else
    public static var current: ScreenDimensions {
        return platformDefaultDimensions
    }
    #endif
    
    private static var platformDefaultDimensions: ScreenDimensions {
        #if os(iOS)
        return ScreenDimensions(width: 375, height: 812, scale: 3.0) // iPhone 13 Pro
        #elseif os(macOS)
        return ScreenDimensions(width: 1440, height: 900, scale: 2.0) // MacBook Air
        #elseif os(tvOS)
        return ScreenDimensions(width: 1920, height: 1080, scale: 1.0) // Apple TV
        #elseif os(watchOS)
        return ScreenDimensions(width: 184, height: 224, scale: 2.0) // Apple Watch Series 7 41mm
        #else
        return ScreenDimensions(width: 375, height: 812, scale: 2.0) // Default fallback
        #endif
    }
    
    public var aspectRatio: CGFloat {
        return width / height
    }
    
    public var isLandscape: Bool {
        return width > height
    }
    
    public var isPortrait: Bool {
        return height > width
    }
    
    public var minDimension: CGFloat {
        return min(width, height)
    }
    
    public var maxDimension: CGFloat {
        return max(width, height)
    }
}

internal final class ScreenDimensionsCache {
    private var cachedDimensions: ScreenDimensions?
    private var lastUpdateTime: CFTimeInterval = 0
    private let cacheValidityDuration: CFTimeInterval = 30.0 // 30 seconds - screen dimensions rarely change
    private let lock = os_unfair_lock_t.allocate(capacity: 1)
    
    init() {
        lock.initialize(to: os_unfair_lock())
        setupNotificationObservers()
    }
    
    deinit {
        lock.deinitialize(count: 1)
        lock.deallocate()
    }
    
    func getDimensions() -> ScreenDimensions {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        
        let currentTime = CACurrentMediaTime()
        
        if let cached = cachedDimensions,
           currentTime - lastUpdateTime < cacheValidityDuration {
            return cached
        }
        
        let dimensions = ScreenDimensions.current
        cachedDimensions = dimensions
        lastUpdateTime = currentTime
        
        return dimensions
    }
    
    private func setupNotificationObservers() {
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.invalidateCache()
        }
        #endif
        // For other platforms, cache invalidation can be triggered manually via refreshMetrics()
    }
    
    private func invalidateCache() {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        cachedDimensions = nil
        lastUpdateTime = 0
    }
}

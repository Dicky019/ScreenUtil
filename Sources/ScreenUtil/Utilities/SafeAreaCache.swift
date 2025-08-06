//
//  SafeAreaCache.swift
//  ScreenUtil
//
//  High-performance safe area caching with TTL
//

import Foundation
import CoreGraphics
import UIKit
import QuartzCore

public struct SafeAreaInsets: Sendable {
    public let top: CGFloat
    public let bottom: CGFloat
    public let left: CGFloat
    public let right: CGFloat
    public let statusBarHeight: CGFloat
    
    public init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat, statusBarHeight: CGFloat = 0) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
        self.statusBarHeight = statusBarHeight
    }
    
    public static let zero = SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0)
    
    #if canImport(UIKit)
    public static var current: SafeAreaInsets {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let window = windowScene.windows.first else {
            return defaultInsets
        }
        
        let safeArea = window.safeAreaInsets
        let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
        
        return SafeAreaInsets(
            top: safeArea.top,
            bottom: safeArea.bottom,
            left: safeArea.left,
            right: safeArea.right,
            statusBarHeight: statusBarHeight
        )
    }
    #else
    public static var current: SafeAreaInsets {
        return defaultInsets
    }
    #endif
    
    private static var defaultInsets: SafeAreaInsets {
        #if os(iOS)
        return SafeAreaInsets(top: 44, bottom: 34, left: 0, right: 0, statusBarHeight: 44)
        #elseif os(macOS)
        return SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0, statusBarHeight: 24)
        #elseif os(tvOS)
        return SafeAreaInsets(top: 60, bottom: 60, left: 90, right: 90, statusBarHeight: 0)
        #elseif os(watchOS)
        return SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0, statusBarHeight: 0)
        #else
        return SafeAreaInsets(top: 0, bottom: 0, left: 0, right: 0, statusBarHeight: 0)
        #endif
    }
}

internal struct SafeAreaCache {
    let insets: SafeAreaInsets
    let timestamp: CFTimeInterval
    
    init(insets: SafeAreaInsets) {
        self.insets = insets
        self.timestamp = CACurrentMediaTime()
    }
    
    var isExpired: Bool {
        let ttl: CFTimeInterval = 10.0 // 10 seconds - safe area changes less frequently
        return CACurrentMediaTime() - timestamp > ttl
    }
}

internal final class SafeAreaCacheManager {
    private var cache: SafeAreaCache?
    private let lock = os_unfair_lock_t.allocate(capacity: 1)
    
    init() {
        lock.initialize(to: os_unfair_lock())
        setupNotificationObservers()
    }
    
    deinit {
        lock.deinitialize(count: 1)
        lock.deallocate()
    }
    
    func getSafeAreaInsets() -> SafeAreaInsets {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        
        if let cache = self.cache, !cache.isExpired {
            return cache.insets
        }
        
        let insets = SafeAreaInsets.current
        self.cache = SafeAreaCache(insets: insets)
        
        return insets
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
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(
                forName: UIScene.didActivateNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.invalidateCache()
            }
        }
        #endif
        // For other platforms, cache invalidation can be triggered manually
    }
    
    private func invalidateCache() {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        cache = nil
    }
    
    func preWarm() {
        #if canImport(UIKit)
        DispatchQueue.main.async { [weak self] in
            _ = self?.getSafeAreaInsets()
        }
        #else
        // Pre-warm with default values for non-UIKit platforms
        _ = getSafeAreaInsets()
        #endif
    }
}

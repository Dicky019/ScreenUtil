//
//  SafeAreaCacheManager.swift
//  ScreenUtil
//
//  High-performance safe area caching with TTL
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
import CoreGraphics
import QuartzCore
#if canImport(UIKit)
import UIKit
#endif

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

        NotificationCenter.default.addObserver(
            forName: UIScene.didActivateNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.invalidateCache()
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

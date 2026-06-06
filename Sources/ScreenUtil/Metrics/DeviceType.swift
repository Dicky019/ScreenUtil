//
//  DeviceType.swift
//  ScreenUtil
//
//  Platform/device classification
//  Created by Dicky Darmawan on 06/06/26.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public enum DeviceType: Sendable {
    case iPhone
    case iPad
    case mac
    case tv
    case watch
    case unknown

    /// Nonisolated, compile-time platform default (safe to read off the main actor).
    static var platformDefault: DeviceType {
        #if os(iOS)
        return .iPhone
        #elseif os(macOS)
        return .mac
        #elseif os(tvOS)
        return .tv
        #elseif os(watchOS)
        return .watch
        #else
        return .unknown
        #endif
    }

    #if os(iOS) && canImport(UIKit)
    /// Reads UIDevice (main-actor isolated) to distinguish iPhone vs iPad.
    @MainActor
    static var current: DeviceType {
        UIDevice.current.userInterfaceIdiom == .pad ? .iPad : .iPhone
    }
    #else
    @MainActor
    static var current: DeviceType { platformDefault }
    #endif
}

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

public enum DeviceType {
    case iPhone
    case iPad
    case mac
    case tv
    case watch
    case unknown

    public static var current: DeviceType {
        #if os(iOS)
            #if canImport(UIKit)
            if UIDevice.current.userInterfaceIdiom == .pad {
                return .iPad
            } else {
                return .iPhone
            }
            #else
            return .iPhone // Default fallback for iOS without UIKit
            #endif
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
}

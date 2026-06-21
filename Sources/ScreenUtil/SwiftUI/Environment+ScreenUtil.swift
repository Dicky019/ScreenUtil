//
//  Environment+ScreenUtil.swift
//  ScreenUtil
//
//  SwiftUI environment access to the shared ScreenUtil instance
//  Created by Dicky Darmawan on 06/06/26.
//

#if canImport(SwiftUI)
import SwiftUI

private struct ScreenUtilKey: EnvironmentKey {
    static let defaultValue: ScreenUtil = .shared
}

public extension EnvironmentValues {
    /// Access ScreenUtil instance from environment.
    var screenUtil: ScreenUtil {
        get { self[ScreenUtilKey.self] }
        set { self[ScreenUtilKey.self] = newValue }
    }
}

#endif

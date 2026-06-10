//
//  Log.swift
//  ScreenUtil
//
//  Unified-logging endpoints (os.Logger) for the package.
//  Created by Dicky Darmawan on 09/06/26.
//

import os

/// Logging category — each maps to a dedicated `os.Logger` Console.app category.
enum LogCategory: String {
    /// Library diagnostics (e.g. invalid input warnings).
    case core
    /// Developer console dumps from `ScreenUtilDebug`.
    case debug
    /// Benchmark output from `ScreenUtilDebug`.
    case benchmark

    fileprivate var logger: Logger {
        Logger(subsystem: "com.screenutil", category: rawValue)
    }
}

/// Severity of a `Log` call, mapped to the matching `os.Logger` level.
enum LogLevel {
    case debug, info, notice, warning, error, fault
}

/// Emit a message to the unified logging system (`os.Logger`).
///
/// `os.Logger` is level-filtered by the system, so this is cheap in release
/// builds. All package log data is non-sensitive, so messages are `.public`.
func Log(_ category: LogCategory, _ message: String, level: LogLevel = .info) {
    let logger = category.logger
    switch level {
    case .debug:   logger.debug("\(message, privacy: .public)")
    case .info:    logger.info("\(message, privacy: .public)")
    case .notice:  logger.notice("\(message, privacy: .public)")
    case .warning: logger.warning("\(message, privacy: .public)")
    case .error:   logger.error("\(message, privacy: .public)")
    case .fault:   logger.fault("\(message, privacy: .public)")
    }
}

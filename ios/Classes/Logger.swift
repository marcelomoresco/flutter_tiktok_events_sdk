import Foundation
import os.log

/// Production-safe logger utility for TikTok Events SDK
/// Uses OSLog for proper logging that respects privacy and system settings
/// Only logs verbose/debug information in DEBUG builds or when explicitly enabled
struct Logger {
    // MARK: - Constants

    /// Subsystem identifier for OSLog
    private static let subsystem = "com.tiktok.events.sdk"

    /// Default OSLog instance for general logging
    private static let defaultLog = OSLog(subsystem: subsystem, category: "default")

    /// OSLog instance for privacy-related logging
    private static let privacyLog = OSLog(subsystem: subsystem, category: "privacy")

    /// OSLog instance for error logging
    private static let errorLog = OSLog(subsystem: subsystem, category: "error")

    // MARK: - Log Levels

    enum LogLevel {
        case debug
        case info
        case warning
        case error

        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .warning:
                return .default
            case .error:
                return .error
            }
        }
    }

    // MARK: - Configuration

    /// Check if the build is in debug mode
    private static var isDebugBuild: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    /// Global flag to enable verbose logging (set from Flutter)
    private static var isVerboseEnabled: Bool = false

    /// Configure logger with verbose mode setting
    static func configure(verboseEnabled: Bool) {
        isVerboseEnabled = verboseEnabled
    }

    /// Check if debug/verbose messages should be logged
    private static func shouldLogDebug() -> Bool {
        return isDebugBuild || isVerboseEnabled
    }

    // MARK: - Logging Methods

    /// Log a debug message (only in DEBUG builds or when verbose mode is enabled)
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: Optional category for specialized logging (default: default)
    static func debug(_ message: String, category: String? = nil) {
        guard shouldLogDebug() else { return }

        let log = category == "privacy" ? privacyLog : defaultLog
        os_log("%{public}@", log: log, type: .debug, message)
    }

    /// Log an info message
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: Optional category for specialized logging (default: default)
    static func info(_ message: String, category: String? = nil) {
        let log = category == "privacy" ? privacyLog : defaultLog
        os_log("%{public}@", log: log, type: .info, message)
    }

    /// Log a warning message
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: Optional category for specialized logging (default: default)
    static func warning(_ message: String, category: String? = nil) {
        let log = category == "privacy" ? privacyLog : defaultLog
        os_log("%{public}@", log: log, type: .default, message)
    }

    /// Log an error message
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: Optional category for specialized logging (default: error)
    static func error(_ message: String, category: String? = nil) {
        let log = category == "privacy" ? privacyLog : errorLog
        os_log("%{public}@", log: log, type: .error, message)
    }

    /// Log with explicit log level and category
    /// - Parameters:
    ///   - level: The log level
    ///   - message: The message to log
    ///   - category: Optional category for specialized logging
    static func log(level: LogLevel, _ message: String, category: String? = nil) {
        // Skip debug messages in production unless verbose is enabled
        if level == .debug && !shouldLogDebug() {
            return
        }

        let log: OSLog
        if category == "privacy" {
            log = privacyLog
        } else if level == .error {
            log = errorLog
        } else {
            log = defaultLog
        }

        os_log("%{public}@", log: log, type: level.osLogType, message)
    }

    // MARK: - Convenience Methods with Context

    /// Log a debug message with context about ATT (App Tracking Transparency)
    /// - Parameter message: The message to log
    static func debugATT(_ message: String) {
        debug(message, category: "privacy")
    }

    /// Log an info message with context about ATT
    /// - Parameter message: The message to log
    static func infoATT(_ message: String) {
        info(message, category: "privacy")
    }

    /// Log a warning message with context about ATT
    /// - Parameter message: The message to log
    static func warningATT(_ message: String) {
        warning(message, category: "privacy")
    }

    /// Log an error message with context about ATT
    /// - Parameter message: The message to log
    static func errorATT(_ message: String) {
        error(message, category: "privacy")
    }
}


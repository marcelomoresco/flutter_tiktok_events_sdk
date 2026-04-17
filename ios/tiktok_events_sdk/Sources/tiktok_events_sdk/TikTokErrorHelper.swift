import Flutter
import TikTokBusinessSDK

/// Helper class for handling errors in a secure way
/// Shows detailed error messages in debug builds and generic messages in production
struct TikTokErrorHelper {

    /// Check if the build is in debug mode
    static func isDebugBuild() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    /// Check if verbose logging is enabled based on log level
    static func isVerboseLogging(_ logLevel: TikTokLogLevel) -> Bool {
        return logLevel == TikTokLogLevelDebug || logLevel == TikTokLogLevelVerbose
    }

    /// Create an error response that shows detailed information in debug mode
    /// but only generic messages in production to prevent information disclosure
    ///
    /// - Parameters:
    ///   - code: Error code identifier
    ///   - genericMessage: Generic error message shown in production
    ///   - detailedMessage: Detailed error message (including exception details) shown in debug
    ///   - result: Flutter result callback
    static func emitSecureError(
        code: String,
        genericMessage: String,
        detailedMessage: String,
        result: @escaping FlutterResult
    ) {
        let isDebugMode = isDebugBuild()
        let message = isDebugMode ? detailedMessage : genericMessage
        result(FlutterError(code: code, message: message, details: nil))
    }

    /// Create an error response with exception details conditionally shown based on debug mode
    ///
    /// - Parameters:
    ///   - code: Error code identifier
    ///   - genericMessage: Generic error message shown in production
    ///   - error: The exception that occurred
    ///   - result: Flutter result callback
    static func emitSecureError(
        code: String,
        genericMessage: String,
        error: Error,
        result: @escaping FlutterResult
    ) {
        let isDebugMode = isDebugBuild()
        let message = isDebugMode ? "\(genericMessage): \(error.localizedDescription)" : genericMessage
        result(FlutterError(code: code, message: message, details: nil))
    }

    /// Create an error response with exception details conditionally shown based on debug mode and verbose logging
    ///
    /// - Parameters:
    ///   - code: Error code identifier
    ///   - genericMessage: Generic error message shown in production
    ///   - error: The exception that occurred
    ///   - isDebugMode: Whether the app is in debug mode
    ///   - logLevel: The current log level
    ///   - result: Flutter result callback
    static func emitSecureError(
        code: String,
        genericMessage: String,
        error: Error,
        isDebugMode: Bool,
        logLevel: TikTokLogLevel,
        result: @escaping FlutterResult
    ) {
        let isVerboseLoggingEnabled = isVerboseLogging(logLevel)
        let shouldShowDetails = isDebugMode && isVerboseLoggingEnabled
        let message = shouldShowDetails ? "\(genericMessage): \(error.localizedDescription)" : genericMessage
        result(FlutterError(code: code, message: message, details: nil))
    }
}


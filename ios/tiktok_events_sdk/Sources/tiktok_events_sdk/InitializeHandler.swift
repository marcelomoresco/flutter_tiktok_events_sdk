import Flutter
import TikTokBusinessSDK
import Foundation
import os.log
import AppTrackingTransparency

struct InitializeHandler {
    private static let logger = OSLog(subsystem: "com.tiktok.events.sdk", category: "privacy")

    /// Thread-safe initialization state tracking
    private static let initializationQueue = DispatchQueue(label: "com.tiktok.events.sdk.initialization")
    private static var _isInitialized: Bool = false

    /// Thread-safe getter for initialization state
    static func getIsInitialized() -> Bool {
        return initializationQueue.sync {
            return _isInitialized
        }
    }

    /// Thread-safe setter for initialization state
    static func setIsInitialized(_ value: Bool) {
        initializationQueue.sync {
            _isInitialized = value
        }
    }

    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let appId = args["appId"] as? String,
              let tiktokAppId = args["tiktokId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing 'appId' or 'tiktokId'", details: nil))
            return
        }

        let isDebugMode = args["isDebugMode"] as? Bool ?? false
        let logLevelString = args["logLevel"] as? String ?? "info"
        let logLevel = mapLogLevel(logLevelString)

        // Configure Logger with verbose mode based on debug mode and log level
        let isVerboseLogging = isDebugMode && TikTokErrorHelper.isVerboseLogging(logLevel)
        Logger.configure(verboseEnabled: isVerboseLogging)
        let options = args["options"] as? [String: Any] ?? [:]
        let accessToken = options["accessToken"] as? String

        // Validate ATT suppression consent before continuing
        if options["displayAtt"] as? Bool == false {
            if let validationError = validateATTSuppressionConsent(options: options, isDebugMode: isDebugMode, logLevel: logLevel) {
                result(FlutterError(
                    code: "ATT_SUPPRESSION_VALIDATION_FAILED",
                    message: validationError.message,
                    details: ["validationErrors": validationError.errors]
                ))
                return
            }
        }

        let ttConfig: TikTokConfig

        if let token = accessToken, !token.isEmpty {
            ttConfig = TikTokConfig(accessToken: token, appId: appId, tiktokAppId: tiktokAppId)!
        } else {
            ttConfig = TikTokConfig(appId: appId, tiktokAppId: tiktokAppId)!
        }

        configureOptions(ttConfig: ttConfig, options: options, isDebugMode: isDebugMode, logLevel: logLevel)

        if isDebugMode {
            ttConfig.enableDebugMode()
        }

        ttConfig.setLogLevel(logLevel)

        TikTokBusiness.initializeSdk(ttConfig) { success, error in
            if let error = error {
                // Show detailed error in debug mode with verbose logging, generic error in production
                TikTokErrorHelper.emitSecureError(
                    code: "INIT_FAILED",
                    genericMessage: "TikTok SDK initialization failed",
                    error: error,
                    isDebugMode: isDebugMode,
                    logLevel: logLevel,
                    result: result
                )
            } else {
                setIsInitialized(true)
                result("TikTok SDK initialized successfully!")

                // Request ATT permission asynchronously after returning result
                let displayAtt = options["displayAtt"] as? Bool ?? true
                if displayAtt {
                    let attStatus = ATTrackingManager.trackingAuthorizationStatus
                    Logger.debugATT("🔵 Current ATT status: \(attStatus.rawValue)")

                    if attStatus == .notDetermined {
                        Logger.debugATT("🔵 Requesting ATT permission in background...")
                        DispatchQueue.main.async {
                            ATTrackingManager.requestTrackingAuthorization { status in
                                Logger.debugATT("🔵 ATT authorization result: \(status.rawValue)")
                            }
                        }
                    } else {
                        Logger.debugATT("🔵 ATT already determined (status: \(attStatus.rawValue))")
                    }
                }
            }
        }
    }

    private static func configureOptions(ttConfig: TikTokConfig, options: [String: Any], isDebugMode: Bool, logLevel: TikTokLogLevel) {
        if options["disableTracking"] as? Bool == true {
            ttConfig.disableTracking()
        }
        if options["disableAutomaticTracking"] as? Bool == true {
            ttConfig.disableAutomaticTracking()
        }
        if options["disableInstallTracking"] as? Bool == true {
            ttConfig.disableInstallTracking()
        }
        if options["disableLaunchTracking"] as? Bool == true {
            ttConfig.disableLaunchTracking()
        }
        if options["disableRetentionTracking"] as? Bool == true {
            ttConfig.disableRetentionTracking()
        }
        if options["disablePaymentTracking"] as? Bool == true {
            ttConfig.disablePaymentTracking()
        }
        if options["disableAppTrackingDialog"] as? Bool == true {
            ttConfig.disableAppTrackingDialog()
        }
        if options["disableSKAdNetworkSupport"] as? Bool == true {
            ttConfig.disableSKAdNetworkSupport()
        }
        if options["displayAtt"] as? Bool == false {
            // When suppressing ATT, validate consent verification is provided
            validateAndEnforceATTSuppression(options: options, isDebugMode: isDebugMode, logLevel: logLevel)
            ttConfig.disableAppTrackingDialog()
        }
    }

    /// Validation result structure for ATT suppression
    private struct ATTValidationError {
        let message: String
        let errors: [String]
    }

    /// Validates ATT suppression consent before initialization
    private static func validateATTSuppressionConsent(options: [String: Any], isDebugMode: Bool, logLevel: TikTokLogLevel) -> ATTValidationError? {
        // Extract consent verification parameters
        let consentTimestamp = options["externalConsentTimestamp"] as? String
        let consentStatus = options["externalConsentStatus"] as? String
        let auditId = options["attAuditId"] as? String

        // Validate that required fields are provided
        var validationErrors: [String] = []

        if consentTimestamp == nil || consentTimestamp!.isEmpty {
            validationErrors.append("externalConsentTimestamp is required when displayAtt=false")
        }

        if consentStatus == nil || consentStatus!.isEmpty {
            validationErrors.append("externalConsentStatus is required when displayAtt=false")
        } else if consentStatus != "granted" && consentStatus != "denied" {
            validationErrors.append("externalConsentStatus must be 'granted' or 'denied'")
        }

        // Check timestamp format (ISO 8601 validation)
        if let timestamp = consentTimestamp, !timestamp.isEmpty {
            if !isValidISOTimestamp(timestamp) {
                validationErrors.append("externalConsentTimestamp must be in ISO 8601 format (e.g., '2024-01-15T10:30:00Z')")
            }
        }

        // Log audit trail
        let auditTrail = generateAuditTrail(
            consentTimestamp: consentTimestamp,
            consentStatus: consentStatus,
            auditId: auditId,
            validationErrors: validationErrors
        )

        // Return error if validation failed
        if !validationErrors.isEmpty {
            let errorMessage = """
            The following required parameters are missing or invalid:
            \(validationErrors.joined(separator: "\n"))

            SECURITY REQUIREMENT: When suppressing ATT, you MUST provide:
            1. externalConsentTimestamp (ISO 8601 timestamp when consent was obtained)
            2. externalConsentStatus (must be "granted" or "denied")

            This is required for compliance verification and audit trails.
            """

            os_log("%{public}@", log: logger, type: .error, "❌ ATT Suppression Validation Failed\n\(errorMessage)")
            Logger.errorATT("❌ ATT Suppression Validation Failed\n\(errorMessage)")

            if isDebugMode && TikTokErrorHelper.isVerboseLogging(logLevel) {
                Logger.debugATT("\n📋 DEBUG INFO: Audit Trail:\n\(auditTrail)")
            }

            return ATTValidationError(message: errorMessage, errors: validationErrors)
        }

        return nil
    }

    /// Validates and enforces ATT suppression with mandatory consent verification
    private static func validateAndEnforceATTSuppression(options: [String: Any], isDebugMode: Bool, logLevel: TikTokLogLevel) {
        // Extract consent verification parameters (already validated, but we need them for logging)
        let consentTimestamp = options["externalConsentTimestamp"] as? String
        let consentStatus = options["externalConsentStatus"] as? String
        let auditId = options["attAuditId"] as? String

        // Generate audit trail for logging
        let auditTrail = generateAuditTrail(
            consentTimestamp: consentTimestamp,
            consentStatus: consentStatus,
            auditId: auditId,
            validationErrors: []
        )

        // Log successful suppression with audit trail
        let warningMessage = """
        ⚠️ SECURITY WARNING: ATT Suppression Enabled
        App is suppressing the App Tracking Transparency dialog.
        LEGAL REQUIREMENT: Ensure your app has obtained proper ATT consent through alternative means.
        COMPLIANCE: Only use this flag if you've already presented the ATT dialog in your app.
        RISK: Improper use may violate App Store guidelines and user privacy regulations.

        📋 AUDIT TRAIL:
        \(auditTrail)
        """

        // Always log to os_log (persistent, visible in production)
        os_log("%{public}@", log: logger, type: .error, warningMessage)

        // Use Logger for consistent logging (respects production safety)
        Logger.warningATT(warningMessage)

        // Additional verbose logging in debug mode
        if isDebugMode && TikTokErrorHelper.isVerboseLogging(logLevel) {
            Logger.debugATT("📋 DEBUG INFO: ATT suppression is being used with verified consent. Audit trail stored.")
        }
    }

    /// Validates ISO 8601 timestamp format
    private static func isValidISOTimestamp(_ timestamp: String) -> Bool {
        // ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ or YYYY-MM-DDTHH:MM:SS+00:00
        let iso8601Pattern = "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(Z|[+-]\\d{2}:\\d{2})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", iso8601Pattern)
        return predicate.evaluate(with: timestamp)
    }

    /// Generates an audit trail for ATT suppression
    private static func generateAuditTrail(
        consentTimestamp: String?,
        consentStatus: String?,
        auditId: String?,
        validationErrors: [String]
    ) -> String {
        var trail = "Timestamp: \(consentTimestamp ?? "N/A")\n"
        trail += "Status: \(consentStatus ?? "N/A")\n"
        trail += "Audit ID: \(auditId ?? "N/A")\n"
        trail += "Validation: \(validationErrors.isEmpty ? "PASSED" : "FAILED")\n"

        if !validationErrors.isEmpty {
            trail += "Errors:\n"
            for error in validationErrors {
                trail += "  - \(error)\n"
            }
        }

        return trail
    }

    private static func mapLogLevel(_ level: String) -> TikTokLogLevel {
        switch level.lowercased() {
        case "none":
            return TikTokLogLevelSuppress
        case "info":
            return TikTokLogLevelInfo
        case "warn":
            return TikTokLogLevelWarn
        case "debug":
            return TikTokLogLevelDebug
        case "verbose":
            return TikTokLogLevelVerbose
        default:
            return TikTokLogLevelInfo
        }
    }
}

import Flutter
import TikTokBusinessSDK
import Foundation
import os.log

struct InitializeHandler {
    private static let logger = OSLog(subsystem: "com.tiktok.events.sdk", category: "privacy")

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
        let options = args["options"] as? [String: Any] ?? [:]
        let accessToken = options["accessToken"] as? String

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
                result("TikTok SDK initialized successfully!")
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
            enforceATTSuppression(isDebugMode: isDebugMode, logLevel: logLevel)
            ttConfig.disableAppTrackingDialog()
        }
    }

    private static func enforceATTSuppression(isDebugMode: Bool, logLevel: TikTokLogLevel) {
        let warningMessage = """
        ⚠️ SECURITY WARNING: ATT Suppression Enabled
        App is suppressing the App Tracking Transparency dialog.
        LEGAL REQUIREMENT: Ensure your app has obtained proper ATT consent through alternative means.
        COMPLIANCE: Only use this flag if you've already presented the ATT dialog in your app.
        RISK: Improper use may violate App Store guidelines and user privacy regulations.
        """

        // Always log to os_log (persistent, visible in production)
        os_log("%{public}@", log: logger, type: .error, warningMessage)

        // Console output for immediate visibility
        print(warningMessage)

        // Additional verbose logging in debug mode
        if isDebugMode && TikTokErrorHelper.isVerboseLogging(logLevel) {
            print("📋 DEBUG INFO: ATT suppression is being used. Verify compliance with App Store guidelines and GDPR/CCPA regulations.")
        }
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

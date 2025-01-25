import Flutter
import TikTokBusinessSDK
import Foundation

struct InitializeHandler {
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

        let ttConfig = TTConfig(appId: appId, tiktokAppId: tiktokAppId)
        
        configureOptions(ttConfig: ttConfig, options: options)

        if isDebugMode {
            ttConfig.openDebugMode()
        }

        ttConfig.setLogLevel(logLevel)

        TikTokBusiness.initializeSdk(ttConfig: ttConfig) { success, error in
            if let error = error {
                result(FlutterError(code: "INIT_FAILED", message: "TikTok SDK initialization failed: \(error.localizedDescription)", details: nil))
            } else {
                result("TikTok SDK initialized successfully!")
            }
        }
    }

    private static func configureOptions(ttConfig: TTConfig, options: [String: Any]) {
        if options["disableAutoStart"] as? Bool == true {
            ttConfig.disableAutoStart()
        }
        if options["disableAutoEvents"] as? Bool == true {
            ttConfig.disableAutoEvents()
        }
        if options["disableInstallLogging"] as? Bool == true {
            ttConfig.disableInstallLogging()
        }
        if options["disableLaunchLogging"] as? Bool == true {
            ttConfig.disableLaunchLogging()
        }
        if options["disableRetentionLogging"] as? Bool == true {
            ttConfig.disableRetentionLogging()
        }
        if options["enableAutoIapTrack"] as? Bool == true {
            ttConfig.enableAutoIapTrack()
        }
        if options["disableAdvertiserIDCollection"] as? Bool == true {
            ttConfig.disableAdvertiserIDCollection()
        }
    }

    private static func mapLogLevel(_ level: String) -> TTLogLevel {
        switch level.lowercased() {
        case "none":
            return .none
        case "info":
            return .info
        case "warn":
            return .warn
        case "debug":
            return .debug
        case "verbose":
            return .verbose
        default:
            return .none
        }
    }
}

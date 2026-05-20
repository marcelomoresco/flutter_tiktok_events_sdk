import Flutter
import TikTokBusinessSDK
import Foundation

struct SetTrackingEnabledHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let enabled = args["enabled"] as? Bool else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing 'enabled' boolean",
                details: nil
            ))
            return
        }

        TikTokBusiness.setTrackingEnabled(enabled)
        result("TikTok tracking enabled set to \(enabled)")
    }
}

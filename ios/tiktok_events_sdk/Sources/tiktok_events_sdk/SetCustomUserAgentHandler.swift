import Flutter
import TikTokBusinessSDK
import Foundation

struct SetCustomUserAgentHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let userAgent = args["userAgent"] as? String,
              !userAgent.isEmpty else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or empty 'userAgent'",
                details: nil
            ))
            return
        }

        TikTokBusiness.setCustomUserAgent(userAgent)
        result("TikTok custom user agent set")
    }
}

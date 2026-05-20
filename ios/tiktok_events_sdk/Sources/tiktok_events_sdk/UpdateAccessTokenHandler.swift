import Flutter
import TikTokBusinessSDK
import Foundation

struct UpdateAccessTokenHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let accessToken = args["accessToken"] as? String,
              !accessToken.isEmpty else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or empty 'accessToken'",
                details: nil
            ))
            return
        }

        TikTokBusiness.updateAccessToken(accessToken)
        result("TikTok access token updated")
    }
}

import Flutter
import TikTokBusinessSDK
import Foundation

struct LogoutHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            TikTokBusiness.logout()
            result("TikTok SDK logout completed successfully!")
        } catch let error {
            result(FlutterError(
                code: "LOGOUT_FAILED",
                message: "Failed to logout from TikTok SDK: \(error.localizedDescription)",
                details: nil
            ))
        }
    }
}

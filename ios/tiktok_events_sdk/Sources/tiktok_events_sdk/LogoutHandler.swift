import Flutter
import TikTokBusinessSDK
import Foundation

struct LogoutHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            TikTokBusiness.logout()
            result("TikTok SDK logout completed successfully!")
        } catch let error {
            // Show detailed error in debug mode, generic error in production
            TikTokErrorHelper.emitSecureError(
                code: "LOGOUT_FAILED",
                genericMessage: "An error occurred during logout",
                error: error,
                result: result
            )
        }
    }
}

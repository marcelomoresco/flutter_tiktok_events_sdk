import Flutter
import TikTokBusinessSDK
import Foundation

struct LogoutHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        TikTokBusiness.logout()
        result("TikTok SDK logout completed successfully!")
    }
}

import Flutter
import TikTokBusinessSDK
import Foundation

struct FlushHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        TikTokBusiness.explicitlyFlush()
        result("TikTok flush triggered")
    }
}

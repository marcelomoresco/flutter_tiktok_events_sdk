import Flutter
import TikTokBusinessSDK
import Foundation

struct IsTrackingEnabledHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(TikTokBusiness.isTrackingEnabled())
    }
}

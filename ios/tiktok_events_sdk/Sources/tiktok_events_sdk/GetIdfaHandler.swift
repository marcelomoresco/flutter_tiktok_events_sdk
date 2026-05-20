import Flutter
import TikTokBusinessSDK
import Foundation

struct GetIdfaHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(TikTokBusiness.idfa())
    }
}

import Flutter
import TikTokBusinessSDK
import Foundation

struct StartTrackHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            TikTokBusiness.setTrackingEnabled(true)
            result("TikTok SDK start track successfully!")
        } catch let error {
            result(FlutterError(
                code: "START_TRACK_FAILED",
                message: "Failed to start track from TikTok SDK: \(error.localizedDescription)",
                details: nil
            ))
        }
    }
}

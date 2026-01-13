import Flutter
import TikTokBusinessSDK
import Foundation
import AppTrackingTransparency
import AdSupport

struct StartTrackHandler {

    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {

        guard #available(iOS 14, *) else {
            result(FlutterError(
                code: "ATT_NOT_SUPPORTED",
                message: "App Tracking Transparency is only supported on iOS 14 or newer",
                details: nil
            ))
            return
        }

        let attStatus = ATTrackingManager.trackingAuthorizationStatus

        if attStatus == .authorized {
            do {
                TikTokBusiness.setTrackingEnabled(true)
                result("TikTok SDK start track successfully!")
            } catch let error {
                TikTokErrorHelper.emitSecureError(
                    code: "START_TRACK_FAILED",
                    genericMessage: "An error occurred while starting tracking",
                    error: error,
                    result: result
                )
            }
        } else {
            let errorMsg =
              "Cannot enable tracking: ATT authorization is not granted (status: \(attStatus.rawValue))"

            result(FlutterError(
                code: "CONSENT_NOT_GRANTED",
                message: errorMsg,
                details: [
                    "status": attStatus.rawValue,
                    "description": getATTStatusDescription(attStatus)
                ]
            ))
        }
    }

    @available(iOS 14, *)
    private static func getATTStatusDescription(
        _ status: ATTrackingManager.AuthorizationStatus
    ) -> String {
        switch status {
        case .notDetermined:
            return "ATT permission has not been requested yet"
        case .restricted:
            return "ATT permission is restricted by parental controls or device management"
        case .denied:
            return "User has denied ATT permission"
        case .authorized:
            return "ATT permission is authorized"
        @unknown default:
            return "Unknown ATT status"
        }
    }
}

import Flutter
import TikTokBusinessSDK
import Foundation
import AppTrackingTransparency
import AdSupport

struct StartTrackHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Check ATT authorization status before enabling tracking
        let attStatus = ATTrackingManager.trackingAuthorizationStatus

        if attStatus == .authorized {
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
        } else {
            // Tracking is not authorized - do not enable tracking
            let errorMsg = "Cannot enable tracking: ATT authorization is not granted (status: \(attStatus.rawValue))"
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

    private static func getATTStatusDescription(_ status: ATTrackingManager.AuthorizationStatus) -> String {
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

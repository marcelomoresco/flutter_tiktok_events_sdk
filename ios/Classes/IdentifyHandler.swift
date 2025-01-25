import Flutter
import TikTokBusinessSDK
import Foundation

struct IdentifyHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let externalId = args["externalId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing 'externalId'", details: nil))
            return
        }

        let externalUserName = args["externalUserName"] as? String
        let phoneNumber = args["phoneNumber"] as? String
        let email = args["email"] as? String

        TikTokBusiness.identify(
            withExternalID: externalId,
            externalUserName: externalUserName,
            phoneNumber: phoneNumber,
            email: email
        )
        
        result("User identified successfully!")
    }
}

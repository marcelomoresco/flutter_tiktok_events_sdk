import Flutter
import Foundation
import TikTokBusinessSDK
import CryptoKit

struct IdentifyHandler {
    /// F-006 Fix: Hash PII data using SHA-256 before forwarding to TikTok
    /// This minimizes breach impact if data is intercepted
    private static func hashPII(_ data: String?) -> String? {
        guard let data = data, !data.isEmpty else { return nil }

        guard let dataToHash = data.data(using: .utf8) else { return nil }
        let hashed = SHA256.hash(data: dataToHash)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// F-008 Fix: Validate email format
    private static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    /// F-008 Fix: Validate phone number format
    private static func isValidPhone(_ phone: String) -> Bool {
        // Allow digits, spaces, hyphens, parentheses, and + for international format
        let phoneRegex = "^[+]?[\\d\\s\\-()]{8,20}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }

    /// F-008 Fix: Sanitize string input to prevent injection
    private static func sanitizeString(_ input: String?) -> String? {
        guard let input = input, !input.isEmpty else { return nil }
        // Remove potentially dangerous characters
        let sanitized = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "[<>\"'\\\\]", with: "", options: .regularExpression)
        return sanitized.isEmpty ? nil : sanitized
    }

    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
            let externalId = args["externalId"] as? String
        else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENTS", message: "Missing 'externalId'", details: nil))
            return
        }

        let rawExternalUserName = args["externalUserName"] as? String
        let rawPhoneNumber = args["phoneNumber"] as? String
        let rawEmail = args["email"] as? String

        // F-008 Fix: Sanitize inputs
        let sanitizedExternalId = sanitizeString(externalId)
        let sanitizedExternalUserName = sanitizeString(rawExternalUserName)

        // F-008 Fix: Validate required parameters
        guard let sanitizedId = sanitizedExternalId, !sanitizedId.isEmpty else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid 'externalId'", details: nil))
            return
        }

        // F-008 Fix: Validate email if provided
        if let email = rawEmail, !email.isEmpty {
            if !isValidEmail(email) {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid email format", details: nil))
                return
            }
        }

        // F-008 Fix: Validate phone if provided
        if let phone = rawPhoneNumber, !phone.isEmpty {
            if !isValidPhone(phone) {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid phone format", details: nil))
                return
            }
        }

        // F-006 Fix: Hash PII before forwarding to TikTok
        let hashedPhone = rawPhoneNumber != nil ? hashPII(rawPhoneNumber) : nil
        let hashedEmail = rawEmail != nil ? hashPII(rawEmail) : nil

        TikTokBusiness.identify(
            withExternalID: sanitizedId,
            externalUserName: sanitizedExternalUserName,
            phoneNumber: hashedPhone,
            email: hashedEmail
        )

        result("User identified successfully!")
    }
}

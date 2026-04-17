import Flutter
import Foundation

/// Handler for checking if the TikTok SDK is already initialized.
/// This is useful for preventing re-initialization during hot restarts.
struct IsAlreadyInitializedHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let isInitialized = InitializeHandler.getIsInitialized()
        result(isInitialized)
    }
}


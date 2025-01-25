import Flutter
import UIKit

public class TiktokEventsSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tiktok_events_sdk", binaryMessenger: registrar.messenger())
    let instance = TiktokEventsSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case TikTokMethodName.initialize:
            InitializeHandler.handle(call: call, result: result)
   case TikTokMethodName.identify:
            IdentifyHandler.handle(call: call, result: result)
    case TikTokMethodName.logout:
          LogoutHandler.handle(call: call, result: result)
    case TikTokMethodName.sendEvent:
          SendEventHandler.handle(call: call, result: result)
    default:
            result(FlutterMethodNotImplemented)
    }
  }
}


struct TikTokMethodName {
    static let initialize = "initialize"
    static let identify = "identify"
    static let logout = "logout"
    static let sendEvent = "sendEvent"
}
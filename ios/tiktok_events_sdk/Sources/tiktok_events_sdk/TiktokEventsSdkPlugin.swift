import Flutter
import UIKit

public class TiktokEventsSdkPlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tiktok_events_sdk", binaryMessenger: registrar.messenger())
    let instance = TiktokEventsSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
    registrar.addSceneDelegate(instance)
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
    case TikTokMethodName.startTrack:
          StartTrackHandler.handle(call: call, result: result)
    case TikTokMethodName.isAlreadyInitialized:
          IsAlreadyInitializedHandler.handle(call: call, result: result)
    case TikTokMethodName.setTrackingEnabled:
          SetTrackingEnabledHandler.handle(call: call, result: result)
    case TikTokMethodName.isTrackingEnabled:
          IsTrackingEnabledHandler.handle(call: call, result: result)
    case TikTokMethodName.flush:
          FlushHandler.handle(call: call, result: result)
    case TikTokMethodName.updateAccessToken:
          UpdateAccessTokenHandler.handle(call: call, result: result)
    case TikTokMethodName.getIdfa:
          GetIdfaHandler.handle(call: call, result: result)
    case TikTokMethodName.setCustomUserAgent:
          SetCustomUserAgentHandler.handle(call: call, result: result)
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
    static let startTrack = "startTrack"
    static let isAlreadyInitialized = "isAlreadyInitialized"
    static let setTrackingEnabled = "setTrackingEnabled"
    static let isTrackingEnabled = "isTrackingEnabled"
    static let flush = "flush"
    static let updateAccessToken = "updateAccessToken"
    static let getIdfa = "getIdfa"
    static let setCustomUserAgent = "setCustomUserAgent"
}

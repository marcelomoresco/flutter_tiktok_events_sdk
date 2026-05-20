import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tiktok_events_sdk/src/models/config/tiktok_android_options.dart';
import 'package:tiktok_events_sdk/src/models/config/tiktok_ios_options.dart';
import 'package:tiktok_events_sdk/src/models/events/tiktok_event.dart';
import 'package:tiktok_events_sdk/src/models/tiktok_identifier.dart';
import 'package:tiktok_events_sdk/src/models/tiktok_log_level.dart';

import 'tiktok_events_sdk_method_channel.dart';

abstract class TiktokEventsSdkPlatform extends PlatformInterface {
  /// Constructs a TiktokEventsSdkPlatform.
  TiktokEventsSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static TiktokEventsSdkPlatform _instance = MethodChannelTiktokEventsSdk();

  /// The default instance of [TiktokEventsSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelTiktokEventsSdk].
  static TiktokEventsSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TiktokEventsSdkPlatform] when
  /// they register themselves.
  static set instance(TiktokEventsSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initSdk({
    required String androidAppId,
    required String tikTokAndroidId,
    required String iosAppId,
    required String tiktokIosId,
    bool isDebugMode = false,
    TikTokAndroidOptions androidOptions = const TikTokAndroidOptions(),
    TikTokIosOptions iosOptions = const TikTokIosOptions(),
    TikTokLogLevel logLevel = TikTokLogLevel.info,
  }) async {
    return _instance.initSdk(
      androidAppId: androidAppId,
      tikTokAndroidId: tikTokAndroidId,
      iosAppId: iosAppId,
      tiktokIosId: tiktokIosId,
      isDebugMode: isDebugMode,
      androidOptions: androidOptions,
      iosOptions: iosOptions,
      logLevel: logLevel,
    );
  }

  Future<void> logout() async {
    return _instance.logout();
  }

  Future<void> startTrack({required bool hasConsent}) async {
    return _instance.startTrack(hasConsent: hasConsent);
  }

  Future<void> identify({required TikTokIdentifier identifier}) async {
    return _instance.identify(identifier: identifier);
  }

  Future<void> logEvent({required TikTokEvent event}) async {
    return await _instance.logEvent(event: event);
  }

  /// Checks if the TikTok SDK is already initialized.
  ///
  /// Returns `true` if the SDK has been initialized, `false` otherwise.
  /// This is useful for preventing re-initialization during hot restarts.
  Future<bool> isAlreadyInitialized();

  /// Enables or disables event tracking at runtime.
  ///
  /// On iOS, maps to `TikTokBusiness.setTrackingEnabled(BOOL)`.
  /// On Android, maps to `TikTokBusinessSdk.setSdkGlobalSwitch(Boolean)`.
  Future<void> setTrackingEnabled({required bool enabled}) async {
    return _instance.setTrackingEnabled(enabled: enabled);
  }

  /// Returns whether event tracking is currently enabled.
  ///
  /// On iOS, maps to `TikTokBusiness.isTrackingEnabled`.
  /// On Android, maps to `TikTokBusinessSdk.getSdkGlobalSwitch`.
  Future<bool> isTrackingEnabled() async {
    return _instance.isTrackingEnabled();
  }

  /// Forces an immediate flush of queued events to TikTok's servers.
  ///
  /// On iOS, maps to `TikTokBusiness.explicitlyFlush()`.
  /// On Android, maps to `TikTokBusinessSdk.flush()`.
  Future<void> flush() async {
    return _instance.flush();
  }

  /// Updates the access token used to authenticate requests to TikTok.
  ///
  /// On iOS, maps to `TikTokBusiness.updateAccessToken(String)`.
  /// On Android, maps to `TikTokBusinessSdk.updateAccessToken(String)`.
  Future<void> updateAccessToken({required String accessToken}) async {
    return _instance.updateAccessToken(accessToken: accessToken);
  }

  /// Returns the device IDFA on iOS, or `null` on Android (no equivalent).
  ///
  /// Returns `null` on iOS as well when the user has not granted ATT
  /// permission.
  ///
  /// Maps to `TikTokBusiness.idfa()` on iOS.
  Future<String?> getIdfa() async {
    return _instance.getIdfa();
  }

  /// Sets a custom User-Agent string for SDK network requests at runtime.
  ///
  /// On iOS, maps to `TikTokBusiness.setCustomUserAgent(String)`.
  /// On Android there is no runtime equivalent — the call is silently
  /// ignored. To set a User-Agent on Android use
  /// `TikTokAndroidOptions.customUserAgent` at init time (not exposed yet).
  Future<void> setCustomUserAgent({required String userAgent}) async {
    return _instance.setCustomUserAgent(userAgent: userAgent);
  }
}

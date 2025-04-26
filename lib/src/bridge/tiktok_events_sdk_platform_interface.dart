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
    );
  }

  Future<void> logout() async {
    return _instance.logout();
  }

  Future<void> startTrack() async {
    return _instance.startTrack();
  }

  Future<void> identify({required TikTokIdentifier identifier}) async {
    return _instance.identify(identifier: identifier);
  }

  Future<void> logEvent({
    required TikTokEvent event,
  }) async {
    return await _instance.logEvent(
      event: event,
    );
  }
}

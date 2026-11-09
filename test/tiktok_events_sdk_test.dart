import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_events_sdk/src/bridge/tiktok_events_sdk_platform_interface.dart';
import 'package:tiktok_events_sdk/src/bridge/tiktok_events_sdk_method_channel.dart';
import 'package:tiktok_events_sdk/src/exceptions/tiktok_exception.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

class MockTiktokEventsSdkPlatform
    with MockPlatformInterfaceMixin
    implements TiktokEventsSdkPlatform {
  @override
  Future<void> identify({required TikTokIdentifier identifier}) async {
    await Future.value();
  }

  @override
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
    await Future.value();
  }

  @override
  Future<void> logout() async {
    await Future.value();
  }

  @override
  Future<void> logEvent({required TikTokEvent event}) async {
    await Future.value();
  }

  @override
  Future<void> startTrack({bool hasConsent = false}) async {
    await Future.value();
  }

  @override
  Future<bool> isAlreadyInitialized() {
    // TODO: implement isAlreadyInitialized
    throw UnimplementedError();
  }

  @override
  Future<void> setTrackingEnabled({required bool enabled}) async {
    await Future.value();
  }

  @override
  Future<bool> isTrackingEnabled() async => true;

  @override
  Future<void> flush() async {
    await Future.value();
  }

  @override
  Future<void> updateAccessToken({required String accessToken}) async {
    await Future.value();
  }

  @override
  Future<String?> getIdfa() async => null;

  @override
  Future<void> setCustomUserAgent({required String userAgent}) async {
    await Future.value();
  }
}

class ThrowingLogEventPlatform extends MockTiktokEventsSdkPlatform {
  @override
  Future<void> logEvent({required TikTokEvent event}) async {
    throw TikTokException('Failed to log event in TikTok SDK');
  }
}

void main() {
  final TiktokEventsSdkPlatform initialPlatform =
      TiktokEventsSdkPlatform.instance;

  test('$MethodChannelTiktokEventsSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTiktokEventsSdk>());
  });

  test('logEvent propagates platform errors to the caller', () async {
    TiktokEventsSdkPlatform.instance = ThrowingLogEventPlatform();
    addTearDown(() => TiktokEventsSdkPlatform.instance = initialPlatform);

    await expectLater(
      TikTokEventsSdk.logEvent(event: TikTokEvent(eventName: 'test_event')),
      throwsA(isA<TikTokException>()),
    );
  });
}

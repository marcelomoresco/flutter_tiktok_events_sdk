import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_events_sdk/src/bridge/tiktok_events_sdk_platform_interface.dart';
import 'package:tiktok_events_sdk/src/bridge/tiktok_events_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

class MockTiktokEventsSdkPlatform with MockPlatformInterfaceMixin implements TiktokEventsSdkPlatform {
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
}

void main() {
  final TiktokEventsSdkPlatform initialPlatform = TiktokEventsSdkPlatform.instance;

  test('$MethodChannelTiktokEventsSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTiktokEventsSdk>());
  });
}

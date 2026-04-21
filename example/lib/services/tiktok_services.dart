import 'package:flutter/foundation.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

class TikTokService {
  static Future<void> init({
    required String androidAppId,
    required String tikTokAndroidId,
    required String iosAppId,
    required String tiktokIosId,
    bool isDebugMode = false,
    String? accessToken,
    TikTokLogLevel logLevel = TikTokLogLevel.info,
  }) async {
    debugPrint('🔵 TikTokService.init called');
    debugPrint(
        '🔵 Android App ID: ${androidAppId.isEmpty ? "EMPTY" : androidAppId.substring(0, androidAppId.length > 10 ? 10 : androidAppId.length)}...');
    debugPrint(
        '🔵 iOS App ID: ${iosAppId.isEmpty ? "EMPTY" : iosAppId.substring(0, iosAppId.length > 10 ? 10 : iosAppId.length)}...');
    debugPrint('🔵 Access Token: ${accessToken != null ? "PROVIDED" : "null"}');

    // Build iOS options with access token if provided
    final iosOptions = TikTokIosOptions(
      accessToken: accessToken,
    );

    debugPrint('🔵 Calling TikTokEventsSdk.initSdk...');
    await TikTokEventsSdk.initSdk(
      androidAppId: androidAppId,
      tikTokAndroidId: tikTokAndroidId,
      iosAppId: iosAppId,
      tiktokIosId: tiktokIosId,
      isDebugMode: isDebugMode,
      iosOptions: iosOptions,
      logLevel: logLevel,
    );
    debugPrint('✅ TikTokEventsSdk.initSdk completed');
  }

  static Future<void> startTrack() async {
    await TikTokEventsSdk.startTrack();
  }

  static Future<void> identify({
    required String externalId,
    String? externalUserName,
    String? phoneNumber,
    String? email,
  }) async {
    final identifier = TikTokIdentifier(
      externalId: externalId,
      externalUserName: externalUserName,
      phoneNumber: phoneNumber,
      email: email,
    );
    await TikTokEventsSdk.identify(
      identifier: identifier,
    );
  }

  static Future<void> logout() async {
    await TikTokEventsSdk.logout();
  }

  static Future<void> logEvent({
    required String eventName,
    TTEventType? eventType,
    String? eventId,
    EventProperties? properties,
  }) async {
    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(
        eventName: eventName,
        eventType: eventType ?? TTEventType.none,
        eventId: eventId,
        properties: properties,
      ),
    );
  }
}

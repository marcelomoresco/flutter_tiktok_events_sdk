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
    print('🔵 TikTokService.init called');
    print(
        '🔵 Android App ID: ${androidAppId.isEmpty ? "EMPTY" : androidAppId.substring(0, androidAppId.length > 10 ? 10 : androidAppId.length)}...');
    print(
        '🔵 iOS App ID: ${iosAppId.isEmpty ? "EMPTY" : iosAppId.substring(0, iosAppId.length > 10 ? 10 : iosAppId.length)}...');
    print('🔵 Access Token: ${accessToken != null ? "PROVIDED" : "null"}');

    // Build iOS options with access token if provided
    final iosOptions = TikTokIosOptions(
      accessToken: accessToken,
    );

    print('🔵 Calling TikTokEventsSdk.initSdk...');
    await TikTokEventsSdk.initSdk(
      androidAppId: androidAppId,
      tikTokAndroidId: tikTokAndroidId,
      iosAppId: iosAppId,
      tiktokIosId: tiktokIosId,
      isDebugMode: isDebugMode,
      iosOptions: iosOptions,
      logLevel: logLevel,
    );
    print('✅ TikTokEventsSdk.initSdk completed');
  }

  static Future<void> startTrack() async {
    await TikTokEventsSdk.startTrack();
  }

  static Future<void> identify({
    String? externalId,
    String? externalUserName,
    String? phoneNumber,
    String? email,
  }) async {
    if (externalId == null || externalUserName == null || email == null) {
      throw Exception('externalId, externalUserName, and email are required');
    }

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

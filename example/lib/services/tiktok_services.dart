import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

class TikTokService {
  static init() async {
    await TikTokEventsSdk.initSdk(
      androidAppId: '',
      tikTokAndroidId: '',
      iosAppId: '',
      tiktokIosId: '',
      isDebugMode: true,
      logLevel: TikTokLogLevel.info,
    );

    startTrack();
  }

  static startTrack() async {
    await TikTokEventsSdk.startTrack();
  }

  static identify() async {
    final identier = TikTokIdentifier(
      externalId: 'externalId',
      externalUserName: "externalUserName",
      phoneNumber: "phoneNumber",
      email: "email",
    );
    await TikTokEventsSdk.identify(
      identifier: identier,
    );
  }

  static logout() async {
    await TikTokEventsSdk.logout();
  }

  static logEvent() async {
    await TikTokEventsSdk.logEvent(
      event: TikTokEvent(
        eventName: 'eventName',
      ),
    );
  }
}

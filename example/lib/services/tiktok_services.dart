import 'package:tiktok_events_sdk/models/tiktok_identifier.dart';
import 'package:tiktok_events_sdk/models/tiktok_log_level.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

class TikTokService {
  static init() async {
    await TiktokEventsSdk.initSdk(
      androidAppId: '',
      tikTokAndroidId: '',
      iosAppId: '',
      tiktokIosId: '',
      isDebugMode: true,
      logLevel: TikTokLogLevel.info,
    );
  }

  static identify() async {
    final identier = TikTokIdentifier(
      externalId: 'externalId',
      externalUserName: "externalUserName",
      phoneNumber: "phoneNumber",
      email: "email",
    );
    await TiktokEventsSdk.identify(
      identifier: identier,
    );
  }
}

import 'package:tiktok_events_sdk/src/models/config/tiktok_android_options.dart';
import 'package:tiktok_events_sdk/src/models/config/tiktok_ios_options.dart';
import 'package:tiktok_events_sdk/src/models/events/tiktok_event.dart';
import 'package:tiktok_events_sdk/src/models/tiktok_identifier.dart';
import 'package:tiktok_events_sdk/src/models/tiktok_log_level.dart';

import 'src/bridge/tiktok_events_sdk_platform_interface.dart';

export 'src/sdk.dart';

/// A Flutter plugin for integrating the TikTok Events SDK.
///
/// This class provides methods to initialize the TikTok SDK, identify users,
/// log events, and handle user logout. It supports both Android and iOS platforms.
///
/// Usage example:
/// ```dart
/// // Initialize the SDK
/// await TiktokEventsSdk.initSdk(
///   androidAppId: 'your_android_app_id',
///   tikTokAndroidId: 'your_tiktok_android_id',
///   iosAppId: 'your_ios_app_id',
///   tiktokIosId: 'your_tiktok_ios_id',
///   isDebugMode: true,
///   logLevel: TikTokLogLevel.debug,
/// );
///
/// // Identify a user
/// await TiktokEventsSdk.identify(
///   identifier: TikTokIdentifier(
///     externalId: '12345',
///     externalUserName: 'john_doe',
///     phoneNumber: '+1234567890',
///     email: 'john.doe@example.com',
///   ),
/// );
///
/// // Log a custom event
/// await TiktokEventsSdk.logEvent(
///   event: TTBaseEvent.newBuilder('custom_event').build(),
/// );
///
/// // Logout the user
/// await TiktokEventsSdk.logout();
/// ```
class TikTokEventsSdk {
  /// Initializes the TikTok Events SDK.
  ///
  /// This method automatically handles hot restart scenarios by checking if
  /// the SDK is already initialized and skipping re-initialization if so.
  ///
  /// - [androidAppId]: The Android app ID for TikTok SDK.
  /// - [tikTokAndroidId]: The TikTok Android app ID.
  /// - [iosAppId]: The iOS app ID for TikTok SDK.
  /// - [tiktokIosId]: The TikTok iOS app ID.
  /// - [isDebugMode]: Enables debug mode if `true`.
  /// - [androidOptions]: Android-specific configuration options.
  /// - [iosOptions]: iOS-specific configuration options.
  /// - [logLevel]: The log level for the SDK.
  static Future<void> initSdk({
    required String androidAppId,
    required String tikTokAndroidId,
    required String iosAppId,
    required String tiktokIosId,
    bool isDebugMode = false,
    TikTokAndroidOptions androidOptions = const TikTokAndroidOptions(),
    TikTokIosOptions iosOptions = const TikTokIosOptions(),
    TikTokLogLevel logLevel = TikTokLogLevel.info,
  }) async {
    // Skip initialization if SDK is already initialized (handles hot restart)
    if (await isAlreadyInitialized()) {
      return;
    }

    return TiktokEventsSdkPlatform.instance.initSdk(
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

  /// Identifies a user with the provided [identifier].
  ///
  /// - [identifier]: The user identification data.
  static Future<void> identify({required TikTokIdentifier identifier}) async {
    return TiktokEventsSdkPlatform.instance.identify(identifier: identifier);
  }

  /// Logs out the current user.
  static Future<void> logout() async {
    return TiktokEventsSdkPlatform.instance.logout();
  }

  /// SDK will actually start sending app events to TikTok after startTrack() function is called - Use with the disableAutoStart
  static Future<void> startTrack() async {
    return TiktokEventsSdkPlatform.instance.startTrack(hasConsent: true);
  }

  /// Logs a custom event.
  ///
  /// - [event]: The event to log.
  static Future<void> logEvent({required TikTokEvent event}) async {
    try {
      return TiktokEventsSdkPlatform.instance.logEvent(event: event);
    } catch (e) {
      // Handle errors if needed
    }
  }

  /// Checks if the TikTok SDK is already initialized.
  ///
  /// Returns `true` if the SDK has been initialized, `false` otherwise.
  ///
  /// Note: You typically don't need to call this method directly as [initSdk]
  /// automatically handles hot restart scenarios by skipping re-initialization.
  /// This method is exposed for cases where you need to check initialization
  /// state explicitly.
  static Future<bool> isAlreadyInitialized() async {
    return TiktokEventsSdkPlatform.instance.isAlreadyInitialized();
  }

  /// Enables or disables event tracking at runtime.
  ///
  /// Use this to honor user consent decisions (GDPR/CCPA) after the SDK has
  /// already been initialized. When disabled, the SDK stops sending events.
  ///
  /// - [enabled]: `true` to enable tracking, `false` to disable.
  static Future<void> setTrackingEnabled({required bool enabled}) async {
    return TiktokEventsSdkPlatform.instance.setTrackingEnabled(
      enabled: enabled,
    );
  }

  /// Returns whether event tracking is currently enabled.
  static Future<bool> isTrackingEnabled() async {
    return TiktokEventsSdkPlatform.instance.isTrackingEnabled();
  }

  /// Forces an immediate flush of queued events to TikTok's servers.
  ///
  /// Useful before the app is backgrounded or terminated to ensure pending
  /// events are not lost.
  static Future<void> flush() async {
    return TiktokEventsSdkPlatform.instance.flush();
  }

  /// Updates the access token used to authenticate requests to TikTok.
  ///
  /// Use this when rotating tokens without re-initializing the SDK.
  ///
  /// - [accessToken]: The new access token.
  static Future<void> updateAccessToken({required String accessToken}) async {
    return TiktokEventsSdkPlatform.instance.updateAccessToken(
      accessToken: accessToken,
    );
  }

  /// Returns the device IDFA on iOS, or `null` on Android (no equivalent).
  ///
  /// Returns `null` on iOS too when ATT permission was not granted.
  static Future<String?> getIdfa() async {
    return TiktokEventsSdkPlatform.instance.getIdfa();
  }

  /// Sets a custom User-Agent string for SDK network requests at runtime.
  ///
  /// **iOS only.** Android has no runtime equivalent — the call is silently
  /// ignored on Android.
  ///
  /// - [userAgent]: The new User-Agent string.
  static Future<void> setCustomUserAgent({required String userAgent}) async {
    return TiktokEventsSdkPlatform.instance.setCustomUserAgent(
      userAgent: userAgent,
    );
  }
}

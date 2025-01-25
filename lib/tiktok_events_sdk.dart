library tiktok_events_sdk;

import 'package:tiktok_events_sdk/src/models/config/tiktok_android_options.dart';
import 'package:tiktok_events_sdk/src/models/config/tiktok_ios_options.dart';
import 'package:tiktok_events_sdk/src/models/events/tiktok_event.dart';
import 'package:tiktok_events_sdk/src/models/tiktok_identifier.dart';
import 'package:tiktok_events_sdk/src/models/tiktok_log_level.dart';
export 'src/sdk.dart';

import 'src/bridge/tiktok_events_sdk_platform_interface.dart';

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
  static Future<void> identify({
    required TikTokIdentifier identifier,
  }) async {
    return TiktokEventsSdkPlatform.instance.identify(
      identifier: identifier,
    );
  }

  /// Logs out the current user.
  static Future<void> logout() async {
    return TiktokEventsSdkPlatform.instance.logout();
  }

  /// Logs a custom event.
  ///
  /// - [event]: The event to log.
  static Future<void> logEvent({
    required TikTokEvent event,
  }) async {
    try {
      return TiktokEventsSdkPlatform.instance.logEvent(event: event);
    } catch (e) {
      // Handle errors if needed
    }
  }
}

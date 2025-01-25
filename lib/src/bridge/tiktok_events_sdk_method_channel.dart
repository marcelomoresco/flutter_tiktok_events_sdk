import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_events_sdk/src/exceptions/tiktok_exception.dart';
import 'package:tiktok_events_sdk/src/models/config/tiktok_android_options.dart';
import 'package:tiktok_events_sdk/src/models/config/tiktok_ios_options.dart';
import 'package:tiktok_events_sdk/src/models/events/tiktok_event.dart';
import 'package:tiktok_events_sdk/src/models/tiktok_identifier.dart';
import 'package:tiktok_events_sdk/src/models/tiktok_log_level.dart';

import 'tiktok_events_sdk_platform_interface.dart';

class _TikTokMethod {
  const _TikTokMethod();

  final initialize = 'initialize';
  final identify = 'identify';
  final sendEvent = 'sendEvent';
  final logout = 'logout';
}

/// An implementation of [TiktokEventsSdkPlatform] that uses method channels.
class MethodChannelTiktokEventsSdk extends TiktokEventsSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tiktok_events_sdk');

  final methodName = const _TikTokMethod();

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
    bool isIos = Platform.isIOS;
    final appId = isIos ? iosAppId : androidAppId;
    final tiktokId = isIos ? tiktokIosId : tikTokAndroidId;
    final options = isIos ? iosOptions.toMap() : androidOptions.toMap();

    try {
      final result = await methodChannel.invokeMethod(methodName.initialize, {
        'appId': appId,
        'tiktokId': tiktokId,
        'isDebugMode': isDebugMode,
        'logLevel': logLevel.name,
        'options': options,
      });
      log(result);
    } catch (e) {
      throw TikTokException(
        'Failed to initialize TikTok SDK',
        error: e,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await methodChannel.invokeMethod(methodName.logout);
      log('TikTok logout successful');
    } catch (e, _) {
      throw TikTokException(
        'Failed to logout from TikTok SDK',
        error: e,
      );
    }
  }

  @override
  Future<void> identify({
    required TikTokIdentifier identifier,
  }) async {
    try {
      await methodChannel.invokeMethod(
        methodName.identify,
        {
          'externalId': identifier.externalId,
          'externalUserName': identifier.externalUserName,
          'phoneNumber': identifier.phoneNumber,
          'email': identifier.email,
        },
      );
      log('TikTok identifier set successfully');
    } catch (e, _) {
      throw TikTokException(
        'Failed to identify user in TikTok SDK',
        error: e,
      );
    }
  }

  @override
  Future<void> logEvent({
    required TikTokEvent event,
  }) async {
    try {
      return await methodChannel.invokeMethod(
        methodName.sendEvent,
        event.toJson(),
      );
    } catch (e) {
      throw TikTokException(
        'Failed to log event in TikTok SDK',
        error: e,
      );
    }
  }
}

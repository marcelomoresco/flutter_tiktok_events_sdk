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
  final isAlreadyInitialized = 'isAlreadyInitialized';
  final setTrackingEnabled = 'setTrackingEnabled';
  final isTrackingEnabled = 'isTrackingEnabled';
  final flush = 'flush';
  final updateAccessToken = 'updateAccessToken';
  final getIdfa = 'getIdfa';
  final setCustomUserAgent = 'setCustomUserAgent';
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
      throw TikTokException('Failed to initialize TikTok SDK', error: e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await methodChannel.invokeMethod(methodName.logout);
      log('TikTok logout successful');
    } catch (e, _) {
      throw TikTokException('Failed to logout from TikTok SDK', error: e);
    }
  }

  @override
  Future<void> startTrack({required bool hasConsent}) async {
    try {
      await methodChannel.invokeMethod('startTrack', {
        'hasConsent': hasConsent,
      });
      log('TikTok tracking started successfully');
    } catch (e, _) {
      throw TikTokException('Failed to start tracking in TikTok SDK', error: e);
    }
  }

  @override
  Future<void> identify({required TikTokIdentifier identifier}) async {
    try {
      await methodChannel.invokeMethod(methodName.identify, {
        'externalId': identifier.externalId,
        'externalUserName': identifier.externalUserName,
        'phoneNumber': identifier.phoneNumber,
        'email': identifier.email,
      });
      log('TikTok identifier set successfully');
    } catch (e, _) {
      throw TikTokException('Failed to identify user in TikTok SDK', error: e);
    }
  }

  @override
  Future<void> logEvent({required TikTokEvent event}) async {
    try {
      return await methodChannel.invokeMethod(
        methodName.sendEvent,
        event.toJson(),
      );
    } catch (e) {
      throw TikTokException('Failed to log event in TikTok SDK', error: e);
    }
  }

  @override
  Future<bool> isAlreadyInitialized() async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        methodName.isAlreadyInitialized,
      );
      return result ?? false;
    } catch (e) {
      // If we can't determine initialization state, assume not initialized
      log('Failed to check TikTok SDK initialization state: $e');
      return false;
    }
  }

  @override
  Future<void> setTrackingEnabled({required bool enabled}) async {
    try {
      await methodChannel.invokeMethod(methodName.setTrackingEnabled, {
        'enabled': enabled,
      });
      log('TikTok tracking enabled set to $enabled');
    } catch (e) {
      throw TikTokException(
        'Failed to set tracking enabled in TikTok SDK',
        error: e,
      );
    }
  }

  @override
  Future<bool> isTrackingEnabled() async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        methodName.isTrackingEnabled,
      );
      return result ?? false;
    } catch (e) {
      log('Failed to read TikTok tracking enabled state: $e');
      return false;
    }
  }

  @override
  Future<void> flush() async {
    try {
      await methodChannel.invokeMethod(methodName.flush);
      log('TikTok flush completed');
    } catch (e) {
      throw TikTokException('Failed to flush events in TikTok SDK', error: e);
    }
  }

  @override
  Future<void> updateAccessToken({required String accessToken}) async {
    try {
      await methodChannel.invokeMethod(methodName.updateAccessToken, {
        'accessToken': accessToken,
      });
      log('TikTok access token updated');
    } catch (e) {
      throw TikTokException(
        'Failed to update access token in TikTok SDK',
        error: e,
      );
    }
  }

  @override
  Future<String?> getIdfa() async {
    if (!Platform.isIOS) return null;
    try {
      return await methodChannel.invokeMethod<String>(methodName.getIdfa);
    } catch (e) {
      log('Failed to read IDFA: $e');
      return null;
    }
  }

  @override
  Future<void> setCustomUserAgent({required String userAgent}) async {
    if (!Platform.isIOS) {
      // Android SDK has no runtime equivalent — silently no-op.
      return;
    }
    try {
      await methodChannel.invokeMethod(methodName.setCustomUserAgent, {
        'userAgent': userAgent,
      });
      log('TikTok custom user agent set');
    } catch (e) {
      throw TikTokException(
        'Failed to set custom user agent in TikTok SDK',
        error: e,
      );
    }
  }
}

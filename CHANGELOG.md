## 1.3.0

- Added runtime tracking controls aligned with the native SDK:
  - `TikTokEventsSdk.setTrackingEnabled(enabled:)` — toggle event tracking after init (GDPR/CCPA consent flows). Maps to `TikTokBusiness.setTrackingEnabled` on iOS and `TikTokBusinessSdk.setSdkGlobalSwitch` on Android.
  - `TikTokEventsSdk.isTrackingEnabled()` — read current tracking state.
  - `TikTokEventsSdk.flush()` — force an immediate flush of queued events. Maps to `explicitlyFlush()` on iOS and `flush()` on Android.
  - `TikTokEventsSdk.updateAccessToken(accessToken:)` — rotate the access token without re-initializing.
- Added Limited Data Use (LDU) mode for privacy-sensitive markets:
  - `TikTokAndroidOptions.enableLimitedDataUse` (maps to `TTConfig.enableLimitedDataUse()`).
  - `TikTokIosOptions.enableLDUMode` (maps to `TikTokConfig.enableLDUMode()`).
- Exposed additional native init-time configuration:
  - `disableAutoEnhancedDataPostbackEvent` on both Android and iOS — opts out of the SDK's Enhanced Data Postback (EDP) collection.
  - `isLowPerformanceDevice` on both Android and iOS — marks the device so the SDK can skip non-essential background work.
  - `flushTimeIntervalSeconds` on Android (maps to `TTConfig.setFlushTimeInterval(int)`).
  - `initialFlushDelaySeconds`, `attUserAuthorizationDelaySeconds`, and `customUserAgent` on iOS (map to `TikTokConfig.initialFlushDelay`, `setDelayForATTUserAuthorizationInSeconds`, and `setCustomUserAgent`).
- Added iOS-only runtime helpers (no-op or `null` on Android):
  - `TikTokEventsSdk.getIdfa()` — returns the current IDFA, or `null` when ATT permission has not been granted.
  - `TikTokEventsSdk.setCustomUserAgent(userAgent:)` — overrides the SDK's User-Agent at runtime.

## 1.2.1

- Added optional `appSecret` field to `TikTokAndroidOptions`. When provided, the SDK initializes via `TTConfig(context, appSecret)` to support TikTok Android SDK v1.3+ event authentication. Falls back to `TTConfig(context)` when omitted (backward compatible). Mirrors the existing iOS `accessToken` support on `TikTokIosOptions`.

## 1.2.0

- Migrated iOS plugin to Flutter 3.38 `UIScene` lifecycle. `TiktokEventsSdkPlugin` now conforms to `FlutterSceneLifeCycleDelegate` and registers on both `addApplicationDelegate` and `addSceneDelegate` for legacy and scene-based hosts. See the [Flutter 3.38 migration guide](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate#migration-guide-for-flutter-plugins).
- **Breaking:** Minimum Flutter version bumped to `3.38.0` and Dart SDK to `^3.10.0`.

## 1.1.5

- Made `externalUserName` and `email` optional in `TikTokIdentifier`. Only `externalId` remains required, matching the native iOS/Android behavior.

## 1.1.4

- Added Swift Package Manager support for iOS.
- Updated TikTok Business SDK to 1.6.1 on both Android and iOS.
- Migrated Android `build.gradle` to Kotlin DSL with conditional `kotlin-android` apply for AGP 9.
- Bumped Android Gradle wrapper to 9.4.1.

## 1.1.3

- Added support for the `hasConsent` parameter in the Dart API, aligning it with the existing Kotlin implementation.

## 1.1.2

- Added `isAlreadyInitialized()` method to check if the TikTok SDK has been initialized.
- Improved `initSdk()` to automatically skip re-initialization during hot restarts.
- Replaced print statements with debugPrint for improved logging consistency across the SDK.
- Refactored and streamlined code structure in TikTok SDK handlers for better readability and maintainability.

## 1.1.1

- Improved iOS logging implementation
- Replaced print statements with debugPrint in Dart code

## 1.1.0

- Updated minimum iOS deployment target to 14.0.
- Added ATT (App Tracking Transparency) support with NSUserTrackingUsageDescription and ATT status checks in StartTrackHandler.swift.
- Implemented user consent validation for the startTrack method on both Android and iOS (GDPR/privacy compliance).
- Streamlined event creation with support for content parameters (TTContentParams) on both Android and iOS.
- Updated example app UI to include TikTok SDK initialization fields and improved user input handling.

## 1.0.9

- **Bug fix:** Resolved issue #11.

## 1.0.8

- **Start Track:** Added startTrack option to SDK initialization.
- **iOS Enhancement:** Added accessToken field support to TikTokIosOptions.
- **Documentation:** Updated documentation to reflect new features, configuration steps, and additional setup notes.

## 1.0.7

- **Update SDK (Android):** Updated TikTok SDK to version 1.3.8 for improved compatibility and performance.

## 1.0.6

- **SDK Downgrade**: Reverted TikTok SDK on Android to a previous stable version due to dependency resolution issues with JitPack.

## 1.0.5

- **Bug fix**: Swift compile error for phoneNumber in iOS channel

## 1.0.4

- **Enhancement**: The phone number field is now nullable, allowing events to be tracked even when a user's phone number is not provided

## 1.0.3

- **iOS:** Added a new configuration field to control the automatic display of the ATT prompt in iOS settings.

## 1.0.2

- **Documentation:** Updated documentation to include JitPack repository for proper dependency resolution.
- **Update SDK:** TikTok SDK to version 1.3.7.

## 1.0.1

- **Bug Fix:** Fixed an issue where setting the "value" property as a Number in iOS caused a crash due to an unexpected type mismatch in the TikTokBusinessSDK. Now, numerical values are properly handled to prevent errors related to isEqualToString:.

## 1.0.0

- **Stable Release:** First stable release of the TikTok Events Manager SDK Flutter Plugin.

## 0.0.3

- **iOS Support:** Added support for iOS, enabling seamless integration of the TikTok Events Manager SDK on Apple devices.
- **Bug Fixes:** Resolved several issues related to event tracking and parameter handling for better stability and performance.

## 0.0.2

- **Documentation:** Enhanced the `README.md`
- **Flutter Environment:** Broadened the minimum Flutter SDK requirement to support more projects.
- **Example Project:** Added a sample Flutter.

## 0.0.1

- TikTok Events Manager SDK Flutter Plugin

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

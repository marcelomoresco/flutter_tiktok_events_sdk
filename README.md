# TikTok Events SDK Flutter Plugin

[![pub package](https://img.shields.io/pub/v/tiktok_events_sdk.svg)](https://pub.dev/packages/tiktok_events_sdk)

A Flutter plugin for integrating the **TikTok Events SDK** into your Flutter app. This plugin allows you to track in-app events, measure user engagement, and optimize your TikTok ad campaigns. It supports both **Android** and **iOS** platforms.

Learn more about TikTok Events SDK:

- [TikTok Events Manager Overview](https://business-api.tiktok.com/portal/docs?id=1739585434183746)
- [TikTok Events SDK for iOS](https://business-api.tiktok.com/portal/docs?id=1739585432134657)
- [TikTok Events SDK for Android](https://business-api.tiktok.com/portal/docs?id=1739585432134658)

---

Thought about permissions and ad_id por alguns segundos
markdown
Copiar
Editar

# TikTok Events SDK for Flutter

A **Flutter** plugin that integrates the [TikTok Events SDK](https://ads.tiktok.com/marketing_api/docs?rid=a0ovbtrvukp&id=1737172325924866) to help you easily initialize the TikTok SDK, identify users, log events, and handle user logout. This plugin supports both **Android** and **iOS**.

---

## Installation

1. Add the dependency in your `pubspec.yaml`:

   ```yaml
   dependencies:
     tiktok_events_sdk: ^x.x.x
   Then, run the following command:
   ```

## Requirements

### Android

Have to added the normal permission `com.google.android.gms.permission.AD_ID` to the SDK's AndroidManifest, to allow the SDK to collect the Android Advertising ID on apps targeting API 33.
If your app is targeting children, you need to revoke this permission to comply with Google's Data policy.

Add the Internet and AD_ID permissions to your AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="com.google.android.gms.permission.AD_ID" />
```

Make sure you are using the latest version of Play Services and Gradle that support com.google.android.gms.permission.AD_ID.

## Features

- **Log Events**: Track user actions such as purchases, add-to-cart, content views, and more for deeper insights into user behavior.
- **Identify user**: Easily associate events with specific users through custom identifiers and parameters.
- **Debug Mode**: Test your event tracking before releasing your app.
- **Logout**: Effortlessly clear user identification across both Android and iOS.

---

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  tiktok_events_sdk: ^1.0.0
```

## Usage

### Initialize the SDK

You must initialize the SDK with your TikTok configuration details. This can be done in main.dart or wherever you set up your app:

```dart
// iOS options example
final iosOptions = TikTokIosOptions(
  disableTracking: false, // true would disable ALL tracking
  disableAutomaticTracking: true,
  disableSKAdNetworkSupport: true,
);

// Android options example
final androidOptions = TikTokAndroidOptions(
  disableAutoStart: true,
  enableAutoIapTrack: true, // enable IAP tracking
  disableAdvertiserIDCollection: false,
);

// Pass these options to the initialize method
await TikTokEventsSdk.initialize(
  androidAppId: 'YOUR_ANDROID_APP_ID',
  tikTokAndroidId: 'YOUR_TIKTOK_ANDROID_ID',
  iosAppId: 'YOUR_IOS_APP_ID',
  tiktokIosId: 'YOUR_TIKTOK_IOS_ID',
  isDebugMode: true,
  logLevel: TikTokLogLevel.debug,
  androidOptions: androidOptions,
  iosOptions: iosOptions,
);
```

### Identify a User

If you need to associate events with a specific user, call identify:

```
await TikTokEventsSdk.identify(
  identifier: TikTokIdentifier(
    externalId: '12345',
    externalUserName: 'john_doe',
    phoneNumber: '+1234567890',
    email: 'john.doe@example.com',
  ),
);
```

### Log Events

The TikTok SDK allows you to log both **custom** and **predefined** events to track user actions within your app. You can add optional metadata such as `eventId` and `properties` to give more context about the event.

**Basic Example:**

```dart
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

/// Log a custom event with only a name
await TikTokEventsSdk.logEvent(
  event: TikTokEvent(
    eventName: 'custom_event_name',
  ),
);
```

#### Passing Additional properties

To enrich your events with extra data (like pricing, product names, user attributes, etc.), you can pass properties. First, create an EventProperties object with key/value pairs of your choice:

```dart
const event = EventProperties(
  value: 200,
  description: 'product price',
  contentId: 'product_page',
  quantity: 1,
  contentType: '',
);
```

```dart
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

await TikTokEventsSdk.logEvent(
      event: TikTokEvent(
        eventName: 'click_product_card',
        eventId: 'event_id',
        properties: const EventProperties(
          contentId: '12345',
          brand: 'Brand Name',
          contentName: 'Category',
          value: 100.0,
          customProperties: {
            'custom_key': 'custom_value',
          },
        ),
      ),
    );
```

### Logout User

When a user logs out of your app, you can clear the identification data:

```dart
await TikTokEventsSdk.logout();
```

## Contributions

🍺 Pull requests are welcome!

Feel free to contribute to this project.

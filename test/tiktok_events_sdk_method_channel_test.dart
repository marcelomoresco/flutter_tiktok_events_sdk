import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('tiktok_events_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return Future.value();
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('TikTokAndroidOptions', () {
    test('appSecret is null by default', () {
      const options = TikTokAndroidOptions();
      expect(options.appSecret, isNull);
    });

    test('appSecret is included in toMap when provided', () {
      const options = TikTokAndroidOptions(appSecret: 'test_secret');
      final map = options.toMap();
      expect(map['appSecret'], 'test_secret');
    });

    test('appSecret is null in toMap when not provided', () {
      const options = TikTokAndroidOptions();
      final map = options.toMap();
      expect(map['appSecret'], isNull);
    });

    test('copyWith preserves appSecret', () {
      const options = TikTokAndroidOptions(appSecret: 'test_secret');
      final copied = options.copyWith(disableAutoStart: true);
      expect(copied.appSecret, 'test_secret');
      expect(copied.disableAutoStart, isTrue);
    });

    test('equality includes appSecret', () {
      const a = TikTokAndroidOptions(appSecret: 'secret1');
      const b = TikTokAndroidOptions(appSecret: 'secret1');
      const c = TikTokAndroidOptions(appSecret: 'secret2');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}

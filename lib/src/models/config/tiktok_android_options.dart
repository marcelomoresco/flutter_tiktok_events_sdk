/// Represents Android-specific configuration options for the TikTok SDK.
///
/// This class allows you to configure various tracking and behavior options for the TikTok SDK
/// on Android devices. Each option controls a specific aspect of the SDK's functionality, such as
/// automatic event tracking, install logging, and advertiser ID collection.
///
/// By default, all options are set to `false`, meaning the corresponding features are enabled.
/// Set an option to `true` to disable the associated feature (except for `enableAutoIapTrack`,
/// which enables a feature when set to `true`).
///
/// Usage example:
/// ```dart
/// TikTokAndroidOptions androidOptions = TikTokAndroidOptions(
///   disableAutoStart: true,
///   enableAutoIapTrack: true,
/// );
/// ```
class TikTokAndroidOptions {
  /// The app secret used for authenticating requests to the TikTok SDK.
  ///
  /// If provided, the SDK will use `TTConfig(context, appSecret)` for initialization.
  /// If `null`, the SDK will use the default `TTConfig(context)` constructor.
  final String? appSecret;

  /// Whether to disable automatic SDK initialization on app startup.
  ///
  /// If `true`, the SDK will not start automatically when the app launches.
  final bool disableAutoStart;

  /// Whether to disable automatic event tracking in the TikTok SDK.
  ///
  /// If `true`, the SDK will not automatically track events like app launches or installs.
  final bool disableAutoEvents;

  /// Whether to disable install logging in the TikTok SDK.
  ///
  /// If `true`, the SDK will not log app installs.
  final bool disableInstallLogging;

  /// Whether to disable launch logging in the TikTok SDK.
  ///
  /// If `true`, the SDK will not log app launches.
  final bool disableLaunchLogging;

  /// Whether to disable retention logging in the TikTok SDK.
  ///
  /// If `true`, the SDK will not log user retention metrics.
  final bool disableRetentionLogging;

  /// Whether to enable automatic in-app purchase (IAP) tracking in the TikTok SDK.
  ///
  /// If `true`, the SDK will automatically track in-app purchases.
  final bool enableAutoIapTrack;

  /// Whether to disable advertiser ID collection in the TikTok SDK.
  ///
  /// If `true`, the SDK will not collect the advertiser ID.
  final bool disableAdvertiserIDCollection;

  /// Whether to enable Limited Data Use (LDU) mode in the TikTok SDK.
  ///
  /// If `true`, the SDK will operate in LDU mode, which restricts data
  /// collection and sharing to comply with privacy regulations such as GDPR
  /// and CCPA. Maps to `TTConfig.enableLimitedDataUse()` on Android.
  final bool enableLimitedDataUse;

  /// Whether to disable Auto Enhanced Data Postback (EDP) event monitoring.
  ///
  /// If `true`, the SDK will not automatically collect enhanced data postback
  /// events. Maps to `TTConfig.disableAutoEnhancedDataPostbackEvent()`.
  final bool disableAutoEnhancedDataPostbackEvent;

  /// Marks the device as a low-performance device.
  ///
  /// When `true`, the SDK will also disable Auto Enhanced Data Postback events
  /// to reduce overhead. Maps to `TTConfig.setIsLowPerformanceDevice(true)`.
  final bool isLowPerformanceDevice;

  /// Custom flush interval in seconds. Defaults to the SDK's own default (15s)
  /// when null. Maps to `TTConfig.setFlushTimeInterval(int)`.
  final int? flushTimeIntervalSeconds;

  /// Creates an instance of [TikTokAndroidOptions] with the specified configuration.
  ///
  /// All options are optional and default to `false`, meaning the corresponding features are enabled
  /// (except for `enableAutoIapTrack`, which is disabled by default).
  const TikTokAndroidOptions({
    this.appSecret,
    this.disableAutoStart = false,
    this.disableAutoEvents = false,
    this.disableInstallLogging = false,
    this.disableLaunchLogging = false,
    this.disableRetentionLogging = false,
    this.enableAutoIapTrack = false,
    this.disableAdvertiserIDCollection = false,
    this.enableLimitedDataUse = false,
    this.disableAutoEnhancedDataPostbackEvent = false,
    this.isLowPerformanceDevice = false,
    this.flushTimeIntervalSeconds,
  });

  /// Creates a copy of this [TikTokAndroidOptions] instance with the specified fields updated.
  ///
  /// This method is useful for modifying specific options without changing the rest.
  ///
  /// Example:
  /// ```dart
  /// TikTokAndroidOptions updatedOptions = androidOptions.copyWith(disableAutoStart: true);
  /// ```
  TikTokAndroidOptions copyWith({
    String? appSecret,
    bool? disableAutoStart,
    bool? disableAutoEvents,
    bool? disableInstallLogging,
    bool? disableLaunchLogging,
    bool? disableRetentionLogging,
    bool? enableAutoIapTrack,
    bool? disableAdvertiserIDCollection,
    bool? enableLimitedDataUse,
    bool? disableAutoEnhancedDataPostbackEvent,
    bool? isLowPerformanceDevice,
    int? flushTimeIntervalSeconds,
  }) {
    return TikTokAndroidOptions(
      appSecret: appSecret ?? this.appSecret,
      disableAutoStart: disableAutoStart ?? this.disableAutoStart,
      disableAutoEvents: disableAutoEvents ?? this.disableAutoEvents,
      disableInstallLogging:
          disableInstallLogging ?? this.disableInstallLogging,
      disableLaunchLogging: disableLaunchLogging ?? this.disableLaunchLogging,
      disableRetentionLogging:
          disableRetentionLogging ?? this.disableRetentionLogging,
      enableAutoIapTrack: enableAutoIapTrack ?? this.enableAutoIapTrack,
      disableAdvertiserIDCollection:
          disableAdvertiserIDCollection ?? this.disableAdvertiserIDCollection,
      enableLimitedDataUse: enableLimitedDataUse ?? this.enableLimitedDataUse,
      disableAutoEnhancedDataPostbackEvent:
          disableAutoEnhancedDataPostbackEvent ??
          this.disableAutoEnhancedDataPostbackEvent,
      isLowPerformanceDevice:
          isLowPerformanceDevice ?? this.isLowPerformanceDevice,
      flushTimeIntervalSeconds:
          flushTimeIntervalSeconds ?? this.flushTimeIntervalSeconds,
    );
  }

  /// Converts this [TikTokAndroidOptions] instance to a map.
  ///
  /// This is useful for serializing the options to JSON or passing them to native code.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> optionsMap = androidOptions.toMap();
  /// ```
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appSecret': appSecret,
      'disableAutoStart': disableAutoStart,
      'disableAutoEvents': disableAutoEvents,
      'disableInstallLogging': disableInstallLogging,
      'disableLaunchLogging': disableLaunchLogging,
      'disableRetentionLogging': disableRetentionLogging,
      'enableAutoIapTrack': enableAutoIapTrack,
      'disableAdvertiserIDCollection': disableAdvertiserIDCollection,
      'enableLimitedDataUse': enableLimitedDataUse,
      'disableAutoEnhancedDataPostbackEvent':
          disableAutoEnhancedDataPostbackEvent,
      'isLowPerformanceDevice': isLowPerformanceDevice,
      'flushTimeIntervalSeconds': flushTimeIntervalSeconds,
    };
  }

  @override
  bool operator ==(covariant TikTokAndroidOptions other) {
    if (identical(this, other)) return true;

    return other.appSecret == appSecret &&
        other.disableAutoStart == disableAutoStart &&
        other.disableAutoEvents == disableAutoEvents &&
        other.disableInstallLogging == disableInstallLogging &&
        other.disableLaunchLogging == disableLaunchLogging &&
        other.disableRetentionLogging == disableRetentionLogging &&
        other.enableAutoIapTrack == enableAutoIapTrack &&
        other.disableAdvertiserIDCollection == disableAdvertiserIDCollection &&
        other.enableLimitedDataUse == enableLimitedDataUse &&
        other.disableAutoEnhancedDataPostbackEvent ==
            disableAutoEnhancedDataPostbackEvent &&
        other.isLowPerformanceDevice == isLowPerformanceDevice &&
        other.flushTimeIntervalSeconds == flushTimeIntervalSeconds;
  }

  @override
  int get hashCode {
    return appSecret.hashCode ^
        disableAutoStart.hashCode ^
        disableAutoEvents.hashCode ^
        disableInstallLogging.hashCode ^
        disableLaunchLogging.hashCode ^
        disableRetentionLogging.hashCode ^
        enableAutoIapTrack.hashCode ^
        disableAdvertiserIDCollection.hashCode ^
        enableLimitedDataUse.hashCode ^
        disableAutoEnhancedDataPostbackEvent.hashCode ^
        isLowPerformanceDevice.hashCode ^
        flushTimeIntervalSeconds.hashCode;
  }
}

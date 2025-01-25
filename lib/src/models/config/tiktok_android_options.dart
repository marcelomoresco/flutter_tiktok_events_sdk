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

  /// Creates an instance of [TikTokAndroidOptions] with the specified configuration.
  ///
  /// All options are optional and default to `false`, meaning the corresponding features are enabled
  /// (except for `enableAutoIapTrack`, which is disabled by default).
  const TikTokAndroidOptions({
    this.disableAutoStart = false,
    this.disableAutoEvents = false,
    this.disableInstallLogging = false,
    this.disableLaunchLogging = false,
    this.disableRetentionLogging = false,
    this.enableAutoIapTrack = false,
    this.disableAdvertiserIDCollection = false,
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
    bool? disableAutoStart,
    bool? disableAutoEvents,
    bool? disableInstallLogging,
    bool? disableLaunchLogging,
    bool? disableRetentionLogging,
    bool? enableAutoIapTrack,
    bool? disableAdvertiserIDCollection,
  }) {
    return TikTokAndroidOptions(
      disableAutoStart: disableAutoStart ?? this.disableAutoStart,
      disableAutoEvents: disableAutoEvents ?? this.disableAutoEvents,
      disableInstallLogging: disableInstallLogging ?? this.disableInstallLogging,
      disableLaunchLogging: disableLaunchLogging ?? this.disableLaunchLogging,
      disableRetentionLogging: disableRetentionLogging ?? this.disableRetentionLogging,
      enableAutoIapTrack: enableAutoIapTrack ?? this.enableAutoIapTrack,
      disableAdvertiserIDCollection: disableAdvertiserIDCollection ?? this.disableAdvertiserIDCollection,
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
      'disableAutoStart': disableAutoStart,
      'disableAutoEvents': disableAutoEvents,
      'disableInstallLogging': disableInstallLogging,
      'disableLaunchLogging': disableLaunchLogging,
      'disableRetentionLogging': disableRetentionLogging,
      'enableAutoIapTrack': enableAutoIapTrack,
      'disableAdvertiserIDCollection': disableAdvertiserIDCollection,
    };
  }

  @override
  bool operator ==(covariant TikTokAndroidOptions other) {
    if (identical(this, other)) return true;

    return other.disableAutoStart == disableAutoStart &&
        other.disableAutoEvents == disableAutoEvents &&
        other.disableInstallLogging == disableInstallLogging &&
        other.disableLaunchLogging == disableLaunchLogging &&
        other.disableRetentionLogging == disableRetentionLogging &&
        other.enableAutoIapTrack == enableAutoIapTrack &&
        other.disableAdvertiserIDCollection == disableAdvertiserIDCollection;
  }

  @override
  int get hashCode {
    return disableAutoStart.hashCode ^
        disableAutoEvents.hashCode ^
        disableInstallLogging.hashCode ^
        disableLaunchLogging.hashCode ^
        disableRetentionLogging.hashCode ^
        enableAutoIapTrack.hashCode ^
        disableAdvertiserIDCollection.hashCode;
  }
}

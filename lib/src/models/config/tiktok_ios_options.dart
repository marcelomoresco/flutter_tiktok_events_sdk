/// Represents iOS-specific configuration options for the TikTok SDK.
///
/// This class allows you to configure various tracking and behavior options for the TikTok SDK
/// on iOS devices. Each option controls a specific aspect of the SDK's functionality, such as
/// automatic tracking, payment tracking, and SKAdNetwork support.
///
/// By default, all options are set to `false`, meaning the corresponding features are enabled.
/// Set an option to `true` to disable the associated feature.
///
/// Usage example:
/// ```dart
/// TikTokIosOptions iosOptions = TikTokIosOptions(
///   disableTracking: true,
///   disablePaymentTracking: true,
/// );
/// ```
class TikTokIosOptions {
  /// Whether to disable all tracking in the TikTok SDK.
  ///
  /// If `true`, all tracking features will be disabled.
  final bool disableTracking;

  /// Whether to disable automatic event tracking in the TikTok SDK.
  ///
  /// If `true`, the SDK will not automatically track events like app launches or installs.
  final bool disableAutomaticTracking;

  /// Whether to disable install tracking in the TikTok SDK.
  ///
  /// If `true`, the SDK will not track app installs.
  final bool disableInstallTracking;

  /// Whether to disable launch tracking in the TikTok SDK.
  ///
  /// If `true`, the SDK will not track app launches.
  final bool disableLaunchTracking;

  /// Whether to disable retention tracking in the TikTok SDK.
  ///
  /// If `true`, the SDK will not track user retention metrics.
  final bool disableRetentionTracking;

  /// Whether to disable payment tracking in the TikTok SDK.
  ///
  /// If `true`, the SDK will not track in-app purchases or payment-related events.
  final bool disablePaymentTracking;

  /// Whether to disable the App Tracking Transparency dialog in the TikTok SDK.
  ///
  /// If `true`, the SDK will not display the App Tracking Transparency dialog to users.
  final bool disableAppTrackingDialog;

  /// Whether to disable SKAdNetwork support in the TikTok SDK.
  ///
  /// If `true`, the SDK will not use SKAdNetwork for attribution tracking.
  final bool disableSKAdNetworkSupport;

  /// Whether to disable the automatic display of the ATT prompt
  ///
  /// If `true`, the SDK will display the ATT prompt on the app start
  final bool displayAtt;

  /// An optional access token used for authenticating requests to the TikTok SDK.
  ///
  /// This token may be required for certain advanced features, such as secure event tracking
  /// or user-specific interactions. If provided, the SDK will include this token
  /// when communicating with TikTok services.
  ///
  /// If `null`, the SDK will operate in a default mode without user-specific authentication.
  final String? accessToken;

  /// Creates an instance of [TikTokIosOptions] with the specified configuration.
  ///
  /// All options are optional and default to `false`, meaning the corresponding features are enabled.
  const TikTokIosOptions({
    this.disableTracking = false,
    this.disableAutomaticTracking = false,
    this.disableInstallTracking = false,
    this.disableLaunchTracking = false,
    this.disableRetentionTracking = false,
    this.disablePaymentTracking = false,
    this.disableAppTrackingDialog = false,
    this.disableSKAdNetworkSupport = false,
    this.displayAtt = true,
    this.accessToken,
  });

  /// Creates a copy of this [TikTokIosOptions] instance with the specified fields updated.
  ///
  /// This method is useful for modifying specific options without changing the rest.
  ///
  /// Example:
  /// ```dart
  /// TikTokIosOptions updatedOptions = iosOptions.copyWith(disablePaymentTracking: true);
  /// ```
  TikTokIosOptions copyWith({
    bool? disableTracking,
    bool? disableAutomaticTracking,
    bool? disableInstallTracking,
    bool? disableLaunchTracking,
    bool? disableRetentionTracking,
    bool? disablePaymentTracking,
    bool? disableAppTrackingDialog,
    bool? disableSKAdNetworkSupport,
    bool? displayAtt,
    String? accessToken,
  }) {
    return TikTokIosOptions(
      disableTracking: disableTracking ?? this.disableTracking,
      disableAutomaticTracking: disableAutomaticTracking ?? this.disableAutomaticTracking,
      disableInstallTracking: disableInstallTracking ?? this.disableInstallTracking,
      disableLaunchTracking: disableLaunchTracking ?? this.disableLaunchTracking,
      disableRetentionTracking: disableRetentionTracking ?? this.disableRetentionTracking,
      disablePaymentTracking: disablePaymentTracking ?? this.disablePaymentTracking,
      disableAppTrackingDialog: disableAppTrackingDialog ?? this.disableAppTrackingDialog,
      disableSKAdNetworkSupport: disableSKAdNetworkSupport ?? this.disableSKAdNetworkSupport,
      displayAtt: displayAtt ?? this.displayAtt,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  /// Converts this [TikTokIosOptions] instance to a map.
  ///
  /// This is useful for serializing the options to JSON or passing them to native code.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> optionsMap = iosOptions.toMap();
  /// ```
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'disableTracking': disableTracking,
      'disableAutomaticTracking': disableAutomaticTracking,
      'disableInstallTracking': disableInstallTracking,
      'disableLaunchTracking': disableLaunchTracking,
      'disableRetentionTracking': disableRetentionTracking,
      'disablePaymentTracking': disablePaymentTracking,
      'disableAppTrackingDialog': disableAppTrackingDialog,
      'disableSKAdNetworkSupport': disableSKAdNetworkSupport,
      'displayAtt': displayAtt,
      'accessToken': accessToken,
    };
  }

  @override
  bool operator ==(covariant TikTokIosOptions other) {
    if (identical(this, other)) return true;

    return other.disableTracking == disableTracking &&
        other.disableAutomaticTracking == disableAutomaticTracking &&
        other.disableInstallTracking == disableInstallTracking &&
        other.disableLaunchTracking == disableLaunchTracking &&
        other.disableRetentionTracking == disableRetentionTracking &&
        other.disablePaymentTracking == disablePaymentTracking &&
        other.disableAppTrackingDialog == disableAppTrackingDialog &&
        other.disableSKAdNetworkSupport == disableSKAdNetworkSupport &&
        other.displayAtt == displayAtt &&
        other.accessToken == accessToken;
  }

  @override
  int get hashCode {
    return disableTracking.hashCode ^
        disableAutomaticTracking.hashCode ^
        disableInstallTracking.hashCode ^
        disableLaunchTracking.hashCode ^
        disableRetentionTracking.hashCode ^
        disablePaymentTracking.hashCode ^
        disableAppTrackingDialog.hashCode ^
        disableSKAdNetworkSupport.hashCode ^
        displayAtt.hashCode ^ 
        accessToken.hashCode;
  }
}

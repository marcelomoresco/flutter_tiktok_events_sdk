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

  /// Timestamp when external ATT consent was obtained from the user.
  ///
  /// **Required when `displayAtt: false`** - Used for compliance audit trails.
  /// This should be an ISO 8601 timestamp (e.g., "2024-01-15T10:30:00Z").
  /// The SDK will reject initialization without this when suppressing ATT.
  ///
  /// Used to prove that consent was obtained through alternative means before
  /// suppressing the SDK's native ATT dialog.
  final String? externalConsentTimestamp;

  /// Status of the external ATT consent.
  ///
  /// **Required when `displayAtt: false`** - Must be "granted" or "denied".
  /// Used to prove that consent was obtained through alternative means.
  /// This creates an audit trail for compliance verification.
  final String? externalConsentStatus;

  /// Optional audit trail identifier for external ATT consent.
  ///
  /// Used for compliance verification and record keeping.
  /// This can be a unique identifier linking to your internal consent records.
  final String? attAuditId;

  /// An optional access token used for authenticating requests to the TikTok SDK.
  ///
  /// This token may be required for certain advanced features, such as secure event tracking
  /// or user-specific interactions. If provided, the SDK will include this token
  /// when communicating with TikTok services.
  ///
  /// If `null`, the SDK will operate in a default mode without user-specific authentication.
  final String? accessToken;

  /// Whether to enable Limited Data Use (LDU) mode in the TikTok SDK.
  ///
  /// If `true`, the SDK will operate in LDU mode, which restricts data
  /// collection and sharing to comply with privacy regulations such as GDPR
  /// and CCPA. Maps to `TikTokConfig.enableLDUMode()` on iOS.
  final bool enableLDUMode;

  /// Whether to disable Auto Enhanced Data Postback (EDP) event collection.
  ///
  /// If `true`, the SDK will not automatically collect enhanced data postback
  /// events. Maps to `TikTokConfig.disableAutoEnhancedDataPostbackEvent()`.
  final bool disableAutoEnhancedDataPostbackEvent;

  /// Marks the device as a low-performance device.
  ///
  /// When `true`, the SDK reduces overhead by skipping non-essential
  /// background work such as Enhanced Data Postback events.
  /// Maps to `TikTokConfig.setIsLowPerformanceDevice(true)`.
  final bool isLowPerformanceDevice;

  /// Initial delay (in seconds) before the SDK performs its first flush.
  /// Maps to `TikTokConfig.initialFlushDelay`. `null` keeps the SDK default.
  final int? initialFlushDelaySeconds;

  /// Delay (in seconds) before the SDK requests App Tracking Transparency
  /// authorization. Maps to
  /// `TikTokConfig.setDelayForATTUserAuthorizationInSeconds(long)`.
  /// `null` keeps the SDK default.
  final int? attUserAuthorizationDelaySeconds;

  /// Custom User-Agent string for SDK network requests.
  /// Maps to `TikTokConfig.setCustomUserAgent(String)` at init time.
  /// `null` keeps the SDK's default user agent.
  final String? customUserAgent;

  /// Creates an instance of [TikTokIosOptions] with the specified configuration.
  ///
  /// All options are optional and default to `false`, meaning the corresponding features are enabled.
  ///
  /// **Security Notice**: When setting `displayAtt: false`, you MUST provide:
  /// - `externalConsentTimestamp`: Timestamp when consent was obtained (ISO 8601 format)
  /// - `externalConsentStatus`: Either "granted" or "denied"
  ///
  /// These are required for compliance verification and audit trails.
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
    this.externalConsentTimestamp,
    this.externalConsentStatus,
    this.attAuditId,
    this.accessToken,
    this.enableLDUMode = false,
    this.disableAutoEnhancedDataPostbackEvent = false,
    this.isLowPerformanceDevice = false,
    this.initialFlushDelaySeconds,
    this.attUserAuthorizationDelaySeconds,
    this.customUserAgent,
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
    String? externalConsentTimestamp,
    String? externalConsentStatus,
    String? attAuditId,
    String? accessToken,
    bool? enableLDUMode,
    bool? disableAutoEnhancedDataPostbackEvent,
    bool? isLowPerformanceDevice,
    int? initialFlushDelaySeconds,
    int? attUserAuthorizationDelaySeconds,
    String? customUserAgent,
  }) {
    return TikTokIosOptions(
      disableTracking: disableTracking ?? this.disableTracking,
      disableAutomaticTracking:
          disableAutomaticTracking ?? this.disableAutomaticTracking,
      disableInstallTracking:
          disableInstallTracking ?? this.disableInstallTracking,
      disableLaunchTracking:
          disableLaunchTracking ?? this.disableLaunchTracking,
      disableRetentionTracking:
          disableRetentionTracking ?? this.disableRetentionTracking,
      disablePaymentTracking:
          disablePaymentTracking ?? this.disablePaymentTracking,
      disableAppTrackingDialog:
          disableAppTrackingDialog ?? this.disableAppTrackingDialog,
      disableSKAdNetworkSupport:
          disableSKAdNetworkSupport ?? this.disableSKAdNetworkSupport,
      displayAtt: displayAtt ?? this.displayAtt,
      externalConsentTimestamp:
          externalConsentTimestamp ?? this.externalConsentTimestamp,
      externalConsentStatus:
          externalConsentStatus ?? this.externalConsentStatus,
      attAuditId: attAuditId ?? this.attAuditId,
      accessToken: accessToken ?? this.accessToken,
      enableLDUMode: enableLDUMode ?? this.enableLDUMode,
      disableAutoEnhancedDataPostbackEvent:
          disableAutoEnhancedDataPostbackEvent ??
          this.disableAutoEnhancedDataPostbackEvent,
      isLowPerformanceDevice:
          isLowPerformanceDevice ?? this.isLowPerformanceDevice,
      initialFlushDelaySeconds:
          initialFlushDelaySeconds ?? this.initialFlushDelaySeconds,
      attUserAuthorizationDelaySeconds:
          attUserAuthorizationDelaySeconds ??
          this.attUserAuthorizationDelaySeconds,
      customUserAgent: customUserAgent ?? this.customUserAgent,
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
      'externalConsentTimestamp': externalConsentTimestamp,
      'externalConsentStatus': externalConsentStatus,
      'attAuditId': attAuditId,
      'accessToken': accessToken,
      'enableLDUMode': enableLDUMode,
      'disableAutoEnhancedDataPostbackEvent':
          disableAutoEnhancedDataPostbackEvent,
      'isLowPerformanceDevice': isLowPerformanceDevice,
      'initialFlushDelaySeconds': initialFlushDelaySeconds,
      'attUserAuthorizationDelaySeconds': attUserAuthorizationDelaySeconds,
      'customUserAgent': customUserAgent,
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
        other.externalConsentTimestamp == externalConsentTimestamp &&
        other.externalConsentStatus == externalConsentStatus &&
        other.attAuditId == attAuditId &&
        other.accessToken == accessToken &&
        other.enableLDUMode == enableLDUMode &&
        other.disableAutoEnhancedDataPostbackEvent ==
            disableAutoEnhancedDataPostbackEvent &&
        other.isLowPerformanceDevice == isLowPerformanceDevice &&
        other.initialFlushDelaySeconds == initialFlushDelaySeconds &&
        other.attUserAuthorizationDelaySeconds ==
            attUserAuthorizationDelaySeconds &&
        other.customUserAgent == customUserAgent;
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
        externalConsentTimestamp.hashCode ^
        externalConsentStatus.hashCode ^
        attAuditId.hashCode ^
        accessToken.hashCode ^
        enableLDUMode.hashCode ^
        disableAutoEnhancedDataPostbackEvent.hashCode ^
        isLowPerformanceDevice.hashCode ^
        initialFlushDelaySeconds.hashCode ^
        attUserAuthorizationDelaySeconds.hashCode ^
        customUserAgent.hashCode;
  }
}

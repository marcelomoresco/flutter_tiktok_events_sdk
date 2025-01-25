/// Enum representing the log levels supported by the TikTok SDK.
///
/// This enum is used to configure the log level of the TikTok SDK on both Android and iOS.
/// Each value corresponds to a specific log level, which controls the amount of information
/// displayed in the SDK logs.
///
/// Usage example:
/// ```dart
/// TikTokLogLevel logLevel = TikTokLogLevel.debug;
/// ```
enum TikTokLogLevel {
  /// No logs will be displayed.
  ///
  /// Corresponds to:
  /// - Android: `NONE`
  /// - iOS: `TikTokLogLevelSuppress`
  none('none'),

  /// Displays only informational logs.
  ///
  /// Corresponds to:
  /// - Android: `INFO`
  /// - iOS: `TikTokLogLevelInfo`
  info('info'),

  /// Displays informational and warning logs.
  ///
  /// Corresponds to:
  /// - Android: `WARN`
  /// - iOS: `TikTokLogLevelWarn`
  warn('warn'),

  /// Displays all logs, including debug information.
  ///
  /// Corresponds to:
  /// - Android: `DEBUG`
  /// - iOS: `TikTokLogLevelDebug`
  debug('debug');

  /// The name of the log level, used to map the value to the native TikTok SDK.
  final String name;

  /// Creates an instance of [TikTokLogLevel] with the provided name.
  ///
  /// The [name] is used to map the log level to the native TikTok SDK.
  const TikTokLogLevel(this.name);
}

/// Represents user identification data for the TikTok SDK.
///
/// This class is used to pass user-related information to the TikTok SDK, such as an external ID,
/// username, phone number, and email. These details help the SDK track user activity and events
/// more accurately.
///
/// All fields are required to ensure complete user identification.
///
/// Usage example:
/// ```dart
/// TikTokIdentifier identifier = TikTokIdentifier(
///   externalId: '12345',
///   externalUserName: 'john_doe',
///   phoneNumber: '+1234567890',
///   email: 'john.doe@example.com',
/// );
/// ```
class TikTokIdentifier {
  /// The external ID of the user, typically a unique identifier from your system.
  final String externalId;

  /// The username of the user, as recognized by your system.
  final String externalUserName;

  /// The phone number of the user, in a valid international format (e.g., `+1234567890`).
  final String phoneNumber;

  /// The email address of the user.
  final String email;

  /// Creates an instance of [TikTokIdentifier] with the required user identification data.
  ///
  /// All fields are required to ensure the TikTok SDK can properly identify the user.
  ///
  /// - [externalId]: A unique identifier for the user in your system.
  /// - [externalUserName]: The username associated with the user.
  /// - [phoneNumber]: The user's phone number in a valid international format.
  /// - [email]: The user's email address.
  TikTokIdentifier({
    required this.externalId,
    required this.externalUserName,
    required this.phoneNumber,
    required this.email,
  });
}

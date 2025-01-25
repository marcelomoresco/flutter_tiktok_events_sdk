/// Represents the standard event names supported by the TikTok SDK.
///
/// This enum is used to specify the type of standard event being logged, such as achieving a level,
/// completing a tutorial, or launching an app. Each event name corresponds to a predefined TikTok SDK event.
///
/// Usage example:
/// ```dart
/// BaseEventName eventName = BaseEventName.login;
/// print(eventName.value); // Output: 'Login'
/// ```
enum BaseEventName {
  /// Triggered when a user achieves a level in a game or app.
  achieveLevel("AchieveLevel"),

  /// Triggered when a user adds payment information.
  addPaymentInfo("AddPaymentInfo"),

  /// Triggered when a user completes a tutorial.
  completeTutorial("CompleteTutorial"),

  /// Triggered when a user creates a group.
  createGroup("CreateGroup"),

  /// Triggered when a user creates a role.
  createRole("CreateRole"),

  /// Triggered when a user generates a lead.
  generateLead("GenerateLead"),

  /// Triggered when a user clicks on an in-app ad.
  inAppAdClick("InAppADClick"),

  /// Triggered when an in-app ad impression occurs.
  inAppAdImpr("InAppAdImpr"),

  /// Triggered when a user installs the app.
  installApp("InstallApp"),

  /// Triggered when a user joins a group.
  joinGroup("JoinGroup"),

  /// Triggered when a user launches the app.
  launchApp("LaunchAPP"),

  /// Triggered when a user applies for a loan.
  loanApplication("LoanApplication"),

  /// Triggered when a user's loan is approved.
  loanApproval("LoanApproval"),

  /// Triggered when a user's loan is disbursed.
  loanDisbursal("LoanDisbursal"),

  /// Triggered when a user logs in.
  login("Login"),

  /// Triggered when a user rates something.
  rate("Rate"),

  /// Triggered when a user registers.
  registration("Registration"),

  /// Triggered when a user performs a search.
  search("Search"),

  /// Triggered when a user spends credits.
  spendCredits("SpendCredits"),

  /// Triggered when a user starts a trial.
  startTrial("StartTrial"),

  /// Triggered when a user subscribes.
  subscribe("Subscribe"),

  /// Triggered when a user unlocks an achievement.
  unlockAchievement("UnlockAchievement");

  /// The value of the event name, used to map the enum to the TikTok SDK.
  final String value;

  /// Creates an instance of [BaseEventName] with the provided value.
  ///
  /// The [value] is used to map the event name to the TikTok SDK.
  const BaseEventName(this.value);

  @override
  String toString() => value;
}

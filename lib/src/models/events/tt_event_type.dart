/// Represents the types of events supported by the TikTok Events SDK.
///
/// This enum is used to specify the type of event being logged, such as adding an item to the cart,
/// completing a purchase, or viewing content. Each event type corresponds to a specific TikTok SDK event.
///
/// Usage example:
/// ```dart
/// TTEventType eventType = TTEventType.addToCart;
/// print(eventType.name); // Output: 'AddToCart'
/// ```
enum TTEventType {
  /// Represents an "Add to Cart" event.
  ///
  /// This event is triggered when a user adds an item to their shopping cart.
  addToCart('AddToCart'),

  /// Represents an "Add to Wishlist" event.
  ///
  /// This event is triggered when a user adds an item to their wishlist.
  addToWishlist('AddToWishlist'),

  /// Represents a "Checkout" event.
  ///
  /// This event is triggered when a user initiates the checkout process.
  checkout('Checkout'),

  /// Represents a "Purchase" event.
  ///
  /// This event is triggered when a user completes a purchase.
  purchase('Purchase'),

  /// Represents a "View Content" event.
  ///
  /// This event is triggered when a user views content, such as a product page.
  viewContent('ViewContent'),

  /// Represents a generic or unspecified event type.
  none('None');

  /// The name of the event type, used to map the enum value to the TikTok SDK.
  final String name;

  /// Creates an instance of [TTEventType] with the provided name.
  ///
  /// The [name] is used to map the event type to the TikTok SDK.
  const TTEventType(this.name);
}

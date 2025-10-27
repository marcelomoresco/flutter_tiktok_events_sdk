import Flutter
import Foundation
import TikTokBusinessSDK

struct SendEventHandler {
    // Protocol describing the common setters available on TikTok event subclasses.
    // We make the specialized event types conform to this protocol so we can
    // configure common properties in a single generic helper. Marking methods
    // @objc optional lets the code compile whether or not the SDK exposes the
    // dedicated setters — we can call them if available and fall back to
    // addProperty when they're not.
    @objc private protocol TikTokCommonEvent {
        @objc optional func setContentId(_ id: String)
        @objc optional func setCurrency(_ currency: TTCurrency)
        @objc optional func setDescription(_ description: String)
        @objc optional func setContentType(_ type: String)
        @objc optional func setValue(_ value: String)
        @objc optional func setContents(_ contents: [TikTokContentParams])

        // Fallback generic property setter. Marked optional to avoid forcing
        // SDK types to implement it at compile-time; most SDK base classes
        // provide an implementation.
        @objc optional func addProperty(withKey key: String, value: Any)
    }

    // Extend the SDK event classes to adopt the local protocol. This is safe
    // when those methods already exist on the SDK types — the extension only
    // declares conformance.
    extension TikTokAddToCartEvent: TikTokCommonEvent {}
    extension TikTokAddToWishlistEvent: TikTokCommonEvent {}
    extension TikTokCheckoutEvent: TikTokCommonEvent {}
    extension TikTokPurchaseEvent: TikTokCommonEvent {}
    extension TikTokViewContentEvent: TikTokCommonEvent {}

    // Generic helper to set the common properties on events.
    private static func configureCommonProperties<T: TikTokCommonEvent>(
        _ event: T,
        parameters: [String: Any]
    ) {
        if let contentId = parameters["content_id"] as? String {
            event.setContentId?(contentId)
            if event.setContentId == nil {
                event.addProperty?(withKey: "content_id", value: contentId)
            }
        }

        if let currencyString = parameters["currency"] as? String,
           let currency = TTCurrency(rawValue: currencyString) {
            event.setCurrency?(currency)
            if event.setCurrency == nil {
                event.addProperty?(withKey: "currency", value: currencyString)
            }
        }

        if let description = parameters["description"] as? String {
            event.setDescription?(description)
            if event.setDescription == nil {
                event.addProperty?(withKey: "description", value: description)
            }
        }

        if let contentType = parameters["content_type"] as? String {
            event.setContentType?(contentType)
            if event.setContentType == nil {
                event.addProperty?(withKey: "content_type", value: contentType)
            }
        }

        if let valueNumber = parameters["value"] as? NSNumber {
            let valueString = "\(valueNumber.doubleValue)"
            event.setValue?(valueString)
            if event.setValue == nil {
                event.addProperty?(withKey: "value", value: valueNumber)
            }
        } else if let valueString = parameters["value"] as? String,
                  let value = Double(valueString) {
            let ds = "\(value)"
            event.setValue?(ds)
            if event.setValue == nil {
                event.addProperty?(withKey: "value", value: valueString)
            }
        }

        // Build content parameters using TikTokContentParams
        let contentParams = TikTokContentParams()
        var hasContentParams = false

        // Extract content-related fields from parameters
        if let contentId = parameters["content_id"] as? String {
            contentParams.contentId = contentId
            hasContentParams = true
        }

        if let contentCategory = parameters["content_category"] as? String {
            contentParams.contentCategory = contentCategory
            hasContentParams = true
        }

        if let contentName = parameters["content_name"] as? String {
            contentParams.contentName = contentName
            hasContentParams = true
        }

        if let brand = parameters["brand"] as? String {
            contentParams.brand = brand
            hasContentParams = true
        }

        // Handle price with multiple type conversions
        if let price = parameters["price"] as? Double {
            contentParams.price = NSNumber(value: price)
            hasContentParams = true
        } else if let price = parameters["price"] as? Int {
            contentParams.price = NSNumber(value: price)
            hasContentParams = true
        } else if let price = parameters["price"] as? NSNumber {
            contentParams.price = price
            hasContentParams = true
        } else if let priceString = parameters["price"] as? String, let price = Double(priceString) {
            contentParams.price = NSNumber(value: price)
            hasContentParams = true
        }

        // Handle quantity with multiple type conversions
        if let quantity = parameters["quantity"] as? Int {
            contentParams.quantity = quantity
            hasContentParams = true
        } else if let quantity = parameters["quantity"] as? Double {
            contentParams.quantity = Int(quantity)
            hasContentParams = true
        } else if let quantityString = parameters["quantity"] as? String, let quantity = Int(quantityString) {
            contentParams.quantity = quantity
            hasContentParams = true
        }

        // Set contents if we have any content parameters
        if hasContentParams {
            event.setContents?([contentParams])
            // Fallback: if setContents is not available, add properties individually
            if event.setContents == nil {
                if let contentId = parameters["content_id"] as? String {
                    event.addProperty?(withKey: "content_id", value: contentId)
                }
                if let contentCategory = parameters["content_category"] as? String {
                    event.addProperty?(withKey: "content_category", value: contentCategory)
                }
                if let contentName = parameters["content_name"] as? String {
                    event.addProperty?(withKey: "content_name", value: contentName)
                }
                if let brand = parameters["brand"] as? String {
                    event.addProperty?(withKey: "brand", value: brand)
                }
                // Handle price fallback
                if let price = parameters["price"] as? Double {
                    event.addProperty?(withKey: "price", value: NSNumber(value: price))
                } else if let price = parameters["price"] as? Int {
                    event.addProperty?(withKey: "price", value: NSNumber(value: price))
                } else if let price = parameters["price"] as? NSNumber {
                    event.addProperty?(withKey: "price", value: price)
                }
                // Handle quantity fallback
                if let quantity = parameters["quantity"] as? Int {
                    event.addProperty?(withKey: "quantity", value: NSNumber(value: quantity))
                } else if let quantity = parameters["quantity"] as? Double {
                    event.addProperty?(withKey: "quantity", value: NSNumber(value: Int(quantity)))
                }
            }
        }
    }

    // Cached regex for event name validation - compiled once and reused for performance
    private static let eventNameRegex: NSRegularExpression? = {
        do {
            return try NSRegularExpression(pattern: "^[a-zA-Z0-9_]+$", options: [])
        } catch {
            // This should never fail with the static pattern, but handle gracefully
            return nil
        }
    }()

    /// Validate event name format - only letters, numbers, and underscore allowed
    /// - Parameter eventName: The event name to validate
    /// - Returns: `true` if the event name is valid, `false` otherwise
    private static func isValidEventName(_ eventName: String) -> Bool {
        // Reject empty strings
        guard !eventName.isEmpty else {
            return false
        }

        // Use cached regex for performance
        guard let regex = eventNameRegex else {
            return false
        }

        let range = NSRange(location: 0, length: eventName.utf16.count)
        return regex.firstMatch(in: eventName, options: [], range: range) != nil
    }

    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let eventName = args["event_name"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        // Validate event name format (letters, numbers, and underscore only)
        if !isValidEventName(eventName) {
            result(FlutterError(
                code: "INVALID_EVENT_NAME",
                message: "Event name contains invalid characters. Use only letters, numbers, and underscore.",
                details: nil
            ))
            return
        }

        let eventTypeName = args["event_type_name"] as? String ?? "none"

        // Validate event type name format (letters, numbers, and underscore only)
        if !isValidEventName(eventTypeName) {
            result(FlutterError(
                code: "INVALID_EVENT_TYPE_NAME",
                message: "Event type name contains invalid characters. Use only letters, numbers, and underscore.",
                details: nil
            ))
            return
        }

        let parameters = args["parameters"] as? [String: Any] ?? [:]
        let eventId = args["event_id"] as? String

        do {
            let event: TikTokBaseEvent = createEvent(eventTypeName: eventTypeName, eventName: eventName, eventId: eventId, parameters: parameters)
            TikTokBusiness.trackTTEvent(event)
            result("Event '\(eventTypeName)' sent successfully!")
        } catch {
            // Show detailed error in debug mode, generic error in production
            TikTokErrorHelper.emitSecureError(
                code: "EVENT_ERROR",
                genericMessage: "An error occurred while sending the event",
                error: error,
                result: result
            )
        }
    }

    private static func createEvent(eventTypeName: String, eventName: String, eventId: String?, parameters: [String: Any]) -> TikTokBaseEvent {
        // Normalize event type name: remove underscores and lowercase to allow
        // inputs like "AddToCart", "add_to_cart", "addtocart", etc.
        let normalized = eventTypeName.replacingOccurrences(of: "_", with: "").lowercased()

        switch normalized {
        case "addtocart":
            return createAddToCartEvent(eventId: eventId, parameters: parameters)
        case "addtowishlist":
            return createAddToWishlistEvent(eventId: eventId, parameters: parameters)
        case "checkout":
            return createCheckoutEvent(eventId: eventId, parameters: parameters)
        case "purchase":
            return createPurchaseEvent(eventId: eventId, parameters: parameters)
        case "viewcontent":
            return createViewContentEvent(eventId: eventId, parameters: parameters)
        case "none":
            return createBaseTikTokEvent(eventName: eventName, eventId: eventId, parameters: parameters)
        default:
            return createBaseTikTokEvent(eventName: eventName, eventId: eventId, parameters: parameters)
        }
    }

    private static func createBaseTikTokEvent(
        eventName: String,
        eventId: String?,
        parameters: [String: Any]
    ) -> TikTokBaseEvent {
        let event = TikTokBaseEvent(eventName: eventName, eventId: eventId)
        for (key, value) in parameters {
            // Prefer sending native numeric/bool types. For other complex
            // values attempt JSON serialization to a string so the SDK can
            // accept a stable representation.
            if let number = value as? NSNumber {
                event.addProperty(withKey: key, value: number)
            } else if let bool = value as? Bool {
                event.addProperty(withKey: key, value: bool)
            } else if let string = value as? String {
                event.addProperty(withKey: key, value: string)
            } else {
                // Attempt to JSON-serialize complex objects into a string.
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    event.addProperty(withKey: key, value: jsonString)
                } else {
                    // Fallback to string description
                    event.addProperty(withKey: key, value: "\(value)")
                }
            }
        }
        return event
    }

    private static func createAddToCartEvent(
        eventId: String?,
        parameters: [String: Any]
    ) -> TikTokAddToCartEvent {
        let event: TikTokAddToCartEvent
        if let id = eventId {
            event = TikTokAddToCartEvent(eventId: id)
        } else {
            event = TikTokAddToCartEvent()
        }

        configureCommonProperties(event, parameters: parameters)
        return event
    }

    private static func createAddToWishlistEvent(
        eventId: String?,
        parameters: [String: Any]
    ) -> TikTokAddToWishlistEvent {
        let event: TikTokAddToWishlistEvent
        if let id = eventId {
            event = TikTokAddToWishlistEvent(eventId: id)
        } else {
            event = TikTokAddToWishlistEvent()
        }

        configureCommonProperties(event, parameters: parameters)
        return event
    }

    private static func createCheckoutEvent(
        eventId: String?,
        parameters: [String: Any]
    ) -> TikTokCheckoutEvent {
        let event: TikTokCheckoutEvent
        if let id = eventId {
            event = TikTokCheckoutEvent(eventId: id)
        } else {
            event = TikTokCheckoutEvent()
        }

        configureCommonProperties(event, parameters: parameters)
        return event
    }

    private static func createPurchaseEvent(
        eventId: String?,
        parameters: [String: Any]
    ) -> TikTokPurchaseEvent {
        let event: TikTokPurchaseEvent
        if let id = eventId {
            event = TikTokPurchaseEvent(eventId: id)
        } else {
            event = TikTokPurchaseEvent()
        }

        configureCommonProperties(event, parameters: parameters)
        return event
    }

    private static func createViewContentEvent(
        eventId: String?,
        parameters: [String: Any]
    ) -> TikTokViewContentEvent {
        let event: TikTokViewContentEvent
        if let id = eventId {
            event = TikTokViewContentEvent(eventId: id)
        } else {
            event = TikTokViewContentEvent()
        }

        configureCommonProperties(event, parameters: parameters)
        return event
    }
}

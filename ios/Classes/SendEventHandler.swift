import Flutter
import TikTokBusinessSDK

struct SendEventHandler {
    // Protocol describing the common setters available on TikTok event subclasses.
    // We make the specialized event types conform to this protocol so we can
    // configure common properties in a single generic helper.
    private protocol TikTokCommonEvent {
        func setContentId(_ id: String)
        func setCurrency(_ currency: TTCurrency)
        func setDescription(_ description: String)
        func setContentType(_ type: String)
        func setValue(_ value: String)
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
            event.setContentId(contentId)
        }

        if let currencyString = parameters["currency"] as? String,
           let currency = TTCurrency(rawValue: currencyString) {
            event.setCurrency(currency)
        }

        if let description = parameters["description"] as? String {
            event.setDescription(description)
        }

        if let contentType = parameters["content_type"] as? String {
            event.setContentType(contentType)
        }

        if let valueNumber = parameters["value"] as? NSNumber {
            event.setValue("\(valueNumber.doubleValue)")
        } else if let valueString = parameters["value"] as? String,
                  let value = Double(valueString) {
            event.setValue("\(value)")
        }
    }

    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
                guard let args = call.arguments as? [String: Any],
                            let eventName = args["event_name"] as? String else {
                        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

    let eventTypeName = args["event_type_name"] as? String ?? "none"
        let parameters = args["parameters"] as? [String: Any] ?? [:]
        let eventId = args["event_id"] as? String

        do {
            let event: TikTokBaseEvent = createEvent(eventTypeName: eventTypeName, eventName: eventName, eventId: eventId, parameters: parameters)
            TikTokBusiness.trackTTEvent(event)
            result("Event '\(eventTypeName)' sent successfully!")
        } catch {
            result(FlutterError(code: "EVENT_ERROR", message: "Error sending the event: \(error.localizedDescription)", details: nil))
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

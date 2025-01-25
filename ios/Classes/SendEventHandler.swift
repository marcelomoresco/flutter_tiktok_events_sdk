import Flutter
import TikTokBusinessSDK

struct SendEventHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Argumentos inválidos", details: nil))
            return
        }

        let eventTypeName = args["event_type_name"] as? String ?? "none"
        let parameters = args["parameters"] as? [String: Any] ?? [:]
        let eventId = args["event_id"] as? String

        do {
            let event: TikTokBaseEvent
            switch eventTypeName {
            case "AddToCart":
                event = try createAddToCartEvent(eventId: eventId, parameters: parameters)
            case "AddToWishlist":
                event = try createAddToWishlistEvent(eventId: eventId, parameters: parameters)
            case "Checkout":
                event = try createCheckoutEvent(eventId: eventId, parameters: parameters)
            case "Purchase":
                event = try createPurchaseEvent(eventId: eventId, parameters: parameters)
            case "ViewContent":
                event = try createViewContentEvent(eventId: eventId, parameters: parameters)
            default:
                event = try createBaseEvent(eventName: eventTypeName, eventId: eventId, parameters: parameters)
            }

            TikTokBusiness.trackTTEvent(event)
            result("Evento '\(eventTypeName)' enviado com sucesso!")
        } catch {
            result(FlutterError(code: "EVENT_ERROR", message: "Erro ao enviar o evento: \(error.localizedDescription)", details: nil))
        }
    }

    private static func createBaseEvent(
        eventName: String,
        eventId: String?,
        parameters: [String: Any]
    ) throws -> TikTokBaseEvent {
        let event = TikTokBaseEvent(name: eventName)
        if let eventId = eventId {
            event.eventId = eventId
        }

        for (key, value) in parameters {
            event.properties[key] = "\(value)"
        }

        return event
    }

    private static func createAddToCartEvent(
        eventId: String?,
        parameters: [String: Any]
    ) throws -> TikTokAddToCartEvent {
        let event = eventId != nil
            ? TikTokAddToCartEvent(eventId: eventId!)
            : TikTokAddToCartEvent()

        if let contentId = parameters["content_id"] as? String {
            event.setContentId(contentId)
        }
        if let currencyString = parameters["currency"] as? String {
            let currency: TTCurrency? = TTCurrency(rawValue: currencyString)
            if let currency = currency {
                event.setCurrency(currency)
            }
        }
        if let description = parameters["description"] as? String {
            event.setDescription(description)
        }
        if let contentType = parameters["content_type"] as? String {
            event.setContentType(contentType)
        }
        if let value = parameters["value"] as? String {
            event.setValue(value)
        }

        return event
    }

    private static func createAddToWishlistEvent(
        eventId: String?,
        parameters: [String: Any]
    ) throws -> TikTokAddToWishlistEvent {
        let event = eventId != nil
            ? TikTokAddToWishlistEvent(eventId: eventId!)
            : TikTokAddToWishlistEvent()

        if let contentId = parameters["content_id"] as? String {
            event.setContentId(contentId)
        }
        if let currencyString = parameters["currency"] as? String {
            let currency: TTCurrency? = TTCurrency(rawValue: currencyString)
            if let currency = currency {
                event.setCurrency(currency)
            }
        }
        if let description = parameters["description"] as? String {
            event.setDescription(description)
        }
        if let contentType = parameters["content_type"] as? String {
            event.setContentType(contentType)
        }
        if let value = parameters["value"] as? String {
            event.setValue(value)
        }

        return event
    }

    private static func createCheckoutEvent(
        eventId: String?,
        parameters: [String: Any]
    ) throws -> TikTokCheckoutEvent {
        let event = eventId != nil
            ? TikTokCheckoutEvent(eventId: eventId!)
            : TikTokCheckoutEvent()

        if let contentId = parameters["content_id"] as? String {
            event.setContentId(contentId)
        }
        if let currencyString = parameters["currency"] as? String {
            let currency: TTCurrency? = TTCurrency(rawValue: currencyString)
            if let currency = currency {
                event.setCurrency(currency)
            }
        }
        if let description = parameters["description"] as? String {
            event.setDescription(description)
        }
        if let contentType = parameters["content_type"] as? String {
            event.setContentType(contentType)
        }
        if let value = parameters["value"] as? String {
            event.setValue(value)
        }

        return event
    }

    private static func createPurchaseEvent(
        eventId: String?,
        parameters: [String: Any]
    ) throws -> TikTokPurchaseEvent {
        let event = eventId != nil
            ? TikTokPurchaseEvent(eventId: eventId!)
            : TikTokPurchaseEvent()

        if let contentId = parameters["content_id"] as? String {
            event.setContentId(contentId)
        }
        if let currencyString = parameters["currency"] as? String {
            let currency: TTCurrency? = TTCurrency(rawValue: currencyString)
            if let currency = currency {
                event.setCurrency(currency)
            }
        }
        if let description = parameters["description"] as? String {
            event.setDescription(description)
        }
        if let contentType = parameters["content_type"] as? String {
            event.setContentType(contentType)
        }
        if let value = parameters["value"] as? String {
            event.setValue(value)
        }

        return event
    }

    private static func createViewContentEvent(
        eventId: String?,
        parameters: [String: Any]
    ) throws -> TikTokViewContentEvent {
        let event = eventId != nil
            ? TikTokViewContentEvent(eventId: eventId!)
            : TikTokViewContentEvent()

        if let contentId = parameters["content_id"] as? String {
            event.setContentId(contentId)
        }
        if let currencyString = parameters["currency"] as? String {
            let currency: TTCurrency? = TTCurrency(rawValue: currencyString)
            if let currency = currency {
                event.setCurrency(currency)
            }
        }
        if let description = parameters["description"] as? String {
            event.setDescription(description)
        }
        if let contentType = parameters["content_type"] as? String {
            event.setContentType(contentType)
        }
        if let value = parameters["value"] as? String {
            event.setValue(value)
        }

        return event
    }
}

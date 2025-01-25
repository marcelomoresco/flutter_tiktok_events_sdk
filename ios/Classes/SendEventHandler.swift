import Flutter
import TikTokBusinessSDK

struct SendEventHandler {
    static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let eventName = args["event_name"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Argumentos inválidos", details: nil))
            return
        }

        let eventTypeName = args["event_type_name"] as? String ?? "none"
        let parameters = args["parameters"] as? [String: Any] ?? [:]
        let eventId = args["event_id"] as? String

        do {
            let event: TikTokBaseEvent = createEvent(eventTypeName: eventTypeName,eventName: eventName, eventId: eventId, parameters: parameters)
            TikTokBusiness.trackTTEvent(event)
            result("Evento '\(eventTypeName)' enviado com sucesso!")
        } catch {
            result(FlutterError(code: "EVENT_ERROR", message: "Erro ao enviar o evento: \(error.localizedDescription)", details: nil))
        }
    }

    private static func createEvent(eventTypeName: String, eventName: String, eventId: String?, parameters: [String: Any]) -> TikTokBaseEvent {
switch eventTypeName {
        case "AddToCart":
            return createAddToCartEvent(eventId: eventId, parameters: parameters)
        case "AddToWishlist":
            return createAddToWishlistEvent(eventId: eventId, parameters: parameters)
        case "Checkout":
            return createCheckoutEvent(eventId: eventId, parameters: parameters)
        case "Purchase":
            return createPurchaseEvent(eventId: eventId, parameters: parameters)
        case "ViewContent":
            return createViewContentEvent(eventId: eventId, parameters: parameters)
        case "None":
            return createBaseTikTokEvent(eventName:eventName, eventId: eventId,parameters: parameters)
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
            event.addProperty(withKey: key, value: value)
        }
                
        return event
    }

    private static func createAddToCartEvent(
        eventId: String?,
        parameters: [String: Any]
    ) -> TikTokAddToCartEvent {
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
    ) -> TikTokAddToWishlistEvent {
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
    ) -> TikTokCheckoutEvent {
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
    ) -> TikTokPurchaseEvent {
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
    ) -> TikTokViewContentEvent {
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

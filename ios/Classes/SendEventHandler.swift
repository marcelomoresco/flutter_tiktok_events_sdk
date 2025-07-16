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
            let stringValue: Any

            if let number = value as? NSNumber {
                stringValue = "\(number)"
            } else {
                stringValue = value
            }
            
            event.addProperty(withKey: key, value: stringValue)

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
        
         if let valueString = parameters["value"] as? String, let value = Double(valueString) {
            event.setValue("\(value)")
        }

        let eventContent = TikTokContentParams()
        // Replace hardcoded values with optional values from parameters
        if let price = parameters["price"] as? Double {
            print("Setting price (from Double): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? Int {
            print("Setting price (from Int): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? NSNumber {
            print("Setting price (from NSNumber): \(price)")
            eventContent.price = price
        } else if let priceString = parameters["price"] as? String, let price = Double(priceString) {
            print("Setting price (from String): \(price)")
            eventContent.price = NSNumber(value: price)
        } else {
            print("Setting default price: 0.0")
            eventContent.price = NSNumber(value: 0.0)
        }

        if let quantity = parameters["quantity"] as? Int {
            print("Setting quantity (from Int): \(quantity)")
            eventContent.quantity = quantity
        } else if let quantity = parameters["quantity"] as? Double {
            print("Setting quantity (from Double): \(Int(quantity))")
            eventContent.quantity = Int(quantity)
        } else if let quantityString = parameters["quantity"] as? String, let quantity = Int(quantityString) {
            print("Setting quantity (from String): \(quantity)")
            eventContent.quantity = quantity
        } else {
            print("Setting default quantity: 1")
            eventContent.quantity = 1
        }

        if let brand = parameters["brand"] as? String {
            print("Setting brand: \(brand)")
            eventContent.brand = brand
        } else {
            // Set default value if missing
            print("Setting default brand: 'unknown'")
            eventContent.brand = "unknown"
        }

        if let contentName = parameters["content_name"] as? String {
            print("Setting contentName: \(contentName)")
            eventContent.contentName = contentName
        } else {
            // Set default value if missing
            print("Setting default contentName: 'Product'")
            eventContent.contentName = "Product"
        }

        if let contentCategory = parameters["content_category"] as? String {
            print("Setting contentCategory: \(contentCategory)")
            eventContent.contentCategory = contentCategory
        } else {
            // Set default value if missing
            print("Setting default contentCategory: 'Product'")
            eventContent.contentCategory = "Product"
        }

        event.setContents([eventContent])
        
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
        
        if let valueString = parameters["value"] as? String, let value = Double(valueString) {
            event.setValue("\(value)")
        }

        let eventContent = TikTokContentParams()
        // Replace hardcoded values with optional values from parameters
        if let price = parameters["price"] as? Double {
            print("Setting price (from Double): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? Int {
            print("Setting price (from Int): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? NSNumber {
            print("Setting price (from NSNumber): \(price)")
            eventContent.price = price
        } else if let priceString = parameters["price"] as? String, let price = Double(priceString) {
            print("Setting price (from String): \(price)")
            eventContent.price = NSNumber(value: price)
        } else {
            print("Setting default price: 0.0")
            eventContent.price = NSNumber(value: 0.0)
        }

        if let quantity = parameters["quantity"] as? Int {
            print("Setting quantity (from Int): \(quantity)")
            eventContent.quantity = quantity
        } else if let quantity = parameters["quantity"] as? Double {
            print("Setting quantity (from Double): \(Int(quantity))")
            eventContent.quantity = Int(quantity)
        } else if let quantityString = parameters["quantity"] as? String, let quantity = Int(quantityString) {
            print("Setting quantity (from String): \(quantity)")
            eventContent.quantity = quantity
        } else {
            print("Setting default quantity: 1")
            eventContent.quantity = 1
        }

        if let brand = parameters["brand"] as? String {
            print("Setting brand: \(brand)")
            eventContent.brand = brand
        } else {
            // Set default value if missing
            print("Setting default brand: 'unknown'")
            eventContent.brand = "unknown"
        }

        if let contentName = parameters["content_name"] as? String {
            print("Setting contentName: \(contentName)")
            eventContent.contentName = contentName
        } else {
            // Set default value if missing
            print("Setting default contentName: 'Product'")
            eventContent.contentName = "Product"
        }

        if let contentCategory = parameters["content_category"] as? String {
            print("Setting contentCategory: \(contentCategory)")
            eventContent.contentCategory = contentCategory
        } else {
            // Set default value if missing
            print("Setting default contentCategory: 'Product'")
            eventContent.contentCategory = "Product"
        }

        event.setContents([eventContent])

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
         if let valueString = parameters["value"] as? String, let value = Double(valueString) {
            event.setValue("\(value)")
        }

        let eventContent = TikTokContentParams()
        // Replace hardcoded values with optional values from parameters
        if let price = parameters["price"] as? Double {
            print("Setting price (from Double): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? Int {
            print("Setting price (from Int): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? NSNumber {
            print("Setting price (from NSNumber): \(price)")
            eventContent.price = price
        } else if let priceString = parameters["price"] as? String, let price = Double(priceString) {
            print("Setting price (from String): \(price)")
            eventContent.price = NSNumber(value: price)
        } else {
            print("Setting default price: 0.0")
            eventContent.price = NSNumber(value: 0.0)
        }

        if let quantity = parameters["quantity"] as? Int {
            print("Setting quantity (from Int): \(quantity)")
            eventContent.quantity = quantity
        } else if let quantity = parameters["quantity"] as? Double {
            print("Setting quantity (from Double): \(Int(quantity))")
            eventContent.quantity = Int(quantity)
        } else if let quantityString = parameters["quantity"] as? String, let quantity = Int(quantityString) {
            print("Setting quantity (from String): \(quantity)")
            eventContent.quantity = quantity
        } else {
            print("Setting default quantity: 1")
            eventContent.quantity = 1
        }

        if let brand = parameters["brand"] as? String {
            print("Setting brand: \(brand)")
            eventContent.brand = brand
        } else {
            // Set default value if missing
            print("Setting default brand: 'unknown'")
            eventContent.brand = "unknown"
        }

        if let contentName = parameters["content_name"] as? String {
            print("Setting contentName: \(contentName)")
            eventContent.contentName = contentName
        } else {
            // Set default value if missing
            print("Setting default contentName: 'Product'")
            eventContent.contentName = "Product"
        }

        if let contentCategory = parameters["content_category"] as? String {
            print("Setting contentCategory: \(contentCategory)")
            eventContent.contentCategory = contentCategory
        } else {
            // Set default value if missing
            print("Setting default contentCategory: 'Product'")
            eventContent.contentCategory = "Product"
        }

        event.setContents([eventContent])

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
         if let valueString = parameters["value"] as? String, let value = Double(valueString) {
            event.setValue("\(value)")
        }

        let eventContent = TikTokContentParams()
        // Replace hardcoded values with optional values from parameters
        if let price = parameters["price"] as? Double {
            print("Setting price (from Double): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? Int {
            print("Setting price (from Int): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? NSNumber {
            print("Setting price (from NSNumber): \(price)")
            eventContent.price = price
        } else if let priceString = parameters["price"] as? String, let price = Double(priceString) {
            print("Setting price (from String): \(price)")
            eventContent.price = NSNumber(value: price)
        } else {
            print("Setting default price: 0.0")
            eventContent.price = NSNumber(value: 0.0)
        }

        if let quantity = parameters["quantity"] as? Int {
            print("Setting quantity (from Int): \(quantity)")
            eventContent.quantity = quantity
        } else if let quantity = parameters["quantity"] as? Double {
            print("Setting quantity (from Double): \(Int(quantity))")
            eventContent.quantity = Int(quantity)
        } else if let quantityString = parameters["quantity"] as? String, let quantity = Int(quantityString) {
            print("Setting quantity (from String): \(quantity)")
            eventContent.quantity = quantity
        } else {
            print("Setting default quantity: 1")
            eventContent.quantity = 1
        }

        if let brand = parameters["brand"] as? String {
            print("Setting brand: \(brand)")
            eventContent.brand = brand
        } else {
            // Set default value if missing
            print("Setting default brand: 'unknown'")
            eventContent.brand = "unknown"
        }

        if let contentName = parameters["content_name"] as? String {
            print("Setting contentName: \(contentName)")
            eventContent.contentName = contentName
        } else {
            // Set default value if missing
            print("Setting default contentName: 'Product'")
            eventContent.contentName = "Product"
        }

        if let contentCategory = parameters["content_category"] as? String {
            print("Setting contentCategory: \(contentCategory)")
            eventContent.contentCategory = contentCategory
        } else {
            // Set default value if missing
            print("Setting default contentCategory: 'Product'")
            eventContent.contentCategory = "Product"
        }

        event.setContents([eventContent])

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
         if let valueString = parameters["value"] as? String, let value = Double(valueString) {
            event.setValue("\(value)")
        }

        let eventContent = TikTokContentParams()
        // Replace hardcoded values with optional values from parameters
        if let price = parameters["price"] as? Double {
            print("Setting price (from Double): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? Int {
            print("Setting price (from Int): \(price)")
            eventContent.price = NSNumber(value: price)
        } else if let price = parameters["price"] as? NSNumber {
            print("Setting price (from NSNumber): \(price)")
            eventContent.price = price
        } else if let priceString = parameters["price"] as? String, let price = Double(priceString) {
            print("Setting price (from String): \(price)")
            eventContent.price = NSNumber(value: price)
        } else {
            print("Setting default price: 0.0")
            eventContent.price = NSNumber(value: 0.0)
        }

        if let quantity = parameters["quantity"] as? Int {
            print("Setting quantity (from Int): \(quantity)")
            eventContent.quantity = quantity
        } else if let quantity = parameters["quantity"] as? Double {
            print("Setting quantity (from Double): \(Int(quantity))")
            eventContent.quantity = Int(quantity)
        } else if let quantityString = parameters["quantity"] as? String, let quantity = Int(quantityString) {
            print("Setting quantity (from String): \(quantity)")
            eventContent.quantity = quantity
        } else {
            print("Setting default quantity: 1")
            eventContent.quantity = 1
        }

        if let brand = parameters["brand"] as? String {
            print("Setting brand: \(brand)")
            eventContent.brand = brand
        } else {
            // Set default value if missing
            print("Setting default brand: 'unknown'")
            eventContent.brand = "unknown"
        }

        if let contentName = parameters["content_name"] as? String {
            print("Setting contentName: \(contentName)")
            eventContent.contentName = contentName
        } else {
            // Set default value if missing
            print("Setting default contentName: 'Product'")
            eventContent.contentName = "Product"
        }

        if let contentCategory = parameters["content_category"] as? String {
            print("Setting contentCategory: \(contentCategory)")
            eventContent.contentCategory = contentCategory
        } else {
            // Set default value if missing
            print("Setting default contentCategory: 'Product'")
            eventContent.contentCategory = "Product"
        }

        event.setContents([eventContent])

        return event
    }
}

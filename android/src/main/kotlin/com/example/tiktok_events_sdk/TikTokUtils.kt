package com.example.tiktok_events_sdk

import com.tiktok.TikTokBusinessSdk
import com.tiktok.TikTokBusinessSdk.TTConfig
import com.tiktok.appevents.base.TTBaseEvent
import com.tiktok.appevents.contents.TTAddToCartEvent
import com.tiktok.appevents.contents.TTAddToWishlistEvent
import com.tiktok.appevents.contents.TTCheckoutEvent
import com.tiktok.appevents.contents.TTContentParams
import com.tiktok.appevents.contents.TTContentsEvent
import com.tiktok.appevents.contents.TTContentsEventConstants
import com.tiktok.appevents.contents.TTPurchaseEvent
import com.tiktok.appevents.contents.TTViewContentEvent

object TikTokUtils {
    /**
     * Configures TTConfig with provided options.
     */
    fun configureAndroidOptions(
        options: Map<String, Any>,
        ttConfig: TTConfig,
    ): TTConfig =
        ttConfig.apply {
            if (options["disableAutoStart"] as? Boolean == true) disableAutoStart()
            if (options["disableAutoEvents"] as? Boolean == true) disableAutoEvents()
            if (options["disableInstallLogging"] as? Boolean == true) disableInstallLogging()
            if (options["disableLaunchLogging"] as? Boolean == true) disableLaunchLogging()
            if (options["disableRetentionLogging"] as? Boolean == true) {
                disableRetentionLogging()
            }
            if (options["enableAutoIapTrack"] as? Boolean == true) enableAutoIapTrack()
            if (options["disableAdvertiserIDCollection"] as? Boolean == true) {
                disableAdvertiserIDCollection()
            }
        }

    /** Maps a string log level to TikTokBusinessSdk.LogLevel. */
    fun mapLogLevel(level: String): TikTokBusinessSdk.LogLevel =
        when (level.lowercase()) {
            "none" -> TikTokBusinessSdk.LogLevel.NONE
            "info" -> TikTokBusinessSdk.LogLevel.INFO
            "warn" -> TikTokBusinessSdk.LogLevel.WARN
            "debug" -> TikTokBusinessSdk.LogLevel.DEBUG
            else -> TikTokBusinessSdk.LogLevel.NONE
        }

    /**
     * Creates a TTBaseEvent with the given parameters.
     */
    fun createBaseEvent(
        eventName: String,
        eventId: String?,
        parameters: Map<String, Any>,
    ): TTBaseEvent {
        val eventBuilder =
            if (eventId.isNullOrEmpty()) {
                TTBaseEvent.newBuilder(eventName)
            } else {
                TTBaseEvent.newBuilder(eventName, eventId)
            }

        parameters.forEach { (key, value) -> eventBuilder.addProperty(key, value.toString()) }

        return eventBuilder.build()
    }

    /**
     * Creates a TTContentsEvent for AddToCart.
     */
    fun createAddToCartEvent(
        eventId: String?,
        parameters: Map<String, Any>,
    ): TTContentsEvent =
        createContentsEvent(
            eventId,
            parameters,
            { id -> TTAddToCartEvent.newBuilder(id) },
            { TTAddToCartEvent.newBuilder() },
        )

    /**
     * Creates a TTContentsEvent for AddToWishlist.
     */
    fun createAddToWishlistEvent(
        eventId: String?,
        parameters: Map<String, Any>,
    ): TTContentsEvent =
        createContentsEvent(
            eventId,
            parameters,
            { id -> TTAddToWishlistEvent.newBuilder(id) },
            { TTAddToWishlistEvent.newBuilder() },
        )

    /**
     * Creates a TTContentsEvent for Checkout.
     */
    fun createCheckoutEvent(
        eventId: String?,
        parameters: Map<String, Any>,
    ): TTContentsEvent =
        createContentsEvent(
            eventId,
            parameters,
            { id -> TTCheckoutEvent.newBuilder(id) },
            { TTCheckoutEvent.newBuilder() },
        )

    /**
     * Creates a TTContentsEvent for Purchase.
     */
    fun createPurchaseEvent(
        eventId: String?,
        parameters: Map<String, Any>,
    ): TTContentsEvent =
        createContentsEvent(
            eventId,
            parameters,
            { id -> TTPurchaseEvent.newBuilder(id) },
            { TTPurchaseEvent.newBuilder() },
        )

    /**
     * Creates a TTContentsEvent for ViewContent.
     */
    fun createViewContentEvent(
        eventId: String?,
        parameters: Map<String, Any>,
    ): TTContentsEvent =
        createContentsEvent(
            eventId,
            parameters,
            { id -> TTViewContentEvent.newBuilder(id) },
            { TTViewContentEvent.newBuilder() },
        )

    /**
     * Helper to create TTContentsEvent with shared logic.
     */
    private fun createContentsEvent(
        eventId: String?,
        parameters: Map<String, Any>,
        builderWithId: (String) -> TTContentsEvent.Builder,
        builderNoId: () -> TTContentsEvent.Builder,
    ): TTContentsEvent {
        val currency = parseCurrency(parameters["currency"] as? String)
        val value = parameters["value"] as? Double
        val contentType = parameters["content_type"] as? String
        val contentId = parameters["content_id"] as? String
        val description = parameters["description"] as? String

        // New fields: price, quantity, content_category, content_name, brand
        val price = parameters["price"] as? Double
        val quantity = parameters["quantity"] as? Int
        val contentCategory = parameters["content_category"] as? String
        val contentName = parameters["content_name"] as? String
        val brand = parameters["brand"] as? String

        val eventBuilder = if (!eventId.isNullOrEmpty()) builderWithId(eventId) else builderNoId()

        return eventBuilder
            .apply {
                description?.let { setDescription(it) }
                currency?.let { setCurrency(it) }
                value?.let { setValue(it) }
                contentType?.let { setContentType(it) }

                // Build content parameters using TTContentParams
                val contentBuilder = TTContentParams.newBuilder()
                var hasContentParams = false

                // Note: We use contentBuilder.setContentId instead of eventBuilder.setContentId
                // to keep all content-related fields together in TTContentParams
                contentId?.let {
                    contentBuilder.setContentId(it)
                    hasContentParams = true
                }
                contentCategory?.let {
                    contentBuilder.setContentCategory(it)
                    hasContentParams = true
                }
                contentName?.let {
                    contentBuilder.setContentName(it)
                    hasContentParams = true
                }
                brand?.let {
                    contentBuilder.setBrand(it)
                    hasContentParams = true
                }
                price?.let {
                    contentBuilder.setPrice(it.toFloat())
                    hasContentParams = true
                }
                quantity?.let {
                    contentBuilder.setQuantity(it)
                    hasContentParams = true
                }

                if (hasContentParams) {
                    setContents(contentBuilder.build())
                }
            }.build() as TTContentsEvent
    }

    /**
     * Parses a currency string to TTContentsEventConstants.Currency.
     */
    private fun parseCurrency(currencyString: String?): TTContentsEventConstants.Currency? =
        currencyString?.let {
            try {
                TTContentsEventConstants.Currency.valueOf(it)
            } catch (e: IllegalArgumentException) {
                null
            }
        }
}

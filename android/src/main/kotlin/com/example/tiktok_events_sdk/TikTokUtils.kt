package com.example.tiktok_events_sdk

import com.tiktok.TikTokBusinessSdk.TTConfig
import com.tiktok.appevents.contents.TTAddToCartEvent
import com.tiktok.appevents.contents.TTAddToWishlistEvent
import com.tiktok.appevents.contents.TTCheckoutEvent
import com.tiktok.appevents.contents.TTPurchaseEvent
import com.tiktok.TikTokBusinessSdk
import com.tiktok.appevents.base.TTBaseEvent
import com.tiktok.appevents.contents.TTContentsEvent
import com.tiktok.appevents.contents.TTContentsEventConstants
import com.tiktok.appevents.contents.TTViewContentEvent

object TikTokUtils {
    fun configureAndroidOptions(options: Map<String, Any>, ttConfig: TTConfig): TTConfig {
        if (options["disableAutoStart"] as? Boolean == true) {
            ttConfig.disableAutoStart()
        }
        if (options["disableAutoEvents"] as? Boolean == true) {
            ttConfig.disableAutoEvents()
        }
        if (options["disableInstallLogging"] as? Boolean == true) {
            ttConfig.disableInstallLogging()
        }
        if (options["disableLaunchLogging"] as? Boolean == true) {
            ttConfig.disableLaunchLogging()
        }
        if (options["disableRetentionLogging"] as? Boolean == true) {
            ttConfig.disableRetentionLogging()
        }
        if (options["enableAutoIapTrack"] as? Boolean == true) {
            ttConfig.enableAutoIapTrack()
        }
        if (options["disableAdvertiserIDCollection"] as? Boolean == true) {
            ttConfig.disableAdvertiserIDCollection()
        }
        return ttConfig
    }

    fun mapLogLevel(level: String): TikTokBusinessSdk.LogLevel {
        return when (level) {
            "none" -> TikTokBusinessSdk.LogLevel.NONE
            "info" -> TikTokBusinessSdk.LogLevel.INFO
            "warn" -> TikTokBusinessSdk.LogLevel.WARN
            "debug" -> TikTokBusinessSdk.LogLevel.DEBUG
            else -> TikTokBusinessSdk.LogLevel.NONE
        }
    }

    fun createBaseEvent(
        eventName: String,
        eventId: String?,
        parameters: Map<String, Any>
    ): TTBaseEvent {
        val eventBuilder = if (eventId.isNullOrEmpty()) {
            TTBaseEvent.newBuilder(eventName)
        } else {
            TTBaseEvent.newBuilder(eventName, eventId)
        }

        parameters.forEach { (key, value) ->
            eventBuilder.addProperty(key, value.toString())
        }

        return eventBuilder.build()
    }

    fun createAddToCartEvent(
        eventId: String?,
        parameters: Map<String, Any>
    ): TTContentsEvent {
        val currency = parseCurrency(parameters["currency"] as? String)
        val value = parameters["value"] as? Double
        val contentType = parameters["content_type"] as? String
        val description = parameters["description"] as? String

        val eventBuilder = if (eventId.isNullOrEmpty()) {
            TTAddToCartEvent.newBuilder()
        } else {
            TTAddToCartEvent.newBuilder(eventId)
        }

        if (description != null) {
            eventBuilder.setDescription(description)
        }
        if (currency != null) {
            eventBuilder.setCurrency(currency)
        }
        if (value != null) {
            eventBuilder.setValue(value)
        }
        if (contentType != null) {
            eventBuilder.setContentType(contentType)
        }

        return eventBuilder.build() as TTContentsEvent
    }

    fun createAddToWishlistEvent(
        eventId: String?,
        parameters: Map<String, Any>
    ): TTContentsEvent {
        val currency = parseCurrency(parameters["currency"] as? String)
        val value = parameters["value"] as? Double
        val contentType = parameters["content_type"] as? String
        val description = parameters["description"] as? String

        val eventBuilder = if (eventId.isNullOrEmpty()) {
            TTAddToWishlistEvent.newBuilder()
        } else {
            TTAddToWishlistEvent.newBuilder(eventId)
        }

        if (description != null) {
            eventBuilder.setDescription(description)
        }
        if (currency != null) {
            eventBuilder.setCurrency(currency)
        }
        if (value != null) {
            eventBuilder.setValue(value)
        }
        if (contentType != null) {
            eventBuilder.setContentType(contentType)
        }

        return eventBuilder.build() as TTContentsEvent
    }

    fun createCheckoutEvent(
        eventId: String?,
        parameters: Map<String, Any>
    ): TTContentsEvent {
        val currency = parseCurrency(parameters["currency"] as? String)
        val value = parameters["value"] as? Double
        val contentType = parameters["content_type"] as? String
        val description = parameters["description"] as? String

        val eventBuilder = if (eventId.isNullOrEmpty()) {
            TTCheckoutEvent.newBuilder()
        } else {
            TTCheckoutEvent.newBuilder(eventId)
        }

        if (description != null) {
            eventBuilder.setDescription(description)
        }
        if (currency != null) {
            eventBuilder.setCurrency(currency)
        }
        if (value != null) {
            eventBuilder.setValue(value)
        }
        if (contentType != null) {
            eventBuilder.setContentType(contentType)
        }

        return eventBuilder.build() as TTContentsEvent
    }

    fun createPurchaseEvent(
        eventId: String?,
        parameters: Map<String, Any>
    ): TTContentsEvent {
        val currency = parseCurrency(parameters["currency"] as? String)
        val value = parameters["value"] as? Double
        val contentType = parameters["content_type"] as? String
        val description = parameters["description"] as? String

        val eventBuilder = if (eventId.isNullOrEmpty()) {
            TTPurchaseEvent.newBuilder()
        } else {
            TTPurchaseEvent.newBuilder(eventId)
        }

        if (description != null) {
            eventBuilder.setDescription(description)
        }
        if (currency != null) {
            eventBuilder.setCurrency(currency)
        }
        if (value != null) {
            eventBuilder.setValue(value)
        }
        if (contentType != null) {
            eventBuilder.setContentType(contentType)
        }

        return eventBuilder.build() as TTContentsEvent
    }

    fun createViewContentEvent(
        eventId: String?,
        parameters: Map<String, Any>
    ): TTContentsEvent {
        val currency = parseCurrency(parameters["currency"] as? String)
        val value = parameters["value"] as? Double
        val contentType = parameters["content_type"] as? String
        val description = parameters["description"] as? String

        val eventBuilder = if (eventId.isNullOrEmpty()) {
            TTViewContentEvent.newBuilder()
        } else {
            TTViewContentEvent.newBuilder(eventId)
        }

        if (description != null) {
            eventBuilder.setDescription(description)
        }
        if (currency != null) {
            eventBuilder.setCurrency(currency)
        }
        if (value != null) {
            eventBuilder.setValue(value)
        }
        if (contentType != null) {
            eventBuilder.setContentType(contentType)
        }

        return eventBuilder.build() as TTContentsEvent
    }

    private fun parseCurrency(currencyString: String?): TTContentsEventConstants.Currency? {
        return if (currencyString != null) {
            try {
                TTContentsEventConstants.Currency.valueOf(currencyString)
            } catch (e: IllegalArgumentException) {
                null
            }
        } else {
            null
        }
    }
}
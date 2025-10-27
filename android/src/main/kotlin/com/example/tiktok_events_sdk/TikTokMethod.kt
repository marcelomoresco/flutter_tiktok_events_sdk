package com.example.tiktok_events_sdk

import android.content.Context
import com.tiktok.TikTokBusinessSdk.TTConfig
import com.tiktok.TikTokBusinessSdk
import com.tiktok.appevents.base.TTBaseEvent
import com.tiktok.appevents.contents.TTAddToCartEvent
import com.tiktok.appevents.contents.TTAddToWishlistEvent
import com.tiktok.appevents.contents.TTCheckoutEvent
import com.tiktok.appevents.contents.TTPurchaseEvent
import com.tiktok.appevents.contents.TTViewContentEvent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest
import java.util.regex.Pattern

object TikTokMethodName {
    const val INITIALIZE: String = "initialize"
    const val IDENTIFY: String = "identify"
    const val SEND_EVENT: String = "sendEvent"
    const val SEND_CUSTOM_EVENT: String = "sendCustomEvent"
    const val LOGOUT: String = "logout"
    const val START_TRACK: String = "startTrack"
}

sealed class TikTokMethod(
    val type: String,
) {
    abstract fun call(
        context: Context,
        call: MethodCall,
        result: MethodChannel.Result,
        exception: Exception?
    )

    fun MethodChannel.Result.emitError(
        errorMessage: String,
        exception: Exception? = null,
        showDetails: Boolean = false
    ) {
        // Show detailed error messages in debug mode, generic messages in production
        val isDebugMode = try {
            val clazz = Class.forName("com.example.tiktok_events_sdk.BuildConfig")
            clazz.getField("DEBUG").getBoolean(null)
        } catch (e: Exception) {
            false
        }

        val finalErrorMessage = if (isDebugMode && showDetails && exception != null) {
            "$errorMessage: ${exception.message}"
        } else {
            errorMessage
        }

        // Only include stack traces in debug builds to prevent information disclosure
        val stackTrace = if (isDebugMode && showDetails) {
            Thread.currentThread().stackTrace.map { element -> element.toString() }
        } else {
            null
        }

        this.error(tikTokErrorTag, finalErrorMessage, stackTrace)
    }

    private val tikTokErrorTag: String = "TikTok Error"

    /**
     * Hash PII data using SHA-256 before forwarding to TikTok
     * This minimizes breach impact if data is intercepted
     */
    private fun hashPII(data: String?): String? {
        if (data.isNullOrEmpty()) return null

        return try {
            val digest = MessageDigest.getInstance("SHA-256")
            val hashBytes = digest.digest(data.toByteArray())
            hashBytes.joinToString("") { "%02x".format(it) }
        } catch (e: Exception) {
            null
        }
    }

    /**
     * Validate and sanitize email input
     * Email validation regex pattern
     */
    private fun isValidEmail(email: String?): Boolean {
        if (email.isNullOrEmpty()) return false
        val emailPattern = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$"
        )
        return emailPattern.matcher(email).matches()
    }

    /**
     * Validate and sanitize phone number input
     */
    private fun isValidPhone(phone: String?): Boolean {
        if (phone.isNullOrEmpty()) return false
        // Allow digits, spaces, hyphens, parentheses, and + for international format
        val phonePattern = Pattern.compile("^[+]?[\\d\\s\\-()]{8,20}$")
        return phonePattern.matcher(phone).matches()
    }

    /**
     * Sanitize string input to prevent injection
     */
    private fun sanitizeString(input: String?): String? {
        if (input.isNullOrEmpty()) return null
        // Remove potentially dangerous characters
        return input
            .trim()
            .replace(Regex("[<>\"'\\\\]"), "")
            .takeIf { it.isNotBlank() }
    }

    object Initialize : TikTokMethod(
        type = TikTokMethodName.INITIALIZE
    ) {
        override fun call(
            context: Context,
            call: MethodCall,
            result: MethodChannel.Result,
            exception: Exception?
        ) {
            try {
                val appId = sanitizeString(call.argument<String>("appId"))
                val tiktokAppId = sanitizeString(call.argument<String>("tiktokId"))
                val isDebugMode = call.argument<Boolean>("isDebugMode") ?: false
                val logLevelString: String? = call.argument<String?>("logLevel")
                val logLevel = if (logLevelString != null) {
                    TikTokUtils.mapLogLevel(logLevelString)
                } else {
                    TikTokBusinessSdk.LogLevel.INFO
                }

                val options = call.argument<Map<String, Any>>("options") ?: emptyMap()

                // Validate required parameters
                if (appId.isNullOrEmpty() || tiktokAppId.isNullOrEmpty()) {
                    result.emitError("Parameters 'appId' or 'tiktokId' were not provided or are invalid.")
                    return
                }

                var ttConfig = TTConfig(context)
                    .setAppId(appId)
                    .setTTAppId(tiktokAppId)
                    .setLogLevel(logLevel)

                ttConfig = TikTokUtils.configureAndroidOptions(options, ttConfig)

                if (isDebugMode) {
                    ttConfig.openDebugMode()
                }

                TikTokBusinessSdk.initializeSdk(ttConfig)
                result.success("TikTok SDK initialized!")
            } catch (e: Exception) {
                // Show detailed error in debug mode, generic error in production
                result.emitError("An error occurred during TikTok SDK initialization.", e, true)
            }
        }
    }

    object Identify : TikTokMethod(
        type = TikTokMethodName.IDENTIFY
    ) {
        override fun call(
            context: Context,
            call: MethodCall,
            result: MethodChannel.Result,
            exception: Exception?
        ) {
            try {
                val externalId = sanitizeString(call.argument<String>("externalId"))
                val externalUserName = sanitizeString(call.argument<String>("externalUserName"))
                val rawPhoneNumber = call.argument<String>("phoneNumber")
                val rawEmail = call.argument<String>("email")

                // Validate required parameters
                if (externalId.isNullOrEmpty() || externalUserName.isNullOrEmpty()) {
                    result.emitError("Parameters 'externalId' and 'externalUserName' are required.")
                    return
                }

                // Validate email format if provided
                if (!rawEmail.isNullOrEmpty() && !isValidEmail(rawEmail)) {
                    result.emitError("Invalid email format.")
                    return
                }

                // Validate phone format if provided
                if (!rawPhoneNumber.isNullOrEmpty() && !isValidPhone(rawPhoneNumber)) {
                    result.emitError("Invalid phone format.")
                    return
                }

                // Hash PII before forwarding to TikTok
                val hashedPhoneNumber = if (!rawPhoneNumber.isNullOrEmpty()) {
                    hashPII(rawPhoneNumber)
                } else {
                    null
                }

                val hashedEmail = if (!rawEmail.isNullOrEmpty()) {
                    hashPII(rawEmail)
                } else {
                    null
                }

                TikTokBusinessSdk.identify(
                    externalId, externalUserName, hashedPhoneNumber, hashedEmail
                )

                result.success("User identified successfully!")

            } catch (e: Exception) {
                // Show detailed error in debug mode, generic error in production
                result.emitError("An error occurred during user identification.", e, true)
            }
        }
    }

    object SendEvent : TikTokMethod(
        type = TikTokMethodName.SEND_EVENT
    ) {
        override fun call(
            context: Context,
            call: MethodCall,
            result: MethodChannel.Result,
            exception: Exception?
        ) {
            try {
                val eventTypeName = sanitizeString(call.argument<String>("event_type_name")) ?: "none"
                val parameters = call.argument<Map<String, Any>>("parameters") ?: emptyMap()
                val eventId = sanitizeString(call.argument<String>("event_id"))
                val eventName = sanitizeString(call.argument<String>("event_name"))

                // Validate required parameters
                if (eventName.isNullOrEmpty()) {
                    result.emitError("Parameter 'event_name' was not provided or is invalid.")
                    return
                }

                // Validate event name format
                if (!eventName.matches(Regex("^[a-zA-Z0-9_]+$"))) {
                    result.emitError("Event name contains invalid characters. Use only letters, numbers, and underscore.")
                    return
                }

                val event = when (eventTypeName) {
                    "None" -> TikTokUtils.createBaseEvent(eventName, eventId, parameters)
                    "AddToCart" -> TikTokUtils.createAddToCartEvent(eventId, parameters)
                    "AddToWishlist" -> TikTokUtils.createAddToWishlistEvent(eventId, parameters)
                    "Checkout" -> TikTokUtils.createCheckoutEvent(eventId, parameters)
                    "Purchase" -> TikTokUtils.createPurchaseEvent(eventId, parameters)
                    "ViewContent" -> TikTokUtils.createViewContentEvent(eventId, parameters)
                    else -> TikTokUtils.createBaseEvent(eventTypeName, eventId, parameters)
                }


                TikTokBusinessSdk.trackTTEvent(event)
                result.success("Event '$eventName' sent successfully!")
            } catch (e: Exception) {
                // Show detailed error in debug mode, generic error in production
                result.emitError("An error occurred while sending the event.", e, true)
            }
        }
    }

    object Logout : TikTokMethod(
        type = TikTokMethodName.LOGOUT
    ) {
        override fun call(
            context: Context,
            call: MethodCall,
            result: MethodChannel.Result,
            exception: Exception?
        ) {
            try {
                TikTokBusinessSdk.logout()
                result.success("TikTok SDK logout!")
            } catch (e: Exception) {
                // Show detailed error in debug mode, generic error in production
                result.emitError("An error occurred during logout.", e, true)
            }
        }
    }

    object StartTrack : TikTokMethod(
        type = TikTokMethodName.START_TRACK
    ) {
        override fun call(
            context: Context,
            call: MethodCall,
            result: MethodChannel.Result,
            exception: Exception?
        ) {
            try {
                // Require explicit consent parameter to comply with privacy regulations (GDPR/CCPA)
                val hasConsent = call.argument<Boolean>("hasConsent") ?: false

                if (!hasConsent) {
                    // Do not start tracking without explicit consent
                    result.emitError("Cannot start tracking: User consent is required but not provided. " +
                            "Please call startTrack with 'hasConsent: true' only after obtaining explicit user opt-in.")
                    return
                }

                TikTokBusinessSdk.startTrack()
                result.success("TikTok Start Tracking!")
            } catch (e: Exception) {
                // Show detailed error in debug mode, generic error in production
                result.emitError("An error occurred while starting tracking.", e, true)
            }
        }
    }

    companion object {
        fun getCall(type: String): TikTokMethod? = listOf(
            Initialize,
            Identify,
            SendEvent,
            Logout,
            StartTrack
        ).firstOrNull { it.type == type }
    }
}

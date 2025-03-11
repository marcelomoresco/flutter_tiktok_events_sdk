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

object TikTokMethodName {
    const val INITIALIZE: String = "initialize"
    const val IDENTIFY: String = "identify"
    const val SEND_EVENT: String = "sendEvent"
    const val SEND_CUSTOM_EVENT: String = "sendCustomEvent"
    const val LOGOUT: String = "logout"
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

    fun MethodChannel.Result.emitError(errorMessage: String) {
        val stackTrace = Thread.currentThread().stackTrace.map { element -> element.toString() }
        this.error(tikTokErrorTag, errorMessage, stackTrace)
    }

    private val tikTokErrorTag: String = "TikTok Error"

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
                val appId = call.argument<String>("appId")
                val tiktokAppId = call.argument<String>("tiktokId")
                val isDebugMode = call.argument<Boolean>("isDebugMode") ?: false
                val logLevelString: String? = call.argument<String?>("logLevel")
                val logLevel = if (logLevelString != null) {
                    TikTokUtils.mapLogLevel(logLevelString)
                } else {
                    TikTokBusinessSdk.LogLevel.INFO
                }

                val options = call.argument<Map<String, Any>>("options") ?: emptyMap()

                if (appId.isNullOrEmpty() || tiktokAppId.isNullOrEmpty()) {
                    result.emitError("Parâmetros 'appId' ou 'tiktokId' não fornecidos ou inválidos.")
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
                result.emitError("Erro durante a inicialização do TikTok SDK: ${e.message}")
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
                val externalId = call.argument<String>("externalId")
                val externalUserName = call.argument<String>("externalUserName")
                val phoneNumber = call.argument<String>("phoneNumber")
                val email = call.argument<String>("email")

                if (externalId.isNullOrEmpty() || externalUserName.isNullOrEmpty() || email.isNullOrEmpty()) {
                    result.emitError("Parâmetros 'externalId' ou 'externalUserName' ou 'email' não fornecidos ou inválidos.")
                    return
                }

                TikTokBusinessSdk.identify(
                    externalId, externalUserName, phoneNumber, email
                )

            } catch (e: Exception) {
                result.emitError("Erro durante a inicialização do TikTok SDK: ${e.message}")
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
                val eventTypeName = call.argument<String>("event_type_name") ?: "none"
                val parameters = call.argument<Map<String, Any>>("parameters") ?: emptyMap()
                val eventId = call.argument<String>("event_id")
                val eventName = call.argument<String>("event_name")

                if (eventName.isNullOrEmpty()) {
                    result.emitError("Parâmetro 'event_name' não fornecido ou inválido.")
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
                result.success("Evento '$eventName' enviado com sucesso!")
            } catch (e: Exception) {
                // Retornar erro para o Flutter em caso de falha
                result.emitError("Erro durante o envio do evento: ${e.message}")
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
                result.emitError("Erro durante a inicialização do TikTok SDK: ${e.message}")
            }
        }
    }

    companion object {
        fun getCall(type: String): TikTokMethod? = listOf(
            Initialize,
            Identify,
            SendEvent,
            Logout
        ).firstOrNull { it.type == type }
    }
}

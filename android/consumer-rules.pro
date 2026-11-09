-keep class com.tiktok.** { *; }
-keep class com.android.billingclient.api.** { *; }

# The TikTok SDK compiles against the Play Billing Library but treats it as optional: it
# reads the Billing version reflectively and falls back to a no-op proxy when the library
# is absent. Apps that do not use Billing must not fail R8 on those references.
-dontwarn com.android.billingclient.api.**

# Flutter Keep Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Awesome Notifications
-keep class me.carda.awesome_notifications.** { *; }
-dontwarn me.carda.awesome_notifications.**
-keep class me.carda.** { *; }
-dontwarn me.carda.**

# SQLite and SQLCipher used by awesome_notifications for schedules & events
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }
-keep,includedescriptorclasses class net.sqlcipher.** { *; }
-keep,includedescriptorclasses interface net.sqlcipher.** { *; }

# Gson serialization used by awesome_notifications
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keepclassmembers enum * { *; }

# General warnings suppression
-dontwarn com.google.**
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.concurrent.GuardedBy

# Audio Service and Just Audio
-keep class com.ryanheise.audioservice.** { *; }
-dontwarn com.ryanheise.audioservice.**
-keep class com.ryanheise.just_audio.** { *; }
-dontwarn com.ryanheise.just_audio.**

# Media3 & ExoPlayer
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# Android Media & Support
-keep class androidx.media.** { *; }
-keep class android.support.v4.media.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }

# App receivers and services
-keep class com.wolfdev.hojaty.** { *; }



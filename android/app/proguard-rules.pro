# Flutter Keep Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Hojaty Native Receivers, Audio, and Flip Detection
-keep class com.wolfdev.hojaty.** { *; }

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

# WorkManager & Room Database (required for home_widget / glance in release builds)
-keep class * extends androidx.room.RoomDatabase { *; <init>(); }
-keep class androidx.room.RoomDatabase$Builder { *; }
-keep class androidx.room.RoomDatabase { *; }
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class androidx.work.** { *; }
-keep class androidx.work.impl.** { *; }
-dontwarn androidx.work.**
-dontwarn androidx.room.**

# Jetpack Glance & Home Widget
-keep class es.antonborri.home_widget.** { *; }
-keepclassmembers class * extends androidx.glance.appwidget.protobuf.GeneratedMessageLite {
    <fields>;
}
-keep public class * extends androidx.glance.appwidget.action.ActionCallback {
    public <init>();
}




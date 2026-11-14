package com.wolfdev.hojaty

import android.content.Context
import android.content.Intent
import android.util.Log
import me.carda.awesome_notifications.AwesomeNotificationsFlutterExtension
import me.carda.awesome_notifications.DartDismissedNotificationReceiver
import me.carda.awesome_notifications.DartNotificationActionReceiver
import me.carda.awesome_notifications.DartScheduledNotificationReceiver
import me.carda.awesome_notifications.core.AwesomeNotifications
import org.json.JSONObject

class PrayerScheduledReceiver : DartScheduledNotificationReceiver() {
    companion object {
        private const val TAG = "PrayerSchedReceiver"
    }

    override fun initializeExternalPlugins(context: Context) {
        AwesomeNotificationsFlutterExtension.initialize()
        AwesomeNotifications.scheduleReceiverClass = PrayerScheduledReceiver::class.java
        AwesomeNotifications.dismissReceiverClass = PrayerDismissedReceiver::class.java
        AwesomeNotifications.actionReceiverClass = PrayerActionReceiver::class.java
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        try {
            val jsonStr = intent.getStringExtra("notificationJson")
            if (!jsonStr.isNullOrEmpty()) {
                val json = JSONObject(jsonStr)
                val content = json.optJSONObject("content")
                val channelKey = content?.optString("channelKey", "") ?: ""
                val id = content?.optInt("id", -1) ?: -1

                if (channelKey.contains("prayers_channel") || (id in 100..105)) {
                    Log.i(TAG, "Prayer alarm fired (ID: $id, channel: $channelKey). Starting AzanFlipDetector.")
                    AzanFlipDetector.start(context.applicationContext, id)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error checking scheduled notification JSON: ${e.message}")
        }
    }
}

class PrayerDismissedReceiver : DartDismissedNotificationReceiver() {
    override fun initializeExternalPlugins(context: Context) {
        AwesomeNotificationsFlutterExtension.initialize()
        AwesomeNotifications.scheduleReceiverClass = PrayerScheduledReceiver::class.java
        AwesomeNotifications.dismissReceiverClass = PrayerDismissedReceiver::class.java
        AwesomeNotifications.actionReceiverClass = PrayerActionReceiver::class.java
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        AzanFlipDetector.stop()
    }
}

class PrayerActionReceiver : DartNotificationActionReceiver() {
    override fun initializeExternalPlugins(context: Context) {
        AwesomeNotificationsFlutterExtension.initialize()
        AwesomeNotifications.scheduleReceiverClass = PrayerScheduledReceiver::class.java
        AwesomeNotifications.dismissReceiverClass = PrayerDismissedReceiver::class.java
        AwesomeNotifications.actionReceiverClass = PrayerActionReceiver::class.java
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        AzanFlipDetector.stop()
    }
}

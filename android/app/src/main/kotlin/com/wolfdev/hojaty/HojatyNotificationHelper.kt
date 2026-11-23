package com.wolfdev.hojaty

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

object HojatyNotificationHelper {
    private const val TAG = "HojatyNotification"

    const val CHANNEL_PRAYERS = "hojaty_prayers_channel_v7"
    const val CHANNEL_PRE_PRAYER = "hojaty_pre_prayer_channel_v7"
    const val CHANNEL_SALAWAT = "hojaty_salawat_channel_v7"
    const val CHANNEL_OCCASIONS = "hojaty_occasions_channel_v7"
    const val CHANNEL_GENERAL = "hojaty_general_channel_v7"

    private const val PRIMARY_COLOR = 0xFF1E3A34.toInt()

    fun createNotificationChannels(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager ?: return

        val audioAttributes = AudioAttributes.Builder()
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .setUsage(AudioAttributes.USAGE_NOTIFICATION_EVENT)
            .build()

        // 1. Prayers Channel (Audio is handled via AzanNativePlayer with USAGE_ALARM)
        val prayersChannel = NotificationChannel(
            CHANNEL_PRAYERS,
            "مواقيت الصلاة والأذان",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "تنبيهات مواقيت الصلاة والأذان"
            lightColor = Color.YELLOW
            enableLights(true)
            enableVibration(true)
            setSound(null, null)
        }

        // 2. Pre-Prayer Channel
        val prePrayerSound = Uri.parse("android.resource://${context.packageName}/raw/prayer_time_is_close")
        val prePrayerChannel = NotificationChannel(
            CHANNEL_PRE_PRAYER,
            "التنبيه المسبق للأذان",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "تنبيه خفيف للتذكير باقتراب موعد الصلاة قبل دخول الوقت"
            lightColor = Color.YELLOW
            enableLights(true)
            setSound(prePrayerSound, audioAttributes)
        }

        // 3. Salawat Channel
        val salawatSound = Uri.parse("android.resource://${context.packageName}/raw/salli_ala_muhammad")
        val salawatChannel = NotificationChannel(
            CHANNEL_SALAWAT,
            "الصلاة على النبي ﷺ",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "تذكير دوري بالصلاة والسلام على رسول الله ﷺ"
            lightColor = Color.YELLOW
            enableLights(true)
            setSound(salawatSound, audioAttributes)
        }

        // 4. Occasions Channel
        val occasionsChannel = NotificationChannel(
            CHANNEL_OCCASIONS,
            "المناسبات الإسلامية",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = "تذكير بالمناسبات الإسلامية ومواسم الطاعات"
        }

        // 5. General Channel
        val generalChannel = NotificationChannel(
            CHANNEL_GENERAL,
            "تنبيهات عامة",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = "الأذكار والتنبيهات العامة"
        }

        notificationManager.createNotificationChannels(
            listOf(prayersChannel, prePrayerChannel, salawatChannel, occasionsChannel, generalChannel)
        )
        Log.i(TAG, "Notification channels created successfully.")
    }

    private fun getIconResId(context: Context): Int {
        val id = context.resources.getIdentifier("res_app_icon", "drawable", context.packageName)
        return if (id != 0) id else android.R.drawable.ic_dialog_info
    }

    /**
     * Displays a Prayer/Adhan notification with Full Screen Intent, Open App, and Stop buttons.
     */
    fun showPrayerNotification(
        context: Context,
        id: Int,
        title: String,
        body: String,
        soundId: String?,
        soundPath: String?,
        isTest: Boolean = false
    ) {
        createNotificationChannels(context)

        // Open App Intent
        val openIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("route", "prayerTimes")
            putExtra("notificationId", id)
        }
        val openPendingIntent = PendingIntent.getActivity(
            context,
            id * 10,
            openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Stop Azan Action Intent
        val stopIntent = Intent(context, HojatyActionReceiver::class.java).apply {
            action = HojatyActionReceiver.ACTION_STOP_AZAN
            putExtra("notificationId", id)
        }
        val stopPendingIntent = PendingIntent.getBroadcast(
            context,
            id * 10 + 1,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_PRAYERS)
            .setSmallIcon(getIconResId(context))
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setColor(PRIMARY_COLOR)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setAutoCancel(true)
            .setSilent(true)
            .setOnlyAlertOnce(true)
            .setContentIntent(openPendingIntent)
            .setDeleteIntent(stopPendingIntent) // Stopping Azan if notification swiped
            .addAction(0, "فتح التطبيق", openPendingIntent)
            .addAction(0, "إيقاف الأذان", stopPendingIntent)
            .setFullScreenIntent(openPendingIntent, true)

        try {
            NotificationManagerCompat.from(context).notify(id, builder.build())
        } catch (e: SecurityException) {
            Log.e(TAG, "Permission denied for showing notification: ${e.message}")
        }

        // Start flip detection to allow user to silence Azan by flipping device face-down
        AzanFlipDetector.start(context, id)

        // Play Azan natively with USAGE_ALARM and WakeLock
        AzanNativePlayer.play(context, soundPath, soundId)
    }

    /**
     * Displays a Pre-Prayer reminder notification.
     */
    fun showPrePrayerNotification(
        context: Context,
        id: Int,
        title: String,
        body: String
    ) {
        createNotificationChannels(context)

        val openIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("route", "prayerTimes")
            putExtra("notificationId", id)
        }
        val openPendingIntent = PendingIntent.getActivity(
            context,
            id * 10,
            openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val dismissIntent = Intent(context, HojatyActionReceiver::class.java).apply {
            action = HojatyActionReceiver.ACTION_DISMISS
            putExtra("notificationId", id)
        }
        val dismissPendingIntent = PendingIntent.getBroadcast(
            context,
            id * 10 + 1,
            dismissIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_PRE_PRAYER)
            .setSmallIcon(getIconResId(context))
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setColor(PRIMARY_COLOR)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setAutoCancel(true)
            .setOnlyAlertOnce(true)
            .setContentIntent(openPendingIntent)
            .addAction(0, "فتح التطبيق", openPendingIntent)
            .addAction(0, "حسناً", dismissPendingIntent)

        try {
            NotificationManagerCompat.from(context).notify(id, builder.build())
        } catch (e: SecurityException) {
            Log.e(TAG, "Permission denied for showing notification: ${e.message}")
        }
    }

    /**
     * Displays a Salawat notification and plays the blessings audio.
     */
    fun showSalawatNotification(
        context: Context,
        id: Int,
        title: String,
        body: String
    ) {
        createNotificationChannels(context)

        val openIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("notificationId", id)
        }
        val openPendingIntent = PendingIntent.getActivity(
            context,
            id * 10,
            openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val dismissIntent = Intent(context, HojatyActionReceiver::class.java).apply {
            action = HojatyActionReceiver.ACTION_DISMISS
            putExtra("notificationId", id)
        }
        val dismissPendingIntent = PendingIntent.getBroadcast(
            context,
            id * 10 + 1,
            dismissIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_SALAWAT)
            .setSmallIcon(getIconResId(context))
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setColor(PRIMARY_COLOR)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setAutoCancel(true)
            .setOnlyAlertOnce(true)
            .setContentIntent(openPendingIntent)
            .addAction(0, "فتح التطبيق", openPendingIntent)
            .addAction(0, "حسناً", dismissPendingIntent)

        try {
            NotificationManagerCompat.from(context).notify(id, builder.build())
        } catch (e: SecurityException) {
            Log.e(TAG, "Permission denied for showing notification: ${e.message}")
        }
    }

    /**
     * Displays an Occasion notification.
     */
    fun showOccasionNotification(
        context: Context,
        id: Int,
        title: String,
        body: String
    ) {
        createNotificationChannels(context)

        val openIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("notificationId", id)
        }
        val openPendingIntent = PendingIntent.getActivity(
            context,
            id * 10,
            openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_OCCASIONS)
            .setSmallIcon(getIconResId(context))
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setColor(PRIMARY_COLOR)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setCategory(NotificationCompat.CATEGORY_EVENT)
            .setAutoCancel(true)
            .setOnlyAlertOnce(true)
            .setContentIntent(openPendingIntent)

        try {
            NotificationManagerCompat.from(context).notify(id, builder.build())
        } catch (e: SecurityException) {
            Log.e(TAG, "Permission denied for showing notification: ${e.message}")
        }
    }
}


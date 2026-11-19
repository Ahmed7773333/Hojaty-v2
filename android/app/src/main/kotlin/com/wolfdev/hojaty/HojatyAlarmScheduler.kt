package com.wolfdev.hojaty

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationManagerCompat

object HojatyAlarmScheduler {
    private const val TAG = "HojatyAlarmScheduler"
    private const val PREFS_NAME = "hojaty_notifications_prefs"
    private const val KEY_SALAWAT_ENABLED = "salawat_enabled"

    const val SALAWAT_ALARM_ID = 777
    const val SALAWAT_INTERVAL_MS = 3600_000L // 1 hour

    private fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    private fun setAlarm(context: Context, id: Int, triggerTimeMillis: Long, intent: Intent) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    if (alarmManager.canScheduleExactAlarms()) {
                        alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerTimeMillis, pendingIntent)
                    } else {
                        alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerTimeMillis, pendingIntent)
                    }
                } else {
                    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerTimeMillis, pendingIntent)
                }
            } else {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerTimeMillis, pendingIntent)
            }
            Log.i(TAG, "Scheduled alarm ID $id at $triggerTimeMillis (in ${(triggerTimeMillis - System.currentTimeMillis()) / 1000}s)")
        } catch (e: Exception) {
            Log.e(TAG, "Error setting alarm ID $id: ${e.message}")
        }
    }

    fun cancelAlarm(context: Context, id: Int) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
        val intent = Intent(context, HojatyAlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
        pendingIntent.cancel()
        NotificationManagerCompat.from(context).cancel(id)
        Log.i(TAG, "Cancelled alarm and notification ID $id")
    }

    // -------------------------------------------------------------------------
    // Prayers
    // -------------------------------------------------------------------------

    fun schedulePrayer(
        context: Context,
        id: Int,
        triggerTimeMillis: Long,
        title: String,
        body: String,
        soundId: String?,
        soundPath: String?
    ) {
        val intent = Intent(context, HojatyAlarmReceiver::class.java).apply {
            putExtra("id", id)
            putExtra("type", "prayer")
            putExtra("title", title)
            putExtra("body", body)
            putExtra("soundId", soundId)
            putExtra("soundPath", soundPath)
        }
        setAlarm(context, id, triggerTimeMillis, intent)
    }

    fun cancelAllPrayers(context: Context) {
        AzanNativePlayer.stop()
        AzanFlipDetector.stop()
        for (id in 100..105) {
            cancelAlarm(context, id)
        }
        cancelAlarm(context, 999)
        cancelAlarm(context, 996)
    }

    // -------------------------------------------------------------------------
    // Pre-Prayer Reminder
    // -------------------------------------------------------------------------

    fun schedulePrePrayer(
        context: Context,
        id: Int,
        triggerTimeMillis: Long,
        title: String,
        body: String
    ) {
        val intent = Intent(context, HojatyAlarmReceiver::class.java).apply {
            putExtra("id", id)
            putExtra("type", "pre_prayer")
            putExtra("title", title)
            putExtra("body", body)
        }
        setAlarm(context, id, triggerTimeMillis, intent)
    }

    fun cancelAllPrePrayers(context: Context) {
        for (id in 150..155) {
            cancelAlarm(context, id)
        }
        cancelAlarm(context, 998)
        cancelAlarm(context, 995)
    }

    // -------------------------------------------------------------------------
    // Salawat Hourly Reminder
    // -------------------------------------------------------------------------

    fun setSalawatEnabled(context: Context, enabled: Boolean) {
        getPrefs(context).edit().putBoolean(KEY_SALAWAT_ENABLED, enabled).apply()
        if (enabled) {
            scheduleNextHourlySalawat(context)
        } else {
            cancelAlarm(context, SALAWAT_ALARM_ID)
        }
    }

    fun isSalawatEnabled(context: Context): Boolean {
        return getPrefs(context).getBoolean(KEY_SALAWAT_ENABLED, true)
    }

    fun scheduleNextHourlySalawat(context: Context) {
        if (!isSalawatEnabled(context)) return

        val triggerAtMillis = System.currentTimeMillis() + SALAWAT_INTERVAL_MS
        val intent = Intent(context, HojatyAlarmReceiver::class.java).apply {
            putExtra("id", SALAWAT_ALARM_ID)
            putExtra("type", "salawat")
            putExtra("title", "الصلاة على النبي ﷺ")
            putExtra("body", "اللهم صلِّ وسلِّم وبارك على سيدنا محمد وعلى آله وصحبه أجمعين")
        }
        setAlarm(context, SALAWAT_ALARM_ID, triggerAtMillis, intent)
        Log.i(TAG, "Scheduled next hourly Salawat alarm for $triggerAtMillis")
    }

    // -------------------------------------------------------------------------
    // Occasions
    // -------------------------------------------------------------------------

    fun scheduleOccasion(
        context: Context,
        id: Int,
        triggerTimeMillis: Long,
        title: String,
        body: String
    ) {
        val intent = Intent(context, HojatyAlarmReceiver::class.java).apply {
            putExtra("id", id)
            putExtra("type", "occasion")
            putExtra("title", title)
            putExtra("body", body)
        }
        setAlarm(context, id, triggerTimeMillis, intent)
    }

    fun cancelAllOccasions(context: Context) {
        for (id in 200..300) {
            cancelAlarm(context, id * 10 + 1)
            cancelAlarm(context, id * 10 + 2)
        }
    }
}


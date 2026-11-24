package com.wolfdev.hojaty

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class HojatyAlarmReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "HojatyAlarmReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val id = intent.getIntExtra("id", -1)
        val type = intent.getStringExtra("type") ?: ""
        val title = intent.getStringExtra("title") ?: ""
        val body = intent.getStringExtra("body") ?: ""
        val soundId = intent.getStringExtra("soundId")
        val soundPath = intent.getStringExtra("soundPath")

        Log.i(TAG, "Alarm triggered! ID: $id, type: $type, title: $title")

        when (type) {
            "prayer" -> {
                HojatyNotificationHelper.showPrayerNotification(
                    context = context,
                    id = if (id != -1) id else 100,
                    title = title.ifEmpty { "حان الآن وقت الصلاة" },
                    body = body.ifEmpty { "حي على الصلاة، حي على الفلاح" },
                    soundId = soundId,
                    soundPath = soundPath
                )
                PrayerWidgetProvider.refreshAllWidgets(context)
            }
            "pre_prayer" -> {
                HojatyNotificationHelper.showPrePrayerNotification(
                    context = context,
                    id = if (id != -1) id else 150,
                    title = title.ifEmpty { "اقترب موعد الصلاة" },
                    body = body.ifEmpty { "استعد للصلاة" }
                )
            }
            "salawat" -> {
                HojatyNotificationHelper.showSalawatNotification(
                    context = context,
                    id = HojatyAlarmScheduler.SALAWAT_ALARM_ID,
                    title = title.ifEmpty { "الصلاة على النبي ﷺ" },
                    body = body.ifEmpty { "اللهم صلِّ وسلِّم وبارك على سيدنا محمد وعلى آله وصحبه أجمعين" }
                )
                // Schedule next hourly reminder
                HojatyAlarmScheduler.scheduleNextHourlySalawat(context)
            }
            "occasion" -> {
                HojatyNotificationHelper.showOccasionNotification(
                    context = context,
                    id = if (id != -1) id else 200,
                    title = title.ifEmpty { "مناسبة إسلامية" },
                    body = body
                )
            }
            else -> {
                Log.w(TAG, "Unknown alarm type: $type")
            }
        }
    }
}


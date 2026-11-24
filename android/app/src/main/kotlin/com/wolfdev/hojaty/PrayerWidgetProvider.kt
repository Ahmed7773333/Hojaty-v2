package com.wolfdev.hojaty

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.SystemClock
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class PrayerWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "PrayerWidgetProvider"
        private const val ROLLOVER_ALARM_REQUEST_CODE = 8801
        private const val DEEP_LINK_URI = "hojaty://prayer_times"
        private const val COMPACT_HEIGHT_THRESHOLD_DP = 100

        fun refreshAllWidgets(context: Context) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = ComponentName(context, PrayerWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
            if (appWidgetIds.isEmpty()) {
                cancelRolloverAlarm(context)
                return
            }

            val nowMs = System.currentTimeMillis()
            val resolved = PrayerWidgetDataStore.resolveNextPrayer(context, nowMs)
            val language = resolved?.language ?: PrayerWidgetDataStore.resolveLanguage(context)

            for (appWidgetId in appWidgetIds) {
                val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
                updateSingleWidget(
                    context = context,
                    appWidgetManager = appWidgetManager,
                    appWidgetId = appWidgetId,
                    options = options,
                    resolved = resolved,
                    language = language,
                    nowMs = nowMs
                )
            }

            if (resolved != null && resolved.timestampMs > nowMs) {
                scheduleRolloverAlarm(context, resolved.timestampMs + 1000L)
            } else {
                cancelRolloverAlarm(context)
            }
        }

        private fun updateSingleWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            options: Bundle?,
            resolved: ResolvedWidgetPrayer?,
            language: String,
            nowMs: Long
        ) {
            val minHeightDp = options?.getInt(
                AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT,
                120
            ) ?: 120
            val isCompact = minHeightDp in 1 until COMPACT_HEIGHT_THRESHOLD_DP
            val layoutId = if (isCompact) {
                R.layout.prayer_widget_layout_compact
            } else {
                R.layout.prayer_widget_layout
            }

            val views = RemoteViews(context.packageName, layoutId)
            val launchIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse(DEEP_LINK_URI)
            )
            views.setOnClickPendingIntent(R.id.widget_root, launchIntent)

            val isArabic = language == "ar"

            if (resolved == null || resolved.timestampMs <= nowMs) {
                views.setViewVisibility(R.id.widget_content_container, View.GONE)
                views.setViewVisibility(R.id.widget_fallback_container, View.VISIBLE)
                views.setTextViewText(
                    R.id.widget_fallback_text,
                    if (isArabic) "افتح التطبيق لتحديث المواقيت" else "Open app to update prayer times"
                )
            } else {
                views.setViewVisibility(R.id.widget_content_container, View.VISIBLE)
                views.setViewVisibility(R.id.widget_fallback_container, View.GONE)

                views.setImageViewResource(
                    R.id.widget_prayer_icon,
                    resolvePrayerIconRes(resolved.prayerKey)
                )
                views.setTextViewText(R.id.widget_prayer_name, resolved.displayName)
                views.setTextViewText(
                    R.id.widget_remaining_label,
                    if (isArabic) "المتبقي" else "Remaining"
                )

                if (isCompact) {
                    val compactSubtext = if (resolved.locationName.isNotBlank()) {
                        "${resolved.timeFormatted} • ${resolved.locationName}"
                    } else {
                        resolved.timeFormatted
                    }
                    views.setTextViewText(R.id.widget_prayer_time, compactSubtext)
                } else {
                    views.setTextViewText(
                        R.id.widget_next_label,
                        if (isArabic) "الصلاة القادمة" else "Next Prayer"
                    )
                    views.setTextViewText(R.id.widget_prayer_time, resolved.timeFormatted)

                    val hasLocation = resolved.locationName.isNotBlank()
                    val hasHijri = resolved.hijriDate.isNotBlank()
                    if (hasLocation || hasHijri) {
                        views.setViewVisibility(R.id.widget_meta_row, View.VISIBLE)
                        views.setViewVisibility(
                            R.id.widget_location_icon,
                            if (hasLocation) View.VISIBLE else View.GONE
                        )
                        views.setTextViewText(R.id.widget_location_name, resolved.locationName)
                        views.setViewVisibility(
                            R.id.widget_hijri_date,
                            if (hasHijri) View.VISIBLE else View.GONE
                        )
                        views.setTextViewText(R.id.widget_hijri_date, resolved.hijriDate)
                    } else {
                        views.setViewVisibility(R.id.widget_meta_row, View.GONE)
                    }
                }

                val remainingMs = (resolved.timestampMs - nowMs).coerceAtLeast(0L)
                val chronometerBase = SystemClock.elapsedRealtime() + remainingMs
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    views.setChronometerCountDown(R.id.widget_countdown, true)
                }
                views.setChronometer(R.id.widget_countdown, chronometerBase, null, true)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun resolvePrayerIconRes(prayerKey: String): Int {
            return when (prayerKey) {
                "fajr" -> R.drawable.ic_widget_fajr
                "sunrise" -> R.drawable.ic_widget_sunrise
                "dhuhr" -> R.drawable.ic_widget_dhuhr
                "asr" -> R.drawable.ic_widget_asr
                "maghrib" -> R.drawable.ic_widget_maghrib
                "isha" -> R.drawable.ic_widget_isha
                else -> R.drawable.ic_widget_fajr
            }
        }

        private fun scheduleRolloverAlarm(context: Context, triggerAtMs: Long) {
            val alarmManager =
                context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
            val intent = Intent(context, PrayerWidgetRolloverReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                ROLLOVER_ALARM_REQUEST_CODE,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        if (alarmManager.canScheduleExactAlarms()) {
                            alarmManager.setExactAndAllowWhileIdle(
                                AlarmManager.RTC_WAKEUP,
                                triggerAtMs,
                                pendingIntent
                            )
                        } else {
                            alarmManager.setAndAllowWhileIdle(
                                AlarmManager.RTC_WAKEUP,
                                triggerAtMs,
                                pendingIntent
                            )
                        }
                    } else {
                        alarmManager.setExactAndAllowWhileIdle(
                            AlarmManager.RTC_WAKEUP,
                            triggerAtMs,
                            pendingIntent
                        )
                    }
                } else {
                    alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerAtMs, pendingIntent)
                }
                Log.i(TAG, "Scheduled widget rollover alarm at $triggerAtMs")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to schedule widget rollover alarm: ${e.message}")
            }
        }

        fun cancelRolloverAlarm(context: Context) {
            val alarmManager =
                context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
            val intent = Intent(context, PrayerWidgetRolloverReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                ROLLOVER_ALARM_REQUEST_CODE,
                intent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
            ) ?: return
            alarmManager.cancel(pendingIntent)
            pendingIntent.cancel()
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        refreshAllWidgets(context)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        val nowMs = System.currentTimeMillis()
        val resolved = PrayerWidgetDataStore.resolveNextPrayer(context, nowMs)
        val language = resolved?.language ?: PrayerWidgetDataStore.resolveLanguage(context)
        updateSingleWidget(
            context = context,
            appWidgetManager = appWidgetManager,
            appWidgetId = appWidgetId,
            options = newOptions,
            resolved = resolved,
            language = language,
            nowMs = nowMs
        )
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        cancelRolloverAlarm(context)
    }
}

package com.wolfdev.hojaty

import android.content.Context
import android.content.SharedPreferences
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import java.util.Locale

data class ResolvedWidgetPrayer(
    val prayerKey: String,
    val nameAr: String,
    val nameEn: String,
    val timeFormatted: String,
    val timestampMs: Long,
    val locationName: String,
    val hijriDate: String,
    val language: String
) {
    val isArabic: Boolean
        get() = language == "ar"

    val displayName: String
        get() = if (isArabic) nameAr else nameEn
}

object PrayerWidgetDataStore {
    private const val KEY_PRAYER_KEY = "prayer_key"
    private const val KEY_NAME_AR = "next_prayer_name_ar"
    private const val KEY_NAME_EN = "next_prayer_name_en"
    private const val KEY_TIME_FORMATTED = "next_prayer_time_formatted"
    private const val KEY_TIMESTAMP_MS = "next_prayer_timestamp_ms"
    private const val KEY_LOCATION_NAME = "location_name"
    private const val KEY_HIJRI_DATE = "hijri_date"
    private const val KEY_LANGUAGE = "language"
    private const val KEY_SCHEDULE_JSON = "prayer_schedule_json"
    private const val KEY_IS_INITIALIZED = "is_initialized"

    fun resolveLanguage(context: Context): String {
        val prefs = HomeWidgetPlugin.getData(context)
        val saved = prefs.getString(KEY_LANGUAGE, null)
        if (!saved.isNullOrBlank()) return saved
        return if (Locale.getDefault().language == "en") "en" else "ar"
    }

    fun resolveNextPrayer(
        context: Context,
        nowMs: Long = System.currentTimeMillis()
    ): ResolvedWidgetPrayer? {
        val prefs = HomeWidgetPlugin.getData(context)
        if (!prefs.getBoolean(KEY_IS_INITIALIZED, false)) {
            return null
        }

        val language = resolveLanguage(context)
        val locationName = prefs.getString(KEY_LOCATION_NAME, "") ?: ""
        val hijriDate = prefs.getString(KEY_HIJRI_DATE, "") ?: ""
        val scheduleJson = prefs.getString(KEY_SCHEDULE_JSON, null)

        if (!scheduleJson.isNullOrBlank()) {
            try {
                val array = JSONArray(scheduleJson)
                for (i in 0 until array.length()) {
                    val obj = array.getJSONObject(i)
                    val ts = obj.optLong("timestampMs", 0L)
                    if (ts > nowMs) {
                        val key = obj.optString("key", "fajr")
                        val nameAr = obj.optString("nameAr", "")
                        val nameEn = obj.optString("nameEn", "")
                        val formatted = if (language == "ar") {
                            obj.optString("timeFormattedAr", "")
                        } else {
                            obj.optString("timeFormattedEn", "")
                        }
                        if (nameAr.isNotEmpty() || nameEn.isNotEmpty()) {
                            return ResolvedWidgetPrayer(
                                prayerKey = key,
                                nameAr = nameAr,
                                nameEn = nameEn,
                                timeFormatted = formatted,
                                timestampMs = ts,
                                locationName = locationName,
                                hijriDate = hijriDate,
                                language = language
                            )
                        }
                    }
                }
            } catch (_: Exception) {
                // Fall through to flat keys
            }
        }

        val fallbackTs = getLongCompat(prefs, KEY_TIMESTAMP_MS)
        if (fallbackTs <= nowMs) {
            return null
        }

        val nameAr = prefs.getString(KEY_NAME_AR, "") ?: ""
        val nameEn = prefs.getString(KEY_NAME_EN, "") ?: ""
        if (nameAr.isEmpty() && nameEn.isEmpty()) {
            return null
        }

        return ResolvedWidgetPrayer(
            prayerKey = prefs.getString(KEY_PRAYER_KEY, "fajr") ?: "fajr",
            nameAr = nameAr,
            nameEn = nameEn,
            timeFormatted = prefs.getString(KEY_TIME_FORMATTED, "") ?: "",
            timestampMs = fallbackTs,
            locationName = locationName,
            hijriDate = hijriDate,
            language = language
        )
    }

    private fun getLongCompat(prefs: SharedPreferences, key: String): Long {
        return try {
            prefs.getLong(key, 0L)
        } catch (_: ClassCastException) {
            try {
                prefs.getInt(key, 0).toLong()
            } catch (_: Exception) {
                0L
            }
        }
    }
}

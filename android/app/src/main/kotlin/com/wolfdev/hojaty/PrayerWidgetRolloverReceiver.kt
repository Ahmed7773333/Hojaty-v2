package com.wolfdev.hojaty

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class PrayerWidgetRolloverReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "PrayerWidgetRollover"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.i(TAG, "Advancing home screen prayer widget to next prayer.")
        PrayerWidgetProvider.refreshAllWidgets(context)
    }
}

package com.wolfdev.hojaty

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class HojatyBootReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "HojatyBootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.i(TAG, "Device rebooted or app updated. Action: $action")

        // Re-arm hourly Salawat if user previously enabled it
        if (HojatyAlarmScheduler.isSalawatEnabled(context)) {
            HojatyAlarmScheduler.scheduleNextHourlySalawat(context)
            Log.i(TAG, "Re-armed hourly Salawat reminder after boot.")
        }
    }
}


package com.wolfdev.hojaty

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat

class HojatyActionReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "HojatyActionReceiver"
        const val ACTION_STOP_AZAN = "com.wolfdev.hojaty.ACTION_STOP_AZAN"
        const val ACTION_DISMISS = "com.wolfdev.hojaty.ACTION_DISMISS"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        val notificationId = intent.getIntExtra("notificationId", -1)
        Log.i(TAG, "Received action: $action for notificationId: $notificationId")

        when (action) {
            ACTION_STOP_AZAN -> {
                AzanNativePlayer.stop()
                AzanFlipDetector.stop()

                val notificationManager = NotificationManagerCompat.from(context)
                if (notificationId != -1) {
                    notificationManager.cancel(notificationId)
                }
                // Cancel all prayer IDs just in case
                for (id in 100..105) {
                    notificationManager.cancel(id)
                }
                notificationManager.cancel(999)
                notificationManager.cancel(996)
            }
            ACTION_DISMISS -> {
                if (notificationId != -1) {
                    NotificationManagerCompat.from(context).cancel(notificationId)
                }
            }
        }
    }
}


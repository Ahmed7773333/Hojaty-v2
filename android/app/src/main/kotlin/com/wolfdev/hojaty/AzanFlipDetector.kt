package com.wolfdev.hojaty

import android.app.NotificationManager
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.util.Log

object AzanFlipDetector : SensorEventListener {
    private const val TAG = "AzanFlipDetector"

    // Max duration to keep sensor active if user does not flip phone (240s = 4 minutes)
    private const val MAX_ACTIVE_DURATION_MS = 240_000L

    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var isListening = false
    private var currentNotificationId: Int? = null
    private var appContext: Context? = null
    private var wakeLock: PowerManager.WakeLock? = null

    private val handler = Handler(Looper.getMainLooper())

    // Flip detection state
    private var wasFaceUpOrNeutral = false
    private var faceDownConsecutiveCount = 0

    // Callback to MainActivity / Flutter
    var onAzanStoppedCallback: ((Int?) -> Unit)? = null

    private val timeoutRunnable = Runnable {
        Log.d(TAG, "Timeout reached ($MAX_ACTIVE_DURATION_MS ms), stopping flip detector")
        stop()
    }

    @Synchronized
    fun start(context: Context, notificationId: Int?) {
        if (isListening && currentNotificationId == notificationId) {
            Log.d(TAG, "Already listening for notification ID: $notificationId")
            return
        }

        if (isListening) {
            stop()
        }

        appContext = context.applicationContext
        currentNotificationId = notificationId
        wasFaceUpOrNeutral = false
        faceDownConsecutiveCount = 0

        val ctx = appContext ?: return
        sensorManager = ctx.getSystemService(Context.SENSOR_SERVICE) as? SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        if (sensorManager == null || accelerometer == null) {
            Log.w(TAG, "Accelerometer sensor not available on this device")
            return
        }

        // Acquire partial wake lock to keep CPU awake while monitoring for flip
        try {
            val powerManager = ctx.getSystemService(Context.POWER_SERVICE) as? PowerManager
            wakeLock = powerManager?.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "Hojaty:AzanFlipDetectorWakeLock"
            )?.apply {
                setReferenceCounted(false)
                acquire(MAX_ACTIVE_DURATION_MS)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Could not acquire WakeLock: ${e.message}")
        }

        val registered = sensorManager?.registerListener(
            this,
            accelerometer,
            SensorManager.SENSOR_DELAY_NORMAL
        ) ?: false

        if (registered) {
            isListening = true
            handler.removeCallbacks(timeoutRunnable)
            handler.postDelayed(timeoutRunnable, MAX_ACTIVE_DURATION_MS)
            Log.i(TAG, "AzanFlipDetector started successfully for notification ID: $notificationId")
        } else {
            Log.w(TAG, "Failed to register accelerometer listener")
            releaseWakeLock()
        }
    }

    @Synchronized
    fun stop() {
        if (!isListening) return

        handler.removeCallbacks(timeoutRunnable)

        try {
            sensorManager?.unregisterListener(this)
        } catch (e: Exception) {
            Log.w(TAG, "Error unregistering sensor listener: ${e.message}")
        }

        releaseWakeLock()

        isListening = false
        wasFaceUpOrNeutral = false
        faceDownConsecutiveCount = 0
        Log.i(TAG, "AzanFlipDetector stopped for notification ID: $currentNotificationId")
        currentNotificationId = null
    }

    private fun releaseWakeLock() {
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
            }
        } catch (e: Exception) {
            Log.w(TAG, "Error releasing WakeLock: ${e.message}")
        }
        wakeLock = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null || !isListening) return

        val x = event.values[0]
        val y = event.values[1]
        val z = event.values[2]

        // 1. Check if phone is in face-up or upright/neutral position:
        // When screen is facing up: z is around +9.8 m/s²
        // When upright in hand: y is around +9.8 m/s², z is around 0
        // If z > -3.0 m/s², screen is not facing down.
        if (z > -3.0f) {
            wasFaceUpOrNeutral = true
            faceDownConsecutiveCount = 0
            return
        }

        // 2. Check if phone is now flipped face down:
        // Lying on face: z is strongly negative (<= -7.0 m/s²), x and y are close to 0.
        val horizontalPlane = Math.sqrt((x * x + y * y).toDouble())
        val isFaceDown = z <= -7.0f && horizontalPlane < 6.0

        if (isFaceDown && wasFaceUpOrNeutral) {
            faceDownConsecutiveCount++
            // Require 2 consecutive events (approx 150-200ms) to confirm intentional flip
            if (faceDownConsecutiveCount >= 2) {
                Log.i(TAG, "Flip detected! Phone placed face down. Stopping Azan notification: $currentNotificationId")
                cancelAzanNotification()
            }
        } else {
            faceDownConsecutiveCount = 0
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    private fun cancelAzanNotification() {
        val ctx = appContext
        val notifId = currentNotificationId

        if (ctx != null) {
            try {
                val notificationManager = ctx.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
                if (notifId != null) {
                    notificationManager?.cancel(notifId)
                }
                // Cancel all standard prayer notification IDs (100 to 105) and test ID (999)
                for (id in 100..105) {
                    notificationManager?.cancel(id)
                }
                notificationManager?.cancel(999)
            } catch (e: Exception) {
                Log.e(TAG, "Error cancelling notification: ${e.message}")
            }
        }

        // Notify Flutter if active
        handler.post {
            try {
                onAzanStoppedCallback?.invoke(notifId)
            } catch (_: Exception) {}
        }

        // Stop detector after successful flip
        stop()
    }
}

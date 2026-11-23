package com.wolfdev.hojaty

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import android.os.PowerManager
import android.util.Log
import java.io.File

object AzanNativePlayer {
    private const val TAG = "AzanNativePlayer"
    private var mediaPlayer: MediaPlayer? = null
    private var wakeLock: PowerManager.WakeLock? = null

    val isPlaying: Boolean
        @Synchronized
        get() = try {
            mediaPlayer?.isPlaying == true
        } catch (_: Exception) {
            false
        }

    @Synchronized
    fun play(context: Context, soundPath: String?, soundId: String?) {
        stop()

        val appContext = context.applicationContext

        // Acquire WakeLock to ensure audio continues even if screen turns off
        try {
            val pm = appContext.getSystemService(Context.POWER_SERVICE) as? PowerManager
            wakeLock = pm?.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "Hojaty:AzanNativePlayerWakeLock"
            )?.apply {
                setReferenceCounted(false)
                acquire(240_000L) // Max 4 minutes
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to acquire WakeLock: ${e.message}")
        }

        try {
            val player = MediaPlayer()

            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                .build()
            player.setAudioAttributes(audioAttributes)

            var sourceConfigured = false

            // 1. Try custom local file path first if provided
            if (!soundPath.isNullOrEmpty()) {
                val file = File(soundPath)
                if (file.exists() && file.length() > 0) {
                    player.setDataSource(file.absolutePath)
                    sourceConfigured = true
                    Log.i(TAG, "Configured player with custom local file: ${file.absolutePath}")
                } else {
                    Log.w(TAG, "Custom file does not exist or empty: $soundPath")
                }
            }

            // 2. Fallback to raw resource if custom file not available
            if (!sourceConfigured && !soundId.isNullOrEmpty()) {
                val rawResName = when (soundId.lowercase()) {
                    "madinah", "madina" -> "madina_azan"
                    "azan", "traditional" -> "azan"
                    else -> "makka_azan"
                }
                val rawResId = appContext.resources.getIdentifier(
                    rawResName,
                    "raw",
                    appContext.packageName
                )
                if (rawResId != 0) {
                    val afd = appContext.resources.openRawResourceFd(rawResId)
                    if (afd != null) {
                        player.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                        afd.close()
                        sourceConfigured = true
                        Log.i(TAG, "Configured player with raw resource: $rawResName (ID: $rawResId)")
                    }
                } else {
                    Log.w(TAG, "Raw resource not found for soundId: $soundId")
                }
            }

            if (!sourceConfigured) {
                Log.w(TAG, "No valid audio source found for Azan (soundPath: $soundPath, soundId: $soundId)")
                releaseWakeLock()
                return
            }

            player.setOnPreparedListener { mp ->
                try {
                    mp.start()
                    Log.i(TAG, "AzanNativePlayer started playback successfully.")
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting MediaPlayer onPrepared: ${e.message}")
                    stop()
                }
            }

            player.setOnCompletionListener {
                Log.i(TAG, "AzanNativePlayer completed playback.")
                stop()
            }

            player.setOnErrorListener { _, what, extra ->
                Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                stop()
                true
            }

            mediaPlayer = player
            player.prepareAsync()

        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize AzanNativePlayer: ${e.message}", e)
            stop()
        }
    }

    @Synchronized
    fun stop() {
        try {
            mediaPlayer?.let { player ->
                if (player.isPlaying) {
                    player.stop()
                }
                player.reset()
                player.release()
            }
        } catch (e: Exception) {
            Log.w(TAG, "Error stopping MediaPlayer: ${e.message}")
        }
        mediaPlayer = null
        releaseWakeLock()
        Log.i(TAG, "AzanNativePlayer stopped and resources released.")
    }

    private fun releaseWakeLock() {
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
            }
        } catch (_: Exception) {}
        wakeLock = null
    }
}


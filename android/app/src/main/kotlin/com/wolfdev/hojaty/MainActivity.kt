package com.wolfdev.hojaty

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

import com.google.android.play.core.assetpacks.AssetPackLocation
import com.google.android.play.core.assetpacks.AssetPackManager
import com.google.android.play.core.assetpacks.AssetPackManagerFactory
import com.google.android.play.core.assetpacks.AssetPackState
import com.google.android.play.core.assetpacks.AssetPackStateUpdateListener
import com.google.android.play.core.assetpacks.model.AssetPackStatus
import me.carda.awesome_notifications.AwesomeNotificationsFlutterExtension
import me.carda.awesome_notifications.core.AwesomeNotifications

class MainActivity : AudioServiceActivity() {
    companion object {
        private const val ASSET_CHANNEL = "com.wolfdev.hojaty/asset_delivery"
        private const val COMPASS_CHANNEL = "com.wolfdev.hojaty/compass"
        private const val FLIP_CHANNEL = "com.wolfdev.hojaty/azan_flip"
    }

    private var assetPackListener: AssetPackStateUpdateListener? = null
    private var assetMethodChannel: MethodChannel? = null
    private var compassEventChannel: EventChannel? = null
    private var flipMethodChannel: MethodChannel? = null
    private var sensorManager: SensorManager? = null
    private var compassListener: SensorEventListener? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        assetMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ASSET_CHANNEL).apply {
            setMethodCallHandler { call, result ->
                val packName = call.argument<String>("packName") ?: "quran_hafs"
                val assetPackManager = AssetPackManagerFactory.getInstance(applicationContext)

                when (call.method) {
                    "getAssetPackStatus" -> {
                        val location = assetPackManager.getPackLocation(packName)
                        val path = location?.assetsPath()
                        if (path != null && java.io.File(path).exists()) {
                            result.success(mapOf(
                                "status" to "COMPLETED",
                                "isDownloaded" to true,
                                "assetsPath" to path,
                                "bytesDownloaded" to 0L,
                                "totalBytes" to 0L
                            ))
                            return@setMethodCallHandler
                        }

                        val localFallback = java.io.File(applicationContext.filesDir, packName)
                        if (localFallback.exists() && (localFallback.listFiles()?.isNotEmpty() == true)) {
                            result.success(mapOf(
                                "status" to "COMPLETED",
                                "isDownloaded" to true,
                                "assetsPath" to localFallback.absolutePath,
                                "bytesDownloaded" to 0L,
                                "totalBytes" to 0L
                            ))
                            return@setMethodCallHandler
                        }

                        assetPackManager.getPackStates(listOf(packName)).addOnCompleteListener { task ->
                            if (task.isSuccessful) {
                                val packStates = task.result
                                val state = packStates.packStates()[packName]
                                val statusStr = when (state?.status()) {
                                    AssetPackStatus.COMPLETED -> "COMPLETED"
                                    AssetPackStatus.DOWNLOADING -> "DOWNLOADING"
                                    AssetPackStatus.PENDING -> "PENDING"
                                    AssetPackStatus.TRANSFERRING -> "TRANSFERRING"
                                    AssetPackStatus.REQUIRES_USER_CONFIRMATION -> "REQUIRES_USER_CONFIRMATION"
                                    AssetPackStatus.FAILED -> "FAILED"
                                    AssetPackStatus.CANCELED -> "CANCELED"
                                    AssetPackStatus.WAITING_FOR_WIFI -> "WAITING_FOR_WIFI"
                                    AssetPackStatus.NOT_INSTALLED -> "NOT_INSTALLED"
                                    else -> "NOT_INSTALLED"
                                }
                                val isCompleted = state?.status() == AssetPackStatus.COMPLETED
                                val finalPath = if (isCompleted) assetPackManager.getPackLocation(packName)?.assetsPath() else null
                                result.success(mapOf(
                                    "status" to statusStr,
                                    "isDownloaded" to (isCompleted && finalPath != null),
                                    "assetsPath" to finalPath,
                                    "bytesDownloaded" to (state?.bytesDownloaded() ?: 0L),
                                    "totalBytes" to (state?.totalBytesToDownload() ?: 0L)
                                ))
                            } else {
                                result.success(mapOf(
                                    "status" to "NOT_INSTALLED",
                                    "isDownloaded" to false,
                                    "assetsPath" to null,
                                    "bytesDownloaded" to 0L,
                                    "totalBytes" to 0L
                                ))
                            }
                        }
                    }
                    "startDownload" -> {
                        if (assetPackListener == null) {
                            assetPackListener = AssetPackStateUpdateListener { state ->
                                if (state.name() == packName) {
                                    val statusStr = when (state.status()) {
                                        AssetPackStatus.COMPLETED -> "COMPLETED"
                                        AssetPackStatus.DOWNLOADING -> "DOWNLOADING"
                                        AssetPackStatus.PENDING -> "PENDING"
                                        AssetPackStatus.TRANSFERRING -> "TRANSFERRING"
                                        AssetPackStatus.REQUIRES_USER_CONFIRMATION -> "REQUIRES_USER_CONFIRMATION"
                                        AssetPackStatus.FAILED -> "FAILED"
                                        AssetPackStatus.CANCELED -> "CANCELED"
                                        AssetPackStatus.WAITING_FOR_WIFI -> "WAITING_FOR_WIFI"
                                        AssetPackStatus.NOT_INSTALLED -> "NOT_INSTALLED"
                                        else -> "UNKNOWN"
                                    }
                                    val finalPath = if (state.status() == AssetPackStatus.COMPLETED) {
                                        assetPackManager.getPackLocation(packName)?.assetsPath()
                                    } else null

                                    runOnUiThread {
                                        assetMethodChannel?.invokeMethod("onDownloadProgress", mapOf(
                                            "packName" to packName,
                                            "status" to statusStr,
                                            "bytesDownloaded" to state.bytesDownloaded(),
                                            "totalBytes" to state.totalBytesToDownload(),
                                            "assetsPath" to finalPath,
                                            "errorCode" to state.errorCode()
                                        ))
                                    }
                                }
                            }
                            assetPackManager.registerListener(assetPackListener!!)
                        }

                        assetPackManager.fetch(listOf(packName))
                            .addOnSuccessListener {
                                result.success(true)
                            }
                            .addOnFailureListener { e ->
                                result.error("FETCH_FAILED", e.message ?: "Failed to fetch asset pack", null)
                            }
                    }
                    "cancelDownload" -> {
                        assetPackManager.cancel(listOf(packName))
                        result.success(true)
                    }
                    "removeAssetPack" -> {
                        var fallbackDeleted = false
                        val localFallback = java.io.File(applicationContext.filesDir, packName)
                        if (localFallback.exists()) {
                            fallbackDeleted = localFallback.deleteRecursively()
                        }
                        try {
                            assetPackManager.removePack(packName).addOnCompleteListener { task ->
                                result.success(task.isSuccessful || fallbackDeleted)
                            }
                        } catch (e: Exception) {
                            result.success(fallbackDeleted)
                        }
                    }
                    "getAssetPackPath" -> {
                        val path = assetPackManager.getPackLocation(packName)?.assetsPath()
                        if (path != null && java.io.File(path).exists()) {
                            result.success(path)
                            return@setMethodCallHandler
                        }
                        val localFallback = java.io.File(applicationContext.filesDir, packName)
                        if (localFallback.exists() && (localFallback.listFiles()?.isNotEmpty() == true)) {
                            result.success(localFallback.absolutePath)
                            return@setMethodCallHandler
                        }
                        result.success(null)
                    }
                    "openPdf" -> {
                        val filePath = call.argument<String>("filePath")
                        if (filePath.isNullOrBlank()) {
                            result.error("INVALID_PATH", "File path is required", null)
                            return@setMethodCallHandler
                        }
                        val file = java.io.File(filePath)
                        if (!file.exists()) {
                            result.error("NOT_FOUND", "PDF file does not exist", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val uri = androidx.core.content.FileProvider.getUriForFile(
                                applicationContext,
                                "${applicationContext.packageName}.fileprovider",
                                file
                            )
                            val intent = android.content.Intent(android.content.Intent.ACTION_VIEW).apply {
                                setDataAndType(uri, "application/pdf")
                                addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION)
                                addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("OPEN_FAILED", e.message ?: "Failed to open PDF", null)
                        }
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as? SensorManager

        compassEventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, COMPASS_CHANNEL).apply {
            setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    if (events == null || sensorManager == null) {
                        events?.error("SENSOR_UNAVAILABLE", "SensorManager is unavailable", null)
                        return
                    }

                    val rotationSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
                    val orientationSensor = if (rotationSensor == null) {
                        sensorManager?.getDefaultSensor(Sensor.TYPE_ORIENTATION)
                    } else null

                    if (rotationSensor == null && orientationSensor == null) {
                        events.error("NO_SENSOR", "No compass or orientation sensor found", null)
                        return
                    }

                    compassListener = object : SensorEventListener {
                        private val rotationMatrix = FloatArray(9)
                        private val orientation = FloatArray(3)

                        override fun onSensorChanged(event: SensorEvent?) {
                            if (event == null) return

                            var azimuth = 0.0
                            var pitch = 0.0
                            var roll = 0.0

                            if (event.sensor.type == Sensor.TYPE_ROTATION_VECTOR) {
                                SensorManager.getRotationMatrixFromVector(rotationMatrix, event.values)
                                SensorManager.getOrientation(rotationMatrix, orientation)

                                azimuth = Math.toDegrees(orientation[0].toDouble())
                                if (azimuth < 0) azimuth += 360.0
                                pitch = Math.toDegrees(orientation[1].toDouble())
                                roll = Math.toDegrees(orientation[2].toDouble())
                            } else if (event.sensor.type == Sensor.TYPE_ORIENTATION) {
                                azimuth = (event.values[0].toDouble() + 360.0) % 360.0
                                pitch = event.values[1].toDouble()
                                roll = event.values[2].toDouble()
                            }

                            val map = HashMap<String, Any>()
                            map["heading"] = azimuth
                            map["pitch"] = pitch
                            map["roll"] = roll
                            map["accuracy"] = event.accuracy
                            events.success(map)
                        }

                        override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                    }

                    val chosenSensor = rotationSensor ?: orientationSensor
                    sensorManager?.registerListener(
                        compassListener,
                        chosenSensor,
                        SensorManager.SENSOR_DELAY_UI
                    )
                }

                override fun onCancel(arguments: Any?) {
                    compassListener?.let { listener ->
                        sensorManager?.unregisterListener(listener)
                    }
                    compassListener = null
                }
            })
        }

        // Configure custom AwesomeNotifications receivers with flip-to-stop support
        try {
            AwesomeNotificationsFlutterExtension.initialize()
            AwesomeNotifications.scheduleReceiverClass = PrayerScheduledReceiver::class.java
            AwesomeNotifications.dismissReceiverClass = PrayerDismissedReceiver::class.java
            AwesomeNotifications.actionReceiverClass = PrayerActionReceiver::class.java
        } catch (_: Exception) {}

        flipMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FLIP_CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "startFlipDetector" -> {
                        val notifId = call.argument<Int>("notificationId")
                        AzanFlipDetector.start(applicationContext, notifId)
                        result.success(true)
                    }
                    "stopFlipDetector" -> {
                        AzanFlipDetector.stop()
                        AzanNativePlayer.stop()
                        result.success(true)
                    }
                    "playAzanNative" -> {
                        val soundPath = call.argument<String>("soundPath")
                        val soundId = call.argument<String>("soundId")
                        AzanNativePlayer.play(applicationContext, soundPath, soundId)
                        result.success(true)
                    }
                    "stopAzanNative" -> {
                        AzanNativePlayer.stop()
                        result.success(true)
                    }
                    "isAzanNativePlaying" -> {
                        result.success(AzanNativePlayer.isPlaying)
                    }
                    else -> result.notImplemented()
                }
            }
        }

        AzanFlipDetector.onAzanStoppedCallback = { notifId ->
            runOnUiThread {
                flipMethodChannel?.invokeMethod("onAzanStoppedByFlip", mapOf("notificationId" to notifId))
            }
        }
    }

    override fun onDestroy() {
        AzanFlipDetector.onAzanStoppedCallback = null
        AzanFlipDetector.stop()
        AzanNativePlayer.stop()
        flipMethodChannel?.setMethodCallHandler(null)
        flipMethodChannel = null

        compassListener?.let { listener ->
            try {
                sensorManager?.unregisterListener(listener)
            } catch (_: Exception) {}
        }
        compassListener = null

        assetPackListener?.let { listener ->
            try {
                AssetPackManagerFactory.getInstance(applicationContext).unregisterListener(listener)
            } catch (e: Exception) {
                // Ignore cleanup error
            }
        }
        super.onDestroy()
    }
}

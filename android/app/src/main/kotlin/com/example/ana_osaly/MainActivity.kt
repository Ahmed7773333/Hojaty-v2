package com.wolfdev.hojaty

import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.google.android.play.core.assetpacks.AssetPackLocation
import com.google.android.play.core.assetpacks.AssetPackManager
import com.google.android.play.core.assetpacks.AssetPackManagerFactory
import com.google.android.play.core.assetpacks.AssetPackState
import com.google.android.play.core.assetpacks.AssetPackStateUpdateListener
import com.google.android.play.core.assetpacks.model.AssetPackStatus

class MainActivity : AudioServiceActivity() {
    companion object {
        private const val ASSET_CHANNEL = "com.wolfdev.hojaty/asset_delivery"
    }

    private var assetPackListener: AssetPackStateUpdateListener? = null
    private var assetMethodChannel: MethodChannel? = null

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
                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }

    }

    override fun onDestroy() {
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

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';

enum AssetPackStateStatus {
  unknown,
  notInstalled,
  pending,
  downloading,
  transferring,
  completed,
  failed,
  canceled,
  waitingForWifi,
  requiresUserConfirmation,
}

class AssetPackInfo {
  final String packName;
  final AssetPackStateStatus status;
  final bool isDownloaded;
  final String? assetsPath;
  final int bytesDownloaded;
  final int totalBytes;
  final int? errorCode;

  const AssetPackInfo({
    required this.packName,
    required this.status,
    required this.isDownloaded,
    this.assetsPath,
    this.bytesDownloaded = 0,
    this.totalBytes = 0,
    this.errorCode,
  });

  double get progress {
    if (totalBytes <= 0) return 0.0;
    final p = bytesDownloaded / totalBytes;
    return p.clamp(0.0, 1.0);
  }

  factory AssetPackInfo.fromMap(
    Map<dynamic, dynamic> map,
    String defaultPackName,
  ) {
    final statusStr = map['status'] as String? ?? 'UNKNOWN';
    final status = _parseStatus(statusStr);
    final isDownloaded =
        map['isDownloaded'] as bool? ??
        (status == AssetPackStateStatus.completed);
    final assetsPath = map['assetsPath'] as String?;
    final bytesDownloaded = (map['bytesDownloaded'] as num?)?.toInt() ?? 0;
    final totalBytes = (map['totalBytes'] as num?)?.toInt() ?? 0;
    final errorCode = (map['errorCode'] as num?)?.toInt();

    return AssetPackInfo(
      packName: map['packName'] as String? ?? defaultPackName,
      status: status,
      isDownloaded: isDownloaded,
      assetsPath: assetsPath,
      bytesDownloaded: bytesDownloaded,
      totalBytes: totalBytes,
      errorCode: errorCode,
    );
  }

  static AssetPackStateStatus _parseStatus(String statusStr) {
    switch (statusStr.toUpperCase()) {
      case 'COMPLETED':
        return AssetPackStateStatus.completed;
      case 'DOWNLOADING':
        return AssetPackStateStatus.downloading;
      case 'PENDING':
        return AssetPackStateStatus.pending;
      case 'TRANSFERRING':
        return AssetPackStateStatus.transferring;
      case 'REQUIRES_USER_CONFIRMATION':
        return AssetPackStateStatus.requiresUserConfirmation;
      case 'FAILED':
        return AssetPackStateStatus.failed;
      case 'CANCELED':
        return AssetPackStateStatus.canceled;
      case 'WAITING_FOR_WIFI':
        return AssetPackStateStatus.waitingForWifi;
      case 'NOT_INSTALLED':
        return AssetPackStateStatus.notInstalled;
      default:
        return AssetPackStateStatus.unknown;
    }
  }
}

class PlayAssetDeliveryService {
  static const MethodChannel _channel = MethodChannel(
    'com.wolfdev.hojaty/asset_delivery',
  );

  static final StreamController<AssetPackInfo> _progressController =
      StreamController<AssetPackInfo>.broadcast();

  static bool _handlerInitialized = false;

  static void _initHandler() {
    if (_handlerInitialized) return;
    _handlerInitialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDownloadProgress') {
        try {
          final args = call.arguments as Map<dynamic, dynamic>;
          final packName = args['packName'] as String? ?? 'quran_hafs';
          final info = AssetPackInfo.fromMap(args, packName);
          _progressController.add(info);
        } catch (e) {
          log('Error handling onDownloadProgress: $e');
        }
      }
    });
  }

  /// Stream of download progress updates for asset packs.
  static Stream<AssetPackInfo> get downloadProgressStream {
    _initHandler();
    return _progressController.stream;
  }

  /// Checks the current status of an asset pack (e.g. 'quran_hafs').
  static Future<AssetPackInfo> getAssetPackStatus(String packName) async {
    _initHandler();

    if (!Platform.isAndroid) {
      // On non-Android platforms (e.g. desktop/iOS), consider ready if dev assets or fallback exist
      return AssetPackInfo(
        packName: packName,
        status: AssetPackStateStatus.completed,
        isDownloaded: true,
        assetsPath: null,
      );
    }

    try {
      final res = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getAssetPackStatus',
        {'packName': packName},
      );

      if (res != null) {
        return AssetPackInfo.fromMap(res, packName);
      }
    } catch (e) {
      log('Error in getAssetPackStatus for $packName: $e');
    }

    return AssetPackInfo(
      packName: packName,
      status: AssetPackStateStatus.notInstalled,
      isDownloaded: false,
    );
  }

  /// Initiates fetching/downloading an on-demand asset pack from Google Play.
  static Future<bool> startDownload(String packName) async {
    _initHandler();
    if (!Platform.isAndroid) return true;

    try {
      final bool? success = await _channel.invokeMethod<bool>('startDownload', {
        'packName': packName,
      });
      return success ?? false;
    } catch (e) {
      log('Error in startDownload for $packName: $e');
      return false;
    }
  }

  /// Cancels an active asset pack download.
  static Future<bool> cancelDownload(String packName) async {
    _initHandler();
    if (!Platform.isAndroid) return true;

    try {
      final bool? success = await _channel.invokeMethod<bool>(
        'cancelDownload',
        {'packName': packName},
      );
      return success ?? false;
    } catch (e) {
      log('Error in cancelDownload for $packName: $e');
      return false;
    }
  }

  /// Returns the absolute directory path where the asset pack is installed, or null.
  static Future<String?> getAssetPackPath(String packName) async {
    if (!Platform.isAndroid) return null;
    try {
      return await _channel.invokeMethod<String>('getAssetPackPath', {
        'packName': packName,
      });
    } catch (e) {
      log('Error in getAssetPackPath for $packName: $e');
      return null;
    }
  }
}

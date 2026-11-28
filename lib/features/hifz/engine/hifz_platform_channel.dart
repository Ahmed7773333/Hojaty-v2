import 'package:flutter/services.dart';

/// Native bridge for screen wakelock during memorization and iOS iCloud backup exclusion.
class HifzPlatformChannel {
  const HifzPlatformChannel._();

  static const MethodChannel _channel = MethodChannel(
    'com.wolfdev.hojaty/hifz_platform',
  );

  static Future<void> setWakelock(bool enabled) async {
    try {
      await _channel.invokeMethod<bool>('setWakelock', {'enabled': enabled});
    } catch (_) {
      // Safe no-op on unsupported platforms / unit tests.
    }
  }

  static Future<void> excludeFromBackup(String path) async {
    try {
      await _channel.invokeMethod<bool>('excludeFromBackup', {'path': path});
    } catch (_) {
      // Safe no-op on unsupported platforms / unit tests.
    }
  }
}


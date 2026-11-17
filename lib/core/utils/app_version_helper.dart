import 'package:package_info_plus/package_info_plus.dart';

/// Resolves and caches the installed application version without build number.
class AppVersionHelper {
  AppVersionHelper._();

  static String? _cachedVersion;
  static Future<String>? _pendingVersion;

  static Future<String> getAppVersion() {
    if (_cachedVersion != null) {
      return Future.value(_cachedVersion);
    }
    return _pendingVersion ??= _loadAppVersion();
  }

  static Future<String> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      // Strip any "+build" suffix just in case a platform appends it.
      final version = info.version.split('+').first.trim();
      _cachedVersion = version;
      return version;
    } catch (_) {
      return '';
    } finally {
      _pendingVersion = null;
    }
  }
}


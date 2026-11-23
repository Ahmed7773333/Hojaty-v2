import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AppAudioArtHelper {
  static Uri? _cachedLogoUri;

  static Uri? get logoUri => _cachedLogoUri;

  static Future<Uri?> init() async {
    if (_cachedLogoUri != null) return _cachedLogoUri;
    try {
      final byteData = await rootBundle.load('assets/icons/logo.png');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/app_audio_logo.png');
      if (!await file.exists() ||
          await file.length() != byteData.lengthInBytes) {
        await file.writeAsBytes(
          byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
          flush: true,
        );
      }
      _cachedLogoUri = file.uri;
      return _cachedLogoUri;
    } catch (_) {
      return null;
    }
  }
}

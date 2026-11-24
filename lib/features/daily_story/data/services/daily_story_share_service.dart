import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Captures the story canvas as a PNG and opens the system share sheet
/// (WhatsApp Status, Instagram Stories, ...).
class DailyStoryShareService {
  static const double _minPixelRatio = 3.0;
  static const double _targetWidthPx = 1080;
  static const String _folderName = 'daily_stories';
  static const String _filePrefix = 'hojaty_story_';

  const DailyStoryShareService();

  Future<void> shareBoundary({
    required RenderRepaintBoundary boundary,
    Rect? sharePositionOrigin,
  }) async {
    final file = await _writePng(boundary);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  Future<File> _writePng(RenderRepaintBoundary boundary) async {
    // At least 3x, and enough to reach a 1080px-wide (1080x1920) export.
    final pixelRatio = math.max(
      _minPixelRatio,
      _targetWidthPx / boundary.size.width,
    );
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) {
        throw StateError('PNG encoding returned no data');
      }
      final dir = await _prepareDirectory();
      final file = File(
        '${dir.path}/$_filePrefix${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        flush: true,
      );
      return file;
    } finally {
      image.dispose();
    }
  }

  /// Returns the export folder after deleting images from previous shares.
  Future<Directory> _prepareDirectory() async {
    final temp = await getTemporaryDirectory();
    final dir = Directory('${temp.path}/$_folderName');
    if (!await dir.exists()) {
      return dir.create(recursive: true);
    }
    await for (final entity in dir.list()) {
      if (entity is File &&
          entity.uri.pathSegments.last.startsWith(_filePrefix)) {
        try {
          await entity.delete();
        } catch (_) {
          // A file still held by the share target is retried on next export.
        }
      }
    }
    return dir;
  }
}


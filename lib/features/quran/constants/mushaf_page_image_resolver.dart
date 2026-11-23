import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';

/// Resolves the image provider for a Mushaf page across debug and release asset packs.
class MushafPageImageResolver {
  const MushafPageImageResolver._();

  static ImageProvider<Object> resolve(
    int pageNumber, {
    String? basePath,
    QiratType qirat = QiratType.hafs,
  }) {
    if (kDebugMode) {
      final safePageNum =
          (pageNumber >= 1 && pageNumber <= 604) ? pageNumber : 1;
      return AssetImage('assets/debug/$safePageNum.png');
    }

    if (basePath != null && basePath.isNotEmpty) {
      final candidates = [
        File('$basePath/${qirat.folderName}/$pageNumber.png'),
        File('$basePath/$pageNumber.png'),
        File('$basePath/pages-hafs/$pageNumber.png'),
      ];
      for (final file in candidates) {
        if (file.existsSync()) {
          return FileImage(file);
        }
      }
    }

    return AssetImage('assets/images/${qirat.folderName}/$pageNumber.png');
  }
}


import 'dart:async';
import 'dart:io';
import 'package:asset_delivery/asset_delivery.dart';
import '../../domain/entities/qirat_type.dart';

class QuraanPadService {
  /// Checks if the asset pack for the given [qirat] is downloaded.
  Future<bool> isQiratDownloaded(QiratType qirat) async {
    try {
      final path = await getPageImagePath(1, qirat: qirat);
      if (path != null) {
        return File(path).existsSync();
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Checks if the default asset pack (Hafs) is downloaded.
  /// Kept for compatibility, but prefer [isQiratDownloaded].
  Future<bool> isPackDownloaded() async {
    return isQiratDownloaded(QiratType.hafs);
  }

  /// Starts the download of a specific Qira'at asset pack.
  Stream<double> downloadPack(QiratType qirat) {
    final controller = StreamController<double>();
    final assetPackName = qirat.assetPackName;

    // Start fetch
    AssetDelivery.fetch(assetPackName).catchError((e) {
      controller.addError(e);
    });

    AssetDelivery.getAssetPackStatus((statusMap) {
      // Filter status updates for our specific pack if possible,
      // but the plugin might broadcast all.
      // Ideally we check if the name matches, but the simple plugin might not expose it in the map easily
      // depending on implementation. Assuming map contains relevant info or is global.
      // However, usually `getAssetPackStatus` provides status for the requested pack if called after fetch.

      final name = statusMap['name'] as String?;
      if (name != null && name != assetPackName) {
        // Ignore updates for other packs
        return;
      }

      final status = statusMap['status'] as String?;
      final progress =
          (statusMap['downloadProgress'] as num?)?.toDouble() ?? 0.0;

      if (status == 'COMPLETED') {
        controller.add(1.0);
        controller.close();
      } else if (status == 'DOWNLOADING') {
        controller.add(progress);
      } else if (status == 'TRANSFERRING') {
        controller.add(0.99);
      } else if (status != null && status.toLowerCase().contains('failed')) {
        controller.addError(Exception(status));
        controller.close();
      }
    });

    return controller.stream;
  }

  /// Gets the file path for a specific page image.
  Future<String?> getPageImagePath(
    int pageNum, {
    QiratType qirat = QiratType.hafs,
  }) async {
    try {
      final assetPackPath = await AssetDelivery.getAssetPackPath(
        assetPackName: qirat.assetPackName,
        // Arguments 'count', 'namingPattern', and 'fileExtension' are required by the API
        // but are only used on iOS. We provide dummy or plausible values.
        count: 604,
        namingPattern: '${qirat.folderName}/',
        fileExtension: 'png',
      );

      if (assetPackPath == null) return null;

      // Construct path to specific file.
      return '$assetPackPath/${qirat.folderName}/$pageNum.png';
    } catch (e) {
      return null;
    }
  }
}

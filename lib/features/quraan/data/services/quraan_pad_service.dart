import 'dart:async';
import 'dart:io';
import 'package:asset_delivery/asset_delivery.dart';

class QuraanPadService {
  final String _assetPackName = 'quran_assets';

  /// Checks if the asset pack is already downloaded and ready.
  Future<bool> isPackDownloaded() async {
    try {
      final path = await getPageImagePath(1);
      if (path != null) {
        return File(path).existsSync();
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Starts the download of the asset pack.
  Stream<double> downloadPack() {
    final controller = StreamController<double>();

    // Start fetch
    AssetDelivery.fetch(_assetPackName).catchError((e) {
      controller.addError(e);
    });

    AssetDelivery.getAssetPackStatus((statusMap) {
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
  Future<String?> getPageImagePath(int pageNum) async {
    try {
      final assetPackPath = await AssetDelivery.getAssetPackPath(
        assetPackName: _assetPackName,
        // Arguments 'count', 'namingPattern', and 'fileExtension' are required by the API
        // but are only used on iOS. We provide dummy or plausible values.
        count: 604,
        namingPattern: 'pages-hafs/',
        fileExtension: 'png',
      );

      if (assetPackPath == null) return null;

      // Construct path to specific file.
      // Assuming the asset pack contains the 'pages-hafs' directory.
      return '$assetPackPath/pages-hafs/$pageNum.png';
    } catch (e) {
      return null;
    }
  }
}

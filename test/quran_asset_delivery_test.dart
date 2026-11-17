import 'package:hojaty/core/utils/play_asset_delivery_service.dart';
import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QiratType on-demand availability check', () {
    // Only Hafs is currently available as on-demand asset
    expect(QiratType.hafs.isAvailable, isTrue);
    expect(QiratType.hafs.assetPackName, 'quran_hafs');

    // Other Qira'at are marked unavailable (Coming Soon)
    expect(QiratType.douri.isAvailable, isFalse);
    expect(QiratType.qalon.isAvailable, isFalse);
    expect(QiratType.shubah.isAvailable, isFalse);
    expect(QiratType.warsh.isAvailable, isFalse);
  });

  test('AssetPackInfo progress and status parsing', () {
    final mapCompleted = {
      'packName': 'quran_hafs',
      'status': 'COMPLETED',
      'isDownloaded': true,
      'assetsPath':
          '/data/user/0/com.wolfdev.hojaty/files/assetpacks/quran_hafs',
      'bytesDownloaded': 146800640,
      'totalBytes': 146800640,
    };

    final infoCompleted = AssetPackInfo.fromMap(mapCompleted, 'quran_hafs');
    expect(infoCompleted.isDownloaded, isTrue);
    expect(infoCompleted.status, AssetPackStateStatus.completed);
    expect(infoCompleted.assetsPath, isNotNull);
    expect(infoCompleted.progress, 1.0);

    final mapDownloading = {
      'packName': 'quran_hafs',
      'status': 'DOWNLOADING',
      'isDownloaded': false,
      'assetsPath': null,
      'bytesDownloaded': 73400320,
      'totalBytes': 146800640,
    };

    final infoDownloading = AssetPackInfo.fromMap(mapDownloading, 'quran_hafs');
    expect(infoDownloading.isDownloaded, isFalse);
    expect(infoDownloading.status, AssetPackStateStatus.downloading);
    expect(infoDownloading.progress, closeTo(0.5, 0.01));
  });
}

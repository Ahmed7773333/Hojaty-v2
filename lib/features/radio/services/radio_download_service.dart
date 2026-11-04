import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class RadioDownloadService {
  final Dio _dio;

  RadioDownloadService(this._dio);

  String _sanitize(String name) {
    return name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
  }

  String _getFileName(String reciterName, int surahId) {
    return '${_sanitize(reciterName)}_$surahId.mp3';
  }

  Future<String> getLocalFilePath(String reciterName, int surahId) async {
    final dir = await getApplicationDocumentsDirectory();
    final radioDir = Directory('${dir.path}/radio_downloads');
    if (!await radioDir.exists()) {
      await radioDir.create(recursive: true);
    }
    return '${radioDir.path}/${_getFileName(reciterName, surahId)}';
  }

  Future<String?> getExistingLocalPath(String reciterName, int surahId) async {
    try {
      final filePath = await getLocalFilePath(reciterName, surahId);
      final file = File(filePath);
      if (await file.exists() && await file.length() > 0) {
        return filePath;
      }
      return null;
    } catch (e) {
      debugPrint('RadioDownloadService getExistingLocalPath error: $e');
      return null;
    }
  }

  Future<bool> isDownloaded(String reciterName, int surahId) async {
    final path = await getExistingLocalPath(reciterName, surahId);
    return path != null;
  }

  Future<String> downloadSurah({
    required String url,
    required String reciterName,
    required int surahId,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final savePath = await getLocalFilePath(reciterName, surahId);
    final tempPath = '$savePath.tmp';

    try {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      await _dio.download(
        url,
        tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      final downloadedFile = File(tempPath);
      if (await downloadedFile.exists()) {
        await downloadedFile.rename(savePath);
      }

      return savePath;
    } on DioException catch (e) {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      debugPrint('RadioDownloadService DioException: $e');
      rethrow;
    } catch (e) {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      debugPrint('RadioDownloadService general error: $e');
      rethrow;
    }
  }

  Future<bool> deleteDownloadedSurah(String reciterName, int surahId) async {
    try {
      final path = await getLocalFilePath(reciterName, surahId);
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('RadioDownloadService delete error: $e');
      return false;
    }
  }
}


import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/azan_audio_item_model.dart';

class AzanAudioService {
  final Dio _dio;
  static const String _azansJsonPath = 'assets/data/azans.json';

  List<AzanAudioItemModel>? _cachedList;

  AzanAudioService([Dio? dio]) : _dio = dio ?? Dio();

  static const List<AzanAudioItemModel> builtInAzans = [
    AzanAudioItemModel(
      id: 'makkah',
      title: 'أذان مكة المكرمة',
      file: 'makka azan.mp3',
      url: '',
      durationSec: 215,
      sizeKb: 461,
      isDownloaded: true,
      isBuiltIn: true,
      localPath: 'assets/audio/makka azan.mp3',
    ),
    AzanAudioItemModel(
      id: 'madinah',
      title: 'أذان المدينة المنورة',
      file: 'madina azan.mp3',
      url: '',
      durationSec: 210,
      sizeKb: 509,
      isDownloaded: true,
      isBuiltIn: true,
      localPath: 'assets/audio/madina azan.mp3',
    ),
    AzanAudioItemModel(
      id: 'azan',
      title: 'الأذان التقليدي',
      file: 'azan.mp3',
      url: '',
      durationSec: 180,
      sizeKb: 655,
      isDownloaded: true,
      isBuiltIn: true,
      localPath: 'assets/audio/azan.mp3',
    ),
  ];

  Future<String> getAzansDirectoryPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final azansDir = Directory('${dir.path}/azans');
    if (!await azansDir.exists()) {
      await azansDir.create(recursive: true);
    }
    return azansDir.path;
  }

  Future<String> getLocalFilePath(String azanId) async {
    final dirPath = await getAzansDirectoryPath();
    return '$dirPath/$azanId.mp3';
  }

  Future<String?> getExistingLocalPath(String azanId) async {
    try {
      final filePath = await getLocalFilePath(azanId);
      final file = File(filePath);
      if (await file.exists() && await file.length() > 0) {
        return filePath;
      }
      return null;
    } catch (e) {
      debugPrint('AzanAudioService getExistingLocalPath error: $e');
      return null;
    }
  }

  Future<bool> isAzanDownloaded(String azanId) async {
    if (builtInAzans.any((b) => b.id == azanId)) return true;
    final path = await getExistingLocalPath(azanId);
    return path != null;
  }

  Future<List<AzanAudioItemModel>> loadAllAzans({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedList != null) {
      return _cachedList!;
    }

    try {
      final jsonString = await rootBundle.loadString(_azansJsonPath);
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> itemsJson = data['items'] as List<dynamic>? ?? [];

      final dirPath = await getAzansDirectoryPath();

      final List<AzanAudioItemModel> items = [];

      // Add built-ins first
      items.addAll(builtInAzans);

      for (final raw in itemsJson) {
        final map = raw as Map<String, dynamic>;
        final id = map['id'] as String? ?? '';
        final localFile = File('$dirPath/$id.mp3');
        final isDownloaded = localFile.existsSync() && localFile.lengthSync() > 0;

        items.add(
          AzanAudioItemModel.fromJson(
            map,
            isDownloaded: isDownloaded,
            localPath: isDownloaded ? localFile.path : null,
          ),
        );
      }

      _cachedList = items;
      return items;
    } catch (e) {
      debugPrint('AzanAudioService loadAllAzans error: $e');
      return builtInAzans;
    }
  }

  Future<String> downloadAzan({
    required AzanAudioItemModel item,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final savePath = await getLocalFilePath(item.id);
    final tempPath = '$savePath.tmp';

    try {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      await _dio.download(
        item.url,
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

      // Update in cached list if present
      if (_cachedList != null) {
        final index = _cachedList!.indexWhere((element) => element.id == item.id);
        if (index != -1) {
          _cachedList![index] = _cachedList![index].copyWith(
            isDownloaded: true,
            localPath: savePath,
          );
        }
      }

      return savePath;
    } on DioException catch (e) {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      debugPrint('AzanAudioService DioException: $e');
      rethrow;
    } catch (e) {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      debugPrint('AzanAudioService general error: $e');
      rethrow;
    }
  }

  Future<void> deleteAzan(String azanId) async {
    try {
      final filePath = await getLocalFilePath(azanId);
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      if (_cachedList != null) {
        final index = _cachedList!.indexWhere((element) => element.id == azanId);
        if (index != -1) {
          _cachedList![index] = _cachedList![index].copyWith(
            isDownloaded: false,
            localPath: null,
          );
        }
      }
    } catch (e) {
      debugPrint('AzanAudioService deleteAzan error: $e');
    }
  }

  Future<String> getAzanTitle(String azanId) async {
    final builtIn = builtInAzans.where((b) => b.id == azanId).firstOrNull;
    if (builtIn != null) return builtIn.title;

    final all = await loadAllAzans();
    final item = all.where((a) => a.id == azanId).firstOrNull;
    return item?.title ?? azanId;
  }
}


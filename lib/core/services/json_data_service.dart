import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hojaty/core/constants/assets.dart';

class JsonDataService {
  final Dio _dio;
  static const String _boxName = 'json_data_cache';
  static const String _repoBaseUrl =
      'https://raw.githubusercontent.com/Ahmed7773333/hojaty_jsons/main/';

  // Map of asset keys to filenames in the repo
  static const Map<String, String> _files = {
    Assets.quraanPagesJsonKey: 'quran_pages.json',
    Assets.hadithJsonKey: 'hadith.json',
    Assets.allahNamesJsonKey: 'names_of_allah.json',
    Assets.prophetNamesJsonKey: 'names_of_moahmed.json',
    Assets.azkarJsonKey: 'azkar.json',
    Assets.tafseerJsonKey: 'tafseer.json',
  };

  JsonDataService(this._dio);

  Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  /// Checks if all required files are cached.
  bool isDataReady() {
    final box = Hive.box(_boxName);
    for (final key in _files.keys) {
      if (!box.containsKey(key)) {
        return false;
      }
    }
    return true;
  }

  /// Downloads all missing files and caches them.
  /// Returns a stream of progress (0.0 to 1.0).
  Stream<double> syncData() async* {
    final box = Hive.box(_boxName);
    int totalFiles = _files.length;
    int downloadedFiles = 0;

    for (final entry in _files.entries) {
      // yield current progress
      yield downloadedFiles / totalFiles;

      final key = entry.key;
      final fileName = entry.value;

      if (!box.containsKey(key)) {
        try {
          final url = '$_repoBaseUrl$fileName';
          final response = await _dio.get<String>(
            url,
            options: Options(responseType: ResponseType.plain),
          );
          log(response.data??'error datatatatattata');
          if (response.statusCode == 200 && response.data != null) {
            await box.put(key, response.data);
          } else {
            throw Exception(
              'Failed to download $fileName: ${response.statusCode}',
            );
          }
        } catch (e) {
          debugPrint('Error downloading $fileName: $e');
          rethrow;
        }
      }
      downloadedFiles++;
    }
    yield 1.0;
  }

  /// Retrieves the JSON string for a given key.
  /// Throws if data is not found (should ensure isDataReady is true before calling).
  Future<String> loadString(String key) async {
    final box = Hive.box(_boxName);
    final data = box.get(key);
    if (data != null) {
      return data as String;
    }
    throw Exception('Data not found for key: $key. Please sync data first.');
  }

  /// Manual reload if needed
  Future<void> reloadAll() async {
    final box = Hive.box(_boxName);
    await box.clear();
    await for (final _ in syncData()) {}
  }
}

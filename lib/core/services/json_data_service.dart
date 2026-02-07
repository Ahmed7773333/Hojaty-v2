import 'dart:async';
import 'dart:io';

import 'package:asset_delivery/asset_delivery.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hojaty/core/constants/assets.dart';

class JsonDataService {
  static const String _boxName = 'json_data_cache';
  static const String _assetPackName = 'pre_opened';

  // Map of asset keys to filenames in the repo
  static const Map<String, String> _files = {
    Assets.quraanPagesJsonKey: 'quran_pages.json',
    Assets.allahNamesJsonKey: 'names_of_allah.json',
    Assets.prophetNamesJsonKey: 'names_of_moahmed.json',
    Assets.tafseerJsonKey: 'tafseer.json',
  };

  JsonDataService();

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

    // Check if we even need to sync
    if (isDataReady()) {
      yield 1.0;
      return;
    }

    yield 0.1;

    // Trigger fetch for the asset pack
    try {
      await AssetDelivery.fetch(_assetPackName);
    } catch (e) {
      debugPrint("Error fetching asset pack $_assetPackName: $e");
      // Continue to check if it's available anyway
    }

    yield 0.2;

    // Wait for the asset pack to be available
    String? assetPackPath;
    for (int i = 0; i < 30; i++) {
      assetPackPath = await AssetDelivery.getAssetPackPath(
        assetPackName: _assetPackName,
        count: 1, // Dummy for Android
        namingPattern: '', // Dummy
        fileExtension: 'json', // Dummy
      );

      if (assetPackPath != null) break;

      // Fake progress while waiting
      yield 0.2 + (0.5 * (i / 30.0));
      await Future.delayed(const Duration(seconds: 1));
    }

    if (assetPackPath == null) {
      throw Exception(
        'Failed to load asset pack $_assetPackName. Please try again.',
      );
    }

    yield 0.8;

    // Process files
    int processedCount = 0;
    for (final entry in _files.entries) {
      final key = entry.key;
      final fileName = entry.value;

      if (!box.containsKey(key)) {
        final file = File('$assetPackPath/$fileName');
        if (await file.exists()) {
          try {
            final content = await file.readAsString();
            await box.put(key, content);
          } catch (e) {
            debugPrint('Error reading/caching $fileName: $e');
            rethrow;
          }
        } else {
          debugPrint(
            'File not found in asset pack: $fileName at path $assetPackPath',
          );
          // We might want to throw here if a required file is missing
        }
      }
      processedCount++;
      yield 0.8 + (0.2 * (processedCount / _files.length));
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

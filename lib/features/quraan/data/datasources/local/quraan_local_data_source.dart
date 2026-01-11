import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/page_data.dart';
import '../../../../quraan/domain/entities/qirat_type.dart';
import 'package:hojaty/core/services/json_data_service.dart';
import 'package:hojaty/core/constants/assets.dart';

class QuraanLocalDataSource {
  final JsonDataService _jsonDataService;

  QuraanLocalDataSource(this._jsonDataService);

  static const String _boxName = 'quran_pages_box';
  static const String _settingsBoxName = 'quran_settings_box';
  static const String _lastPageKey = 'last_page';

  Future<void> init() async {
    try {
      await Hive.openBox<PageData>(_boxName);
    } catch (e) {
      debugPrint('Error opening $_boxName: $e');
      await Hive.deleteBoxFromDisk(_boxName);
      await Hive.openBox<PageData>(_boxName);
    }

    try {
      await Hive.openBox(_settingsBoxName);
    } catch (e) {
      debugPrint('Error opening $_settingsBoxName: $e');
      await Hive.deleteBoxFromDisk(_settingsBoxName);
      await Hive.openBox(_settingsBoxName);
    }
  }

  Future<List<PageData>> getPages() async {
    final box = Hive.box<PageData>(_boxName);

    if (box.isEmpty) {
      // Load from JsonDataService (remote/cache) instead of assets
      final String jsonString = await _jsonDataService.loadString(
        Assets.quraanPagesJsonKey,
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final List<PageData> pages = [];

      // Sort keys numerically to ensure order
      final sortedKeys =
          jsonMap.keys
              .map((e) => int.tryParse(e) ?? 0)
              .where((e) => e > 0)
              .toList()
            ..sort();

      for (var key in sortedKeys) {
        final pageJson = jsonMap[key.toString()];
        if (pageJson != null) {
          pages.add(PageData.fromJson(pageJson));
        }
      }

      await box.addAll(pages);
      return pages;
    }

    return box.values.toList();
  }

  Future<int> getLastPage() async {
    final box = Hive.box(_settingsBoxName);
    return box.get(_lastPageKey, defaultValue: 1);
  }

  Future<void> saveLastPage(int pageNumber) async {
    final box = Hive.box(_settingsBoxName);
    await box.put(_lastPageKey, pageNumber);
  }

  Future<QiratType> getSelectedQirat() async {
    final box = Hive.box(_settingsBoxName);
    final index = box.get('selected_qirat', defaultValue: QiratType.hafs.index);
    return QiratType.values[index];
  }

  Future<void> saveSelectedQirat(QiratType qirat) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('selected_qirat', qirat.index);
  }

  Stream<QiratType> watchSelectedQirat() {
    final box = Hive.box(_settingsBoxName);
    return box.watch(key: 'selected_qirat').map((event) {
      final index = event.value as int? ?? QiratType.hafs.index;
      return QiratType.values[index];
    });
  }
}

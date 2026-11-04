import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/qirat_type.dart';
import '../models/page_data_model.dart';

class QuranLocalDataSource {
  static const String _pagesBoxName = 'quran_pages_box';
  static const String _settingsBoxName = 'quran_settings_box';
  static const String _lastPageKey = 'last_page';
  static const String _selectedQiratKey = 'selected_qirat';
  static const String _quranJsonAssetPath = 'assets/data/quran_pages.json';

  const QuranLocalDataSource();

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(PageDataModelAdapter());
    }

    try {
      if (!Hive.isBoxOpen(_pagesBoxName)) {
        await Hive.openBox<PageDataModel>(_pagesBoxName);
      }
    } catch (e) {
      debugPrint('Error opening $_pagesBoxName: $e');
      await Hive.deleteBoxFromDisk(_pagesBoxName);
      await Hive.openBox<PageDataModel>(_pagesBoxName);
    }

    try {
      if (!Hive.isBoxOpen(_settingsBoxName)) {
        await Hive.openBox(_settingsBoxName);
      }
    } catch (e) {
      debugPrint('Error opening $_settingsBoxName: $e');
      await Hive.deleteBoxFromDisk(_settingsBoxName);
      await Hive.openBox(_settingsBoxName);
    }
  }

  Future<List<PageDataModel>> getPages() async {
    final box = Hive.box<PageDataModel>(_pagesBoxName);

    if (box.isEmpty) {
      try {
        final jsonString = await rootBundle.loadString(_quranJsonAssetPath);
        final Map<String, dynamic> jsonMap = json.decode(jsonString);

        final List<PageDataModel> pages = [];
        final sortedKeys = jsonMap.keys
            .map((e) => int.tryParse(e) ?? 0)
            .where((e) => e > 0)
            .toList()
          ..sort();

        for (final key in sortedKeys) {
          final pageJson = jsonMap[key.toString()];
          if (pageJson != null) {
            pages.add(PageDataModel.fromJson(pageJson));
          }
        }

        await box.addAll(pages);
        return pages;
      } catch (e) {
        debugPrint('Error loading Quran pages from assets/data: $e');
        return [];
      }
    }

    return box.values.toList();
  }

  Future<int> getLastPage() async {
    final box = Hive.box(_settingsBoxName);
    final value = box.get(_lastPageKey, defaultValue: 1);
    if (value is int && value >= 1 && value <= 604) {
      return value;
    }
    return 1;
  }

  Future<void> saveLastPage(int pageNumber) async {
    final box = Hive.box(_settingsBoxName);
    await box.put(_lastPageKey, pageNumber);
  }

  Future<QiratType> getSelectedQirat() async {
    final box = Hive.box(_settingsBoxName);
    final index = box.get(_selectedQiratKey, defaultValue: QiratType.hafs.index);
    if (index is int && index >= 0 && index < QiratType.values.length) {
      return QiratType.values[index];
    }
    return QiratType.hafs;
  }

  Future<void> saveSelectedQirat(QiratType qirat) async {
    final box = Hive.box(_settingsBoxName);
    await box.put(_selectedQiratKey, qirat.index);
  }

  Stream<QiratType> watchSelectedQirat() {
    final box = Hive.box(_settingsBoxName);
    return box.watch(key: _selectedQiratKey).map((event) {
      final index = event.value as int? ?? QiratType.hafs.index;
      if (index >= 0 && index < QiratType.values.length) {
        return QiratType.values[index];
      }
      return QiratType.hafs;
    });
  }
}

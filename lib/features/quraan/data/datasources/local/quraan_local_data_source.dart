import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/page_data.dart';

class QuraanLocalDataSource {
  static const String _boxName = 'quran_pages_box';
  static const String _settingsBoxName = 'quran_settings_box';
  static const String _lastPageKey = 'last_page';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PageDataAdapter());
    }
    await Hive.openBox<PageData>(_boxName);
    await Hive.openBox(_settingsBoxName);
  }

  Future<List<PageData>> getPages() async {
    final box = Hive.box<PageData>(_boxName);

    if (box.isEmpty) {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/quran_pages.json',
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
}

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/quraan_page_model.dart';

class QuraanRepository {
  static const String _quraanBoxName = 'quraan_settings';
  static const String _lastPageKey = 'last_quraan_page';

  // Cache the data so we only load it once
  Map<int, QuraanPageModel>? _cachedPages;

  Future<Map<int, QuraanPageModel>> getQuranPages() async {
    if (_cachedPages != null) return _cachedPages!;

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/quran_pages.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final Map<int, QuraanPageModel> pages = {};
      jsonMap.forEach((key, value) {
        final pageNum = int.tryParse(key);
        if (pageNum != null && value is Map<String, dynamic>) {
          pages[pageNum] = QuraanPageModel.fromJson(value);
        }
      });

      _cachedPages = pages;
      return pages;
    } catch (e) {
      // Handle error accordingly - maybe return empty map or throw
      throw Exception('Failed to load Quran pages: $e');
    }
  }

  Future<void> saveLastPage(int page) async {
    final box = await Hive.openBox(_quraanBoxName);
    await box.put(_lastPageKey, page);
  }

  Future<int> getLastPage() async {
    final box = await Hive.openBox(_quraanBoxName);
    return box.get(_lastPageKey, defaultValue: 1) as int;
  }
}

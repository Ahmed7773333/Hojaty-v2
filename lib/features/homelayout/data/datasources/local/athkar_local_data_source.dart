import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/athkar_category_model.dart';
import '../../models/thikr_item_model.dart';

class AthkarLocalDataSource {
  static const String _adhkarJsonAssetPath = 'assets/data/adhkar.json';
  static List<dynamic>? _cachedJson;

  const AthkarLocalDataSource();

  Future<List<dynamic>> _getRawData() async {
    if (_cachedJson != null) return _cachedJson!;
    try {
      final jsonString = await rootBundle.loadString(_adhkarJsonAssetPath);
      final dynamic decoded = json.decode(jsonString);
      if (decoded is List) {
        _cachedJson = decoded;
        return decoded;
      }
    } catch (_) {}
    return const [];
  }

  Future<List<ThikrItemModel>> getMorningAthkar() async {
    final data = await _getRawData();
    if (data.isEmpty) return const [];

    final firstCat = data.firstWhere(
      (element) => element['id'] == 1,
      orElse: () => null,
    );

    if (firstCat == null || firstCat['array'] == null) return const [];
    final List<dynamic> array = firstCat['array'];

    return array.map<ThikrItemModel>((item) {
      final text = item['text'] as String? ?? '';
      final count = item['count'] as int? ?? 1;
      final id = item['id']?.toString() ?? '0';

      return ThikrItemModel(
        id: id,
        text: text,
        requiredCount: count,
        audio: item['audio'] as String?,
        filename: item['filename'] as String?,
      );
    }).toList();
  }

  Future<List<ThikrItemModel>> getEveningAthkar() async {
    final data = await _getRawData();
    if (data.isEmpty) return const [];

    final firstCat = data.firstWhere(
      (element) => element['id'] == 1,
      orElse: () => null,
    );

    if (firstCat == null || firstCat['array'] == null) return const [];
    final List<dynamic> array = firstCat['array'];

    return array.map<ThikrItemModel>((item) {
      final text = item['text'] as String? ?? '';
      final count = item['count'] as int? ?? 1;
      final id = item['id']?.toString() ?? '0';

      return ThikrItemModel(
        id: id,
        text: text,
        requiredCount: count,
        audio: item['audio'] as String?,
        filename: item['filename'] as String?,
      );
    }).toList();
  }

  Future<List<ThikrItemModel>> getSleepAthkar() async {
    final data = await _getRawData();
    if (data.isEmpty) return const [];

    final cat = data.firstWhere(
      (element) => element['id'] == 2,
      orElse: () => null,
    );

    if (cat == null || cat['array'] == null) return const [];
    final List<dynamic> array = cat['array'];

    return array.map<ThikrItemModel>((item) => ThikrItemModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<ThikrItemModel>> getAfterPrayerAthkar() async {
    final data = await _getRawData();
    if (data.isEmpty) return const [];

    final cat = data.firstWhere(
      (element) => element['id'] == 27,
      orElse: () => null,
    );

    if (cat == null || cat['array'] == null) return const [];
    final List<dynamic> array = cat['array'];

    return array.map<ThikrItemModel>((item) => ThikrItemModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<ThikrItemModel>> getCategoryItems(int categoryId) async {
    final data = await _getRawData();
    if (data.isEmpty) return const [];

    final cat = data.firstWhere(
      (element) => element['id'] == categoryId,
      orElse: () => null,
    );

    if (cat == null || cat['array'] == null) return const [];
    final List<dynamic> array = cat['array'];

    return array.map<ThikrItemModel>((item) => ThikrItemModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}

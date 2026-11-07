import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../models/athkar_category_model.dart';
import '../../models/thikr_item_model.dart';

class AthkarLocalDataSource {
  static const String _adhkarJsonAssetPath = 'assets/data/adhkar.json';
  static List<dynamic>? _cachedJson;
  static List<AthkarCategoryModel>? _cachedAllCategories;
  static List<AthkarCategoryModel>? _cachedDailyCategories;

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

  Future<List<AthkarCategoryModel>> getAllCategories() async {
    if (_cachedAllCategories != null) return _cachedAllCategories!;
    final rawData = await _getRawData();
    if (rawData.isEmpty) return const [];

    final list = <AthkarCategoryModel>[];
    for (final element in rawData) {
      if (element is! Map<String, dynamic>) continue;
      final id = element['id'] as int? ?? 0;
      final categoryName = element['category'] as String? ?? '';
      final rawArray = element['array'];
      final List<ThikrItemModel> items;
      if (rawArray is List) {
        items = rawArray
            .map<ThikrItemModel>(
              (item) => ThikrItemModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        items = const [];
      }

      final AthkarCategoryType type;
      final bool isGuide;
      if (id == 1) {
        type = AthkarCategoryType.morning;
        isGuide = false;
      } else if (id == 133) {
        type = AthkarCategoryType.evening;
        isGuide = false;
      } else if (id == 2) {
        type = AthkarCategoryType.sleep;
        isGuide = false;
      } else if (id == 27) {
        type = AthkarCategoryType.afterPrayer;
        isGuide = false;
      } else if (id == 28) {
        type = AthkarCategoryType.istikhara;
        isGuide = true;
      } else {
        type = AthkarCategoryType.misc;
        isGuide = false;
      }

      list.add(
        AthkarCategoryModel(
          type: type,
          titleResolver: (_) => categoryName,
          count: items.length,
          categoryId: id,
          items: items,
          isGuide: isGuide,
        ),
      );
    }
    _cachedAllCategories = list;
    return list;
  }

  Future<List<AthkarCategoryModel>> getDailyCategories() async {
    if (_cachedDailyCategories != null) return _cachedDailyCategories!;
    final all = await getAllCategories();

    AthkarCategoryModel? findById(int id) {
      for (final cat in all) {
        if (cat.categoryId == id) return cat;
      }
      return null;
    }

    final morning = findById(1);
    final evening = findById(133);
    final sleep = findById(2);
    final afterPrayer = findById(27);
    final istikhara = findById(28);

    final list = <AthkarCategoryModel>[
      AthkarCategoryModel(
        type: AthkarCategoryType.morning,
        titleResolver: (s) => (s as AppLocalizations).morningAthkar,
        count: morning?.count ?? 23,
        categoryId: 1,
        items: morning?.items,
      ),
      AthkarCategoryModel(
        type: AthkarCategoryType.evening,
        titleResolver: (s) => (s as AppLocalizations).eveningAthkar,
        count: evening?.count ?? 21,
        categoryId: 133,
        items: evening?.items,
      ),
      AthkarCategoryModel(
        type: AthkarCategoryType.sleep,
        titleResolver: (s) => (s as AppLocalizations).sleepAthkar,
        count: sleep?.count ?? 13,
        categoryId: 2,
        items: sleep?.items,
      ),
      AthkarCategoryModel(
        type: AthkarCategoryType.afterPrayer,
        titleResolver: (s) => (s as AppLocalizations).afterPrayerAthkar,
        count: afterPrayer?.count ?? 8,
        categoryId: 27,
        items: afterPrayer?.items,
      ),
      AthkarCategoryModel(
        type: AthkarCategoryType.sebha,
        titleResolver: (s) => (s as AppLocalizations).electronicSebha,
        isGuide: true,
      ),
      AthkarCategoryModel(
        type: AthkarCategoryType.istikhara,
        titleResolver: (s) => (s as AppLocalizations).salatAlIstikhara,
        isGuide: true,
        categoryId: 28,
        items: istikhara?.items,
      ),
    ];

    _cachedDailyCategories = list;
    return list;
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

    final eveningCat = data.firstWhere(
      (element) => element['id'] == 133,
      orElse: () => null,
    );

    if (eveningCat == null || eveningCat['array'] == null) return const [];
    final List<dynamic> array = eveningCat['array'];

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

    return array
        .map<ThikrItemModel>(
          (item) => ThikrItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
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

    return array
        .map<ThikrItemModel>(
          (item) => ThikrItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
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

    return array
        .map<ThikrItemModel>(
          (item) => ThikrItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}

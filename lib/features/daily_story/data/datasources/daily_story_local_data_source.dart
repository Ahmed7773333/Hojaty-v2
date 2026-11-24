import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/features/daily_story/data/models/daily_story_model.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_history.dart';

class DailyStoryLocalDataSource {
  static const String _assetPath = 'assets/data/daily_stories.json';
  static const String _todayKeyField = 'daily_story_today_key';
  static const String _todayIdField = 'daily_story_today_id';
  static const String _recentIdsField = 'daily_story_recent_ids';
  static const String _paletteField = 'daily_story_selected_palette';

  static List<DailyStoryModel>? _cache;

  const DailyStoryLocalDataSource();

  Future<List<DailyStoryModel>> loadStories() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString(_assetPath);
    final decoded = json.decode(raw);
    if (decoded is! List) {
      throw const FormatException('daily_stories.json must be a JSON array');
    }
    final stories = decoded
        .whereType<Map<String, dynamic>>()
        .map(DailyStoryModel.fromJson)
        .where((s) => s.id.isNotEmpty && s.mainText.isNotEmpty)
        .toList(growable: false);
    _cache = stories;
    return stories;
  }

  DailyStoryHistory readHistory() {
    try {
      final box = UserHiveHelper.prayersBox;
      final recent = box.get(_recentIdsField);
      return DailyStoryHistory(
        todayKey: box.get(_todayKeyField) as int?,
        todayId: box.get(_todayIdField) as String?,
        recentIds: recent is List
            ? recent.whereType<String>().toList()
            : const [],
      );
    } catch (e, st) {
      log('DailyStory: failed to read history: $e\n$st');
      return const DailyStoryHistory();
    }
  }

  Future<void> writeHistory(DailyStoryHistory history) async {
    try {
      await UserHiveHelper.prayersBox.putAll({
        _todayKeyField: history.todayKey,
        _todayIdField: history.todayId,
        _recentIdsField: history.recentIds,
      });
    } catch (e, st) {
      log('DailyStory: failed to write history: $e\n$st');
    }
  }

  String? readPaletteKey() {
    try {
      return UserHiveHelper.prayersBox.get(_paletteField) as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> writePaletteKey(String key) async {
    try {
      await UserHiveHelper.prayersBox.put(_paletteField, key);
    } catch (e, st) {
      log('DailyStory: failed to write palette: $e\n$st');
    }
  }
}


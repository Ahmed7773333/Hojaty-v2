import 'dart:math';

import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_history.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_shuffle_result.dart';
import 'package:hojaty/features/daily_story/domain/repositories/daily_story_repository.dart';

class SelectDailyStoryUseCase {
  /// How many past daily cards are excluded from today's selection.
  static const int recentHistoryLimit = 15;

  final DailyStoryRepository _repository;
  final Random _random;

  SelectDailyStoryUseCase(this._repository, {Random? random})
      : _random = random ?? Random();

  static int dateSeed(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day;

  /// Fridays default to Salawat upon the Prophet ﷺ.
  static DailyStoryCategory defaultCategoryFor(DateTime date) =>
      date.weekday == DateTime.friday
          ? DailyStoryCategory.salawat
          : DailyStoryCategory.all;

  static List<DailyStoryEntity> filterByCategory(
    List<DailyStoryEntity> stories,
    DailyStoryCategory category,
  ) {
    if (category == DailyStoryCategory.all) return stories;
    return stories.where((s) => s.category == category).toList();
  }

  /// Returns today's card. The same card is returned for the whole day and
  /// it is remembered so it won't be picked again on the following days.
  /// [stories] must not be empty.
  Future<DailyStoryEntity> today(
    List<DailyStoryEntity> stories,
    DateTime date,
  ) async {
    final history = _repository.getHistory();
    final seed = dateSeed(date);

    if (history.todayKey == seed) {
      for (final story in stories) {
        if (story.id == history.todayId) return story;
      }
    }

    final story = pickForDate(
      stories: stories,
      date: date,
      recentIds: history.recentIds,
    );
    final recent = [
      ...history.recentIds.where((id) => id != story.id),
      story.id,
    ];
    await _repository.saveHistory(
      DailyStoryHistory(
        todayKey: seed,
        todayId: story.id,
        recentIds: recent.length > recentHistoryLimit
            ? recent.sublist(recent.length - recentHistoryLimit)
            : recent,
      ),
    );
    return story;
  }

  /// Picks today's card with a PRNG seeded by the date, skipping
  /// [recentIds]. [stories] must not be empty.
  static DailyStoryEntity pickForDate({
    required List<DailyStoryEntity> stories,
    required DateTime date,
    required List<String> recentIds,
  }) {
    final pool = filterByCategory(stories, defaultCategoryFor(date));
    final source = pool.isEmpty ? stories : pool;
    final fresh = source.where((s) => !recentIds.contains(s.id)).toList();
    final candidates = fresh.isEmpty ? source : fresh;
    return candidates[Random(dateSeed(date)).nextInt(candidates.length)];
  }

  DailyStoryShuffleResult shuffle({
    required List<DailyStoryEntity> stories,
    required DailyStoryCategory category,
    required DailyStoryEntity? current,
    required Set<String> seenIds,
  }) {
    return pickNext(
      stories: stories,
      category: category,
      current: current,
      seenIds: seenIds,
      random: _random,
    );
  }

  /// Picks a card from [category] that hasn't been seen this session. When
  /// every card has been seen, starts a new cycle (never repeating [current]).
  /// [stories] must not be empty.
  static DailyStoryShuffleResult pickNext({
    required List<DailyStoryEntity> stories,
    required DailyStoryCategory category,
    required DailyStoryEntity? current,
    required Set<String> seenIds,
    required Random random,
  }) {
    final pool = filterByCategory(stories, category);
    if (pool.isEmpty) {
      final fallback = current ?? stories.first;
      return DailyStoryShuffleResult(story: fallback, seenIds: {fallback.id});
    }

    final seen = {...seenIds, if (current != null) current.id};
    var candidates = pool.where((s) => !seen.contains(s.id)).toList();
    var nextSeen = seen;

    if (candidates.isEmpty) {
      candidates = pool.where((s) => s.id != current?.id).toList();
      nextSeen = {if (current != null) current.id};
      if (candidates.isEmpty) {
        return DailyStoryShuffleResult(
          story: pool.first,
          seenIds: {pool.first.id},
        );
      }
    }

    final next = candidates[random.nextInt(candidates.length)];
    return DailyStoryShuffleResult(
      story: next,
      seenIds: {...nextSeen, next.id},
    );
  }
}


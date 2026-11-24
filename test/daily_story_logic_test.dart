import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:hojaty/features/daily_story/data/models/daily_story_model.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/domain/usecases/select_daily_story_use_case.dart';

void main() {
  // 1. Validate assets/data/daily_stories.json structure & counts
  final file = File('assets/data/daily_stories.json');
  assert(file.existsSync(), 'daily_stories.json must exist');
  final decoded = json.decode(file.readAsStringSync()) as List<dynamic>;
  final stories = decoded
      .whereType<Map<String, dynamic>>()
      .map(DailyStoryModel.fromJson)
      .toList();

  assert(stories.length == 60, 'Expected 60 stories, got ${stories.length}');
  final ids = stories.map((s) => s.id).toSet();
  assert(ids.length == 60, 'All story IDs must be unique');

  final counts = <DailyStoryCategory, int>{};
  for (final story in stories) {
    assert(story.id.isNotEmpty, 'id must not be empty');
    assert(story.category != DailyStoryCategory.all, 'invalid category');
    assert(story.categoryLabel.isNotEmpty, 'category_label_ar must not be empty');
    assert(story.mainText.isNotEmpty, 'main_text must not be empty');
    assert(story.subText.isNotEmpty, 'sub_text must not be empty');
    assert(story.reference.isNotEmpty, 'reference must not be empty');
    counts[story.category] = (counts[story.category] ?? 0) + 1;
  }
  assert(counts[DailyStoryCategory.ayah] == 20, 'Expected 20 ayah entries');
  assert(counts[DailyStoryCategory.salawat] == 15, 'Expected 15 salawat entries');
  assert(counts[DailyStoryCategory.dhikr] == 15, 'Expected 15 dhikr entries');
  assert(counts[DailyStoryCategory.dua] == 10, 'Expected 10 dua entries');

  // 2. Date-seeded PRNG determinism & non-Friday vs Friday behavior
  final tuesday = DateTime(2026, 11, 24);
  assert(SelectDailyStoryUseCase.dateSeed(tuesday) == 20261124);
  assert(
    SelectDailyStoryUseCase.defaultCategoryFor(tuesday) ==
        DailyStoryCategory.all,
  );
  final pickA = SelectDailyStoryUseCase.pickForDate(
    stories: stories,
    date: tuesday,
    recentIds: const [],
  );
  final pickB = SelectDailyStoryUseCase.pickForDate(
    stories: stories,
    date: tuesday,
    recentIds: const [],
  );
  assert(pickA.id == pickB.id, 'Same date must yield deterministic pick');

  // 3. Anti-repeat exclusion
  final pickAfterExclude = SelectDailyStoryUseCase.pickForDate(
    stories: stories,
    date: tuesday,
    recentIds: [pickA.id],
  );
  assert(
    pickAfterExclude.id != pickA.id,
    'Excluded recent ID must not be picked when alternatives exist',
  );

  // 4. Friday smart default prioritizes Salawat
  final friday = DateTime(2026, 11, 27);
  assert(friday.weekday == DateTime.friday);
  assert(
    SelectDailyStoryUseCase.defaultCategoryFor(friday) ==
        DailyStoryCategory.salawat,
  );
  final fridayPick = SelectDailyStoryUseCase.pickForDate(
    stories: stories,
    date: friday,
    recentIds: const [],
  );
  assert(
    fridayPick.category == DailyStoryCategory.salawat,
    'Friday default pick must be from salawat category',
  );

  // 5. Shuffle cycles without repeating within a category
  final random = Random(42);
  var seen = <String>{};
  DailyStoryEntity? current;
  final duaPool = SelectDailyStoryUseCase.filterByCategory(
    stories,
    DailyStoryCategory.dua,
  );
  for (var i = 0; i < duaPool.length; i++) {
    final res = SelectDailyStoryUseCase.pickNext(
      stories: stories,
      category: DailyStoryCategory.dua,
      current: current,
      seenIds: seen,
      random: random,
    );
    assert(res.story.category == DailyStoryCategory.dua);
    assert(res.story.id != current?.id, 'Shuffle must advance to a new card');
    current = res.story;
    seen = res.seenIds;
  }
  assert(seen.length == duaPool.length, 'All dua cards should be visited once');
}


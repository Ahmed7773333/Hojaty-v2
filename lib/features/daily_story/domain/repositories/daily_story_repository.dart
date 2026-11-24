import 'package:dartz/dartz.dart';
import 'package:hojaty/core/error/failures.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_history.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';

abstract class DailyStoryRepository {
  Future<Either<Failure, List<DailyStoryEntity>>> getStories();

  DailyStoryHistory getHistory();

  Future<void> saveHistory(DailyStoryHistory history);

  StoryCardPalette getPalette();

  Future<void> savePalette(StoryCardPalette palette);
}


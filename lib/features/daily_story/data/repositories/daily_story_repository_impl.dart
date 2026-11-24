import 'package:dartz/dartz.dart';
import 'package:hojaty/core/error/failures.dart';
import 'package:hojaty/features/daily_story/data/datasources/daily_story_local_data_source.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_history.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';
import 'package:hojaty/features/daily_story/domain/repositories/daily_story_repository.dart';

class DailyStoryRepositoryImpl implements DailyStoryRepository {
  final DailyStoryLocalDataSource local;

  const DailyStoryRepositoryImpl({required this.local});

  @override
  Future<Either<Failure, List<DailyStoryEntity>>> getStories() async {
    try {
      final stories = await local.loadStories();
      return Right(stories);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  DailyStoryHistory getHistory() => local.readHistory();

  @override
  Future<void> saveHistory(DailyStoryHistory history) =>
      local.writeHistory(history);

  @override
  StoryCardPalette getPalette() =>
      StoryCardPalette.fromKey(local.readPaletteKey());

  @override
  Future<void> savePalette(StoryCardPalette palette) =>
      local.writePaletteKey(palette.name);
}


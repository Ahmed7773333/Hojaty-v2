import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';
import 'package:hojaty/features/daily_story/domain/repositories/daily_story_repository.dart';

class StoryPaletteUseCase {
  final DailyStoryRepository _repository;

  const StoryPaletteUseCase(this._repository);

  StoryCardPalette read() => _repository.getPalette();

  Future<void> save(StoryCardPalette palette) =>
      _repository.savePalette(palette);
}


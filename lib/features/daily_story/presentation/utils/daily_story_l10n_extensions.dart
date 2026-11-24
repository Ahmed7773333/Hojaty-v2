import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';
import 'package:hojaty/l10n/app_localizations.dart';

extension DailyStoryCategoryL10n on DailyStoryCategory {
  String label(AppLocalizations strings) => switch (this) {
        DailyStoryCategory.all => strings.dailyStoryCategoryAll,
        DailyStoryCategory.ayah => strings.dailyStoryCategoryAyah,
        DailyStoryCategory.salawat => strings.dailyStoryCategorySalawat,
        DailyStoryCategory.dhikr => strings.dailyStoryCategoryDhikr,
        DailyStoryCategory.dua => strings.dailyStoryCategoryDua,
      };
}

extension StoryCardPaletteL10n on StoryCardPalette {
  String label(AppLocalizations strings) => switch (this) {
        StoryCardPalette.emeraldDawn => strings.dailyStoryPaletteEmerald,
        StoryCardPalette.midnightGold => strings.dailyStoryPaletteMidnight,
        StoryCardPalette.warmParchment => strings.dailyStoryPaletteParchment,
      };
}


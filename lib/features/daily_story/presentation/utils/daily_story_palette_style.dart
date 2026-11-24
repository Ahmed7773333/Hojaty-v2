import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';

/// Visual tokens for a story card palette.
class DailyStoryPaletteStyle {
  final List<Color> gradient;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;

  const DailyStoryPaletteStyle({
    required this.gradient,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
  });

  Color get pattern => accent.withValues(alpha: 0.08);
  Color get frame => accent.withValues(alpha: 0.55);
  Color get badgeBackground => accent.withValues(alpha: 0.14);
  Color get badgeBorder => accent.withValues(alpha: 0.4);

  static DailyStoryPaletteStyle of(StoryCardPalette palette) {
    return switch (palette) {
      StoryCardPalette.emeraldDawn => const DailyStoryPaletteStyle(
          gradient: [AppColors.storyEmeraldTop, AppColors.storyEmeraldBottom],
          primaryText: AppColors.storyEmeraldText,
          secondaryText: AppColors.storyEmeraldSubText,
          accent: AppColors.accentGoldLight,
        ),
      StoryCardPalette.midnightGold => const DailyStoryPaletteStyle(
          gradient: [AppColors.storyMidnightTop, AppColors.storyMidnightBottom],
          primaryText: AppColors.storyMidnightText,
          secondaryText: AppColors.storyMidnightSubText,
          accent: AppColors.storyMidnightAccent,
        ),
      StoryCardPalette.warmParchment => const DailyStoryPaletteStyle(
          gradient: [
            AppColors.storyParchmentTop,
            AppColors.storyParchmentBottom,
          ],
          primaryText: AppColors.primaryDark,
          secondaryText: AppColors.storyParchmentSubText,
          accent: AppColors.accentGoldDark,
        ),
    };
  }
}


import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_fonts.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/presentation/utils/daily_story_palette_style.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_card_divider_widget.dart';

class DailyStoryCardBodyWidget extends StatelessWidget {
  static const double _contentWidth = 280;

  final DailyStoryEntity story;
  final DailyStoryPaletteStyle style;
  final double unit;

  const DailyStoryCardBodyWidget({
    super.key,
    required this.story,
    required this.style,
    required this.unit,
  });

  /// Shorter texts get bigger type so every card feels visually balanced.
  double _mainFontSize(bool isAyah) {
    final length = story.mainText.length;
    final base = switch (length) {
      <= 45 => isAyah ? 34.0 : 30.0,
      <= 90 => isAyah ? 28.0 : 25.0,
      <= 160 => 21.0,
      _ => 17.0,
    };
    return base * unit;
  }

  @override
  Widget build(BuildContext context) {
    final isAyah = story.category == DailyStoryCategory.ayah;
    final textTheme = context.textTheme;

    // scaleDown is only a safety net: it never enlarges, only prevents
    // overflow on unusually long entries.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: _contentWidth * unit,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              story.mainText,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontFamily: isAyah ? AppFonts.hafsSmart : AppFonts.notoKufiArabic,
                fontSize: _mainFontSize(isAyah),
                fontWeight: isAyah ? FontWeight.w400 : FontWeight.w600,
                height: isAyah ? 1.9 : 1.75,
                color: style.primaryText,
              ),
            ),
            SizedBox(height: 22 * unit),
            DailyStoryCardDividerWidget(color: style.accent, unit: unit),
            SizedBox(height: 18 * unit),
            Text(
              story.subText,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                fontFamily: AppFonts.notoKufiArabic,
                fontSize: 13.5 * unit,
                height: 1.8,
                color: style.secondaryText,
              ),
            ),
            SizedBox(height: 12 * unit),
            Text(
              story.reference,
              textAlign: TextAlign.center,
              style: textTheme.labelLarge?.copyWith(
                fontFamily: AppFonts.notoKufiArabic,
                fontSize: 12 * unit,
                fontWeight: FontWeight.w600,
                color: style.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


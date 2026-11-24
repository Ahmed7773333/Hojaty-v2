import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_fonts.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/daily_story/presentation/utils/daily_story_palette_style.dart';

class DailyStoryCardBadgeWidget extends StatelessWidget {
  final String label;
  final DailyStoryPaletteStyle style;
  final double unit;

  const DailyStoryCardBadgeWidget({
    super.key,
    required this.label,
    required this.style,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16 * unit, vertical: 6 * unit),
      decoration: BoxDecoration(
        color: style.badgeBackground,
        borderRadius: BorderRadius.circular(20 * unit),
        border: Border.all(color: style.badgeBorder, width: unit),
      ),
      child: Text(
        label,
        style: context.textTheme.labelLarge?.copyWith(
          fontFamily: AppFonts.notoKufiArabic,
          fontSize: 12 * unit,
          fontWeight: FontWeight.w700,
          color: style.accent,
        ),
      ),
    );
  }
}


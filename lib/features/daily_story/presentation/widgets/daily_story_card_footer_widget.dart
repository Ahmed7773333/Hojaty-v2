import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_fonts.dart';
import 'package:hojaty/core/utils/assets.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/daily_story/presentation/utils/daily_story_palette_style.dart';

class DailyStoryCardFooterWidget extends StatelessWidget {
  final DailyStoryPaletteStyle style;
  final double unit;

  const DailyStoryCardFooterWidget({
    super.key,
    required this.style,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6 * unit),
          child: Image.asset(
            Assets.logo,
            width: 22 * unit,
            height: 22 * unit,
            gaplessPlayback: true,
            excludeFromSemantics: true,
          ),
        ),
        SizedBox(width: 8 * unit),
        Text(
          context.strings.dailyStoryFooterBrand,
          style: context.textTheme.labelLarge?.copyWith(
            fontFamily: AppFonts.notoKufiArabic,
            fontSize: 12 * unit,
            fontWeight: FontWeight.w600,
            color: style.secondaryText,
          ),
        ),
      ],
    );
  }
}


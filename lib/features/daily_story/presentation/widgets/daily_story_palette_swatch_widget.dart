import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';
import 'package:hojaty/features/daily_story/presentation/utils/daily_story_l10n_extensions.dart';
import 'package:hojaty/features/daily_story/presentation/utils/daily_story_palette_style.dart';

class DailyStoryPaletteSwatchWidget extends StatelessWidget {
  final StoryCardPalette palette;
  final bool isSelected;
  final VoidCallback onTap;

  const DailyStoryPaletteSwatchWidget({
    super.key,
    required this.palette,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = DailyStoryPaletteStyle.of(palette);
    final colors = context.colors;
    final label = palette.label(context.strings);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(4.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: style.gradient,
                  ),
                  border: Border.all(
                    color: isSelected ? colors.primary : colors.outline,
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded, color: style.accent, size: 20.r)
                    : null,
              ),
              6.ver,
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: isSelected ? colors.primary : colors.onSurface,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


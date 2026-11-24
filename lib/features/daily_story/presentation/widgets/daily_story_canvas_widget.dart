import 'package:material_ui/material_ui.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_entity.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';
import 'package:hojaty/features/daily_story/presentation/utils/daily_story_palette_style.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_card_badge_widget.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_card_body_widget.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_card_footer_widget.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_geometric_painter.dart';

/// The exported 9:16 story poster. Every size is relative to the card width
/// (a 360-unit grid), so the preview and the 1080x1920 export look identical.
class DailyStoryCanvasWidget extends StatelessWidget {
  static const Duration transitionDuration = Duration(milliseconds: 350);
  static const double designWidth = 360;

  final DailyStoryEntity story;
  final StoryCardPalette palette;

  const DailyStoryCanvasWidget({
    super.key,
    required this.story,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final style = DailyStoryPaletteStyle.of(palette);

    return MediaQuery.withNoTextScaling(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final unit = constraints.maxWidth / designWidth;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: style.gradient,
              ),
            ),
            child: CustomPaint(
              painter: DailyStoryGeometricPainter(
                patternColor: style.pattern,
                frameColor: style.frame,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  40 * unit,
                  56 * unit,
                  40 * unit,
                  44 * unit,
                ),
                child: Column(
                  children: [
                    DailyStoryCardBadgeWidget(
                      label: story.categoryLabel,
                      style: style,
                      unit: unit,
                    ),
                    const Spacer(),
                    Flexible(
                      flex: 8,
                      child: DailyStoryCardBodyWidget(
                        story: story,
                        style: style,
                        unit: unit,
                      ),
                    ),
                    const Spacer(),
                    DailyStoryCardFooterWidget(style: style, unit: unit),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


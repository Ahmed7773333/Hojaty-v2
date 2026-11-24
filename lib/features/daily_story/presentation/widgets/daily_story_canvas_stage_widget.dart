import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_bloc.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_state.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_canvas_widget.dart';

/// Hosts the 9:16 card. Only the [RepaintBoundary] is exported, so the
/// rounded corners and shadow stay preview-only and the shared image is
/// full-bleed.
class DailyStoryCanvasStageWidget extends StatelessWidget {
  final GlobalKey canvasKey;

  const DailyStoryCanvasStageWidget({super.key, required this.canvasKey});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.r);

    return BlocBuilder<DailyStoryBloc, DailyStoryState>(
      buildWhen: (prev, curr) =>
          prev.currentStory != curr.currentStory ||
          prev.selectedPalette != curr.selectedPalette,
      builder: (context, state) {
        final story = state.currentStory;
        if (story == null) return const SizedBox.shrink();

        return Center(
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: RepaintBoundary(
                  key: canvasKey,
                  child: AnimatedSwitcher(
                    duration: DailyStoryCanvasWidget.transitionDuration,
                    layoutBuilder: (current, previous) => Stack(
                      fit: StackFit.expand,
                      children: [...previous, ?current],
                    ),
                    child: DailyStoryCanvasWidget(
                      key: ValueKey('${story.id}_${state.selectedPalette.name}'),
                      story: story,
                      palette: state.selectedPalette,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


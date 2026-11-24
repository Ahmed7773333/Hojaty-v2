import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_action_bar_widget.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_canvas_stage_widget.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_category_chips_widget.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_palette_selector_widget.dart';

class DailyStoryPreviewBodyWidget extends StatelessWidget {
  final GlobalKey canvasKey;
  final VoidCallback onShare;

  const DailyStoryPreviewBodyWidget({
    super.key,
    required this.canvasKey,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          16.ver,
          const DailyStoryCategoryChipsWidget(),
          16.ver,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: DailyStoryCanvasStageWidget(canvasKey: canvasKey),
            ),
          ),
          16.ver,
          const DailyStoryPaletteSelectorWidget(),
          16.ver,
          DailyStoryActionBarWidget(onShare: onShare),
          16.ver,
        ],
      ),
    );
  }
}


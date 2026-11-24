import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/daily_story/domain/entities/story_card_palette.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_bloc.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_event.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_state.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_palette_swatch_widget.dart';

class DailyStoryPaletteSelectorWidget extends StatelessWidget {
  const DailyStoryPaletteSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyStoryBloc, DailyStoryState>(
      buildWhen: (prev, curr) => prev.selectedPalette != curr.selectedPalette,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final palette in StoryCardPalette.values)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: DailyStoryPaletteSwatchWidget(
                  palette: palette,
                  isSelected: palette == state.selectedPalette,
                  onTap: () => context
                      .read<DailyStoryBloc>()
                      .add(SelectStoryPaletteEvent(palette)),
                ),
              ),
          ],
        );
      },
    );
  }
}


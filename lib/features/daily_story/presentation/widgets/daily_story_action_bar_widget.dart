import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_bloc.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_event.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_state.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';

class DailyStoryActionBarWidget extends StatelessWidget {
  final VoidCallback onShare;

  const DailyStoryActionBarWidget({super.key, required this.onShare});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labelStyle = context.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
    );

    return BlocBuilder<DailyStoryBloc, DailyStoryState>(
      buildWhen: (prev, curr) => prev.isSharing != curr.isSharing,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: state.isSharing
                      ? null
                      : () => context
                          .read<DailyStoryBloc>()
                          .add(const ShuffleDailyStoryEvent()),
                  icon: Icon(Icons.shuffle_rounded, size: 18.r),
                  label: Text(context.strings.dailyStoryShuffle),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: colors.primary,
                    side: BorderSide(color: colors.primary),
                    shape: const StadiumBorder(),
                    textStyle: labelStyle,
                  ),
                ),
              ),
              12.hor,
              Expanded(
                child: CustomElevatedButton(
                  text: context.strings.dailyStoryShare,
                  onPressed: onShare,
                  isLoading: state.isSharing,
                  textStyle: labelStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


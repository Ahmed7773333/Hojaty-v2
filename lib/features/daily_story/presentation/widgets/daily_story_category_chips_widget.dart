import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/daily_story/domain/entities/daily_story_category.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_bloc.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_event.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_state.dart';
import 'package:hojaty/features/daily_story/presentation/utils/daily_story_l10n_extensions.dart';
import 'package:hojaty/features/daily_story/presentation/widgets/daily_story_category_chip_item_widget.dart';

class DailyStoryCategoryChipsWidget extends StatelessWidget {
  const DailyStoryCategoryChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyStoryBloc, DailyStoryState>(
      buildWhen: (prev, curr) => prev.selectedCategory != curr.selectedCategory,
      builder: (context, state) {
        const categories = DailyStoryCategory.values;
        return SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: categories.length,
            separatorBuilder: (context, index) => 8.hor,
            itemBuilder: (context, index) {
              final category = categories[index];
              return DailyStoryCategoryChipItemWidget(
                label: category.label(context.strings),
                isSelected: category == state.selectedCategory,
                onTap: () => context
                    .read<DailyStoryBloc>()
                    .add(SelectStoryCategoryEvent(category)),
              );
            },
          ),
        );
      },
    );
  }
}


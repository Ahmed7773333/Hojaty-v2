import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/surah_item_model.dart';
import 'surah_item_row_widget.dart';

class SurahListCardWidget extends StatelessWidget {
  final List<SurahItemModel> surahs;
  final ValueChanged<SurahItemModel> onSurahTap;

  const SurahListCardWidget({
    super.key,
    required this.surahs,
    required this.onSurahTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.surahsListTitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
        10.ver,
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
              width: 1.0,
            ),
          ),
          child: Column(
            children: List.generate(surahs.length, (index) {
              final surah = surahs[index];
              return Column(
                children: [
                  SurahItemRowWidget(
                    surah: surah,
                    onTap: () => onSurahTap(surah),
                  ),
                  if (index < surahs.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? AppColors.darkBorderUnselected.withValues(
                              alpha: 0.5,
                            )
                          : AppColors.lightBorderUnselected.withValues(
                              alpha: 0.6,
                            ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

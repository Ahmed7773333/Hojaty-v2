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
    final borderColor = isDark
        ? AppColors.darkBorderUnselected
        : AppColors.lightBorderUnselected;

    if (surahs.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Center(
            child: Text(
              context.strings.quranNoResults,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 24.h),
      sliver: SliverList.separated(
        itemCount: surahs.length,
        separatorBuilder: (context, index) => Container(
          color: isDark
              ? AppColors.darkCardUnselected
              : AppColors.lightSurface,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Divider(
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
        ),
        itemBuilder: (context, index) {
          final surah = surahs[index];
          final isFirst = index == 0;
          final isLast = index == surahs.length - 1;
          final borderRadius = BorderRadius.vertical(
            top: isFirst ? Radius.circular(18.r) : Radius.zero,
            bottom: isLast ? Radius.circular(18.r) : Radius.zero,
          );

          return Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCardUnselected
                  : AppColors.lightSurface,
              borderRadius: borderRadius,
              border: Border(
                top: isFirst
                    ? BorderSide(color: borderColor, width: 1.0)
                    : BorderSide.none,
                bottom: isLast
                    ? BorderSide(color: borderColor, width: 1.0)
                    : BorderSide.none,
                left: BorderSide(color: borderColor, width: 1.0),
                right: BorderSide(color: borderColor, width: 1.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: SurahItemRowWidget(
                surah: surah,
                onTap: () => onSurahTap(surah),
              ),
            ),
          );
        },
      ),
    );
  }
}

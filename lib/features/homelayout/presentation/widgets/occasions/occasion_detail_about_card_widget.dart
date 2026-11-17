import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/occasion_item_model.dart';

class OccasionDetailAboutCardWidget extends StatelessWidget {
  final OccasionItemModel occasion;

  const OccasionDetailAboutCardWidget({super.key, required this.occasion});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings.aboutOccasionLabel,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
              fontSize: 12.sp,
            ),
          ),
          8.ver,
          Text(
            occasion.description,
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

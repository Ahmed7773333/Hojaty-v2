import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/occasion_item_model.dart';

class OccasionDetailDatesCardWidget extends StatelessWidget {
  final OccasionItemModel occasion;

  const OccasionDetailDatesCardWidget({super.key, required this.occasion});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                context.strings.hijriDateLabel,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                  fontSize: 12.sp,
                ),
              ),
              6.ver,
              Text(
                occasion.hijriDate,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Container(
            width: 1.w,
            height: 36.h,
            color: isDark
                ? AppColors.darkBorderUnselected.withValues(alpha: 0.5)
                : AppColors.lightBorderUnselected.withValues(alpha: 0.6),
          ),
          Column(
            children: [
              Text(
                context.strings.gregorianDateLabel,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                  fontSize: 12.sp,
                ),
              ),
              6.ver,
              Text(
                occasion.gregorianDate,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

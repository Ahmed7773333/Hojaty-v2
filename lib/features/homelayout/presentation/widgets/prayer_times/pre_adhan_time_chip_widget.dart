import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class PreAdhanTimeChipWidget extends StatelessWidget {
  final int minutes;
  final bool isSelected;
  final ValueChanged<int> onSelected;

  const PreAdhanTimeChipWidget({
    super.key,
    required this.minutes,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final bgColor = isSelected
        ? AppColors.primaryDark
        : (isDark
            ? AppColors.white.withValues(alpha: 0.05)
            : AppColors.lightBackground);

    final borderColor = isSelected
        ? AppColors.primaryDark
        : (isDark
            ? AppColors.darkBorderUnselected
            : AppColors.lightBorderUnselected);

    final textColor = isSelected
        ? AppColors.white
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return InkWell(
      onTap: () => onSelected(minutes),
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Text(
          context.strings.preAdhanMinutesChoice(minutes),
          style: context.textTheme.labelMedium?.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}

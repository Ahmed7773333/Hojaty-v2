import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class FontSliderCardWidget extends StatelessWidget {
  final double fontSize;
  final ValueChanged<double> onChanged;

  const FontSliderCardWidget({
    super.key,
    required this.fontSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              Text(
                context.strings.fontPreviewText,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              16.ver,
              Text(
                '${context.strings.fontSizeLabel}: ${fontSize.toInt()}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        16.ver,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Text(
                '16',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
              Expanded(
                child: Slider(
                  value: fontSize,
                  min: 16.0,
                  max: 36.0,
                  divisions: 10,
                  activeColor: AppColors.primaryDark,
                  inactiveColor: isDark
                      ? AppColors.white.withValues(alpha: 0.15)
                      : const Color(0xFFE2E8F0),
                  onChanged: onChanged,
                ),
              ),
              Text(
                '36',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

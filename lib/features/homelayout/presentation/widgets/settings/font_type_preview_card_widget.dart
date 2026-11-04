import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class FontTypePreviewCardWidget extends StatelessWidget {
  final String selectedFontId;

  const FontTypePreviewCardWidget({
    super.key,
    required this.selectedFontId,
  });

  String _getFontDisplayName(BuildContext context) {
    switch (selectedFontId) {
      case 'uthmani':
        return context.strings.uthmaniFont;
      case 'amiri':
        return context.strings.amiriFont;
      case 'naskh':
      default:
        return context.strings.naskhFont;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
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
      child: Column(
        children: [
          Text(
            context.strings.fontPreviewText,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          16.ver,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.08)
                  : AppColors.lightCardSelected,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderSelected,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.font_download_outlined,
                  size: 14.r,
                  color: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.primaryDark,
                ),
                6.hor,
                Text(
                  '${context.strings.selectedFontLabel}: ${_getFontDisplayName(context)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.primaryDarkBackground,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';

class QuranTafseerAyahCardWidget extends StatelessWidget {
  final int verseNumber;
  final String verseText;
  final String tafseerText;

  const QuranTafseerAyahCardWidget({
    super.key,
    required this.verseNumber,
    required this.verseText,
    required this.tafseerText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ayah Number Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.primaryDarkSurface : AppColors.lightCardSelected,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                width: 1.0,
              ),
            ),
            child: Text(
              context.strings.ayahNumber(verseNumber),
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.accentGoldLight : AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          if (verseText.isNotEmpty) ...[
            10.ver,
            Text(
              verseText,
              textAlign: TextAlign.justify,
              style: context.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                height: 1.6,
              ),
            ),
          ],
          12.ver,
          Divider(
            color: isDark
                ? AppColors.darkBorderUnselected.withValues(alpha: 0.5)
                : AppColors.lightBorderUnselected,
            height: 1,
          ),
          12.ver,
          Text(
            tafseerText,
            textAlign: TextAlign.justify,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 14.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

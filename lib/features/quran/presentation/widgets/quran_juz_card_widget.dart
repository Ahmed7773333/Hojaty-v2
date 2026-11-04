import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../constants/quran_constants.dart';
import '../../constants/quran_text_helper.dart';
import 'quran_quarter_card_widget.dart';

class QuranJuzCardWidget extends StatelessWidget {
  final int index;
  final ValueChanged<int> onQuarterTap;

  const QuranJuzCardWidget({
    super.key,
    required this.index,
    required this.onQuarterTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final hizb1 = QuranConstants.hezbs[index * 2];
    final hizb2 = QuranConstants.hezbs[(index * 2) + 1];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Juz Title
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.primaryDarkSurface : AppColors.lightCardSelected,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                  width: 1.0,
                ),
              ),
              child: Text(
                QuranTextHelper.convertToArabicJuzs(index + 1),
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          16.ver,
          // Hizb 1
          Text(
            QuranTextHelper.convertToArabicHizbs((index * 2) + 1),
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          8.ver,
          QuranQuarterCardWidget(
            title: context.strings.firstQuarter,
            surah: hizb1.firstQuarterVerse.first,
            verse: hizb1.firstQuarterVerse.last,
            onTap: onQuarterTap,
          ),
          QuranQuarterCardWidget(
            title: context.strings.secondQuarter,
            surah: hizb1.secondQuarterVerse.first,
            verse: hizb1.secondQuarterVerse.last,
            onTap: onQuarterTap,
          ),
          QuranQuarterCardWidget(
            title: context.strings.thirdQuarter,
            surah: hizb1.thirdQuarterVerse.first,
            verse: hizb1.thirdQuarterVerse.last,
            onTap: onQuarterTap,
          ),
          QuranQuarterCardWidget(
            title: context.strings.fourthQuarter,
            surah: hizb1.fourthQuarterVerse.first,
            verse: hizb1.fourthQuarterVerse.last,
            onTap: onQuarterTap,
          ),
          14.ver,
          // Hizb 2
          Text(
            QuranTextHelper.convertToArabicHizbs((index * 2) + 2),
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          8.ver,
          QuranQuarterCardWidget(
            title: context.strings.firstQuarter,
            surah: hizb2.firstQuarterVerse.first,
            verse: hizb2.firstQuarterVerse.last,
            onTap: onQuarterTap,
          ),
          QuranQuarterCardWidget(
            title: context.strings.secondQuarter,
            surah: hizb2.secondQuarterVerse.first,
            verse: hizb2.secondQuarterVerse.last,
            onTap: onQuarterTap,
          ),
          QuranQuarterCardWidget(
            title: context.strings.thirdQuarter,
            surah: hizb2.thirdQuarterVerse.first,
            verse: hizb2.thirdQuarterVerse.last,
            onTap: onQuarterTap,
          ),
          QuranQuarterCardWidget(
            title: context.strings.fourthQuarter,
            surah: hizb2.fourthQuarterVerse.first,
            verse: hizb2.fourthQuarterVerse.last,
            onTap: onQuarterTap,
          ),
        ],
      ),
    );
  }
}

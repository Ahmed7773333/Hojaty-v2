import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../quran/constants/quran_text_helper.dart';
import '../../../../quran/domain/entities/qirat_type.dart';

class QuranQiratCardHeaderWidget extends StatelessWidget {
  final QiratType qirat;
  final int lastPage;
  final bool isSelected;

  const QuranQiratCardHeaderWidget({
    super.key,
    required this.qirat,
    required this.lastPage,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = qirat.themeColor;
    final surahName = QuranTextHelper.getSurahName(lastPage);
    final displaySurah = surahName.isNotEmpty
        ? surahName
        : context.strings.surahBaqarah;
    final readingSubtitle = '${context.strings.quranPageLabel} $lastPage';

    return Row(
      children: [
        Container(
          width: 46.w,
          height: 46.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.22 : 0.12),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.45 : 0.25),
              width: 1.2,
            ),
          ),
          child: Icon(Icons.menu_book_rounded, color: color, size: 22.sp),
        ),
        14.hor,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                qirat.label(context),
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              4.ver,
              Text(
                readingSubtitle,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 12.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

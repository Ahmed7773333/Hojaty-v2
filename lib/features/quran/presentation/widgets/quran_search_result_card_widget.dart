import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/quran_search_result_model.dart';

class QuranSearchResultCardWidget extends StatelessWidget {
  final QuranSearchResultModel result;
  final ValueChanged<int> onTap;
  final ValueChanged<QuranSearchResultModel> onTafseerTap;

  const QuranSearchResultCardWidget({
    super.key,
    required this.result,
    required this.onTap,
    required this.onTafseerTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
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
      child: InkWell(
        onTap: () => onTap(result.pageNum),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Verse content
              Text(
                result.content,
                textAlign: TextAlign.justify,
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 1.6,
                ),
              ),
              12.ver,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tafseer Button
                  OutlinedButton.icon(
                    onPressed: () => onTafseerTap(result),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(
                        color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                        width: 1.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    icon: Icon(
                      Icons.menu_book_rounded,
                      size: 14.sp,
                      color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                    ),
                    label: Text(
                      context.strings.quranTafseer,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                  // Surah info & Page badge
                  Row(
                    children: [
                      Text(
                        '${result.surahName} : ${result.verseNum}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                      8.hor,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.primaryDarkSurface : AppColors.lightCardSelected,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          '${context.strings.safha} ${result.pageNum}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.accentGoldLight : AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';

class HojatyAiQuranActionCardWidget extends StatelessWidget {
  final AiToolActionResultModel action;

  const HojatyAiQuranActionCardWidget({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final res = action.result;
    final pageNum = (res['pageNumber'] as num?)?.toInt() ?? 1;
    final verseIdx = (res['highlightVerseIndex'] ?? res['verseIndex']) as int?;
    final surahName = res['surahName'] as String?;

    String subtitle = 'صفحة $pageNum';
    if (surahName != null && surahName.isNotEmpty) {
      subtitle = '$surahName - صفحة $pageNum';
    } else {
      for (final s in QuranConstants.surahMap.values) {
        if (s.pageNumber == pageNum) {
          subtitle = 'سورة ${s.name} - صفحة $pageNum';
          break;
        }
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardUnselected
            : AppColors.lightCardUnselected,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: isDark
                  ? AppColors.accentGoldLight
                  : AppColors.accentGoldDark,
              size: 22.r,
            ),
          ),
          12.hor,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المصحف الشريف',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                4.ver,
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.accentGoldLight
                  : AppColors.accentGoldDark,
              foregroundColor: AppColors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              context.pushNamed(
                AppRoutes.quranReader,
                extra: {
                  'initialPage': pageNum,
                  'highlightVerseIndex': verseIdx,
                },
              );
            },
            icon: Icon(Icons.arrow_forward_rounded, size: 16.r),
            label: Text(
              'فتح',
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class QuranVerseSheetTafseerWidget extends StatelessWidget {
  final String tafseerText;

  const QuranVerseSheetTafseerWidget({
    super.key,
    required this.tafseerText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 16.sp,
              color: isDark ? AppColors.accentGold : AppColors.primaryDark,
            ),
            6.hor,
            Text(
              context.strings.quranTafseer,
              style: context.textTheme.titleSmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
        8.ver,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 160.h),
            child: SingleChildScrollView(
              child: Text(
                tafseerText.isNotEmpty
                    ? tafseerText
                    : context.strings.quranNoResults,
                textAlign: TextAlign.justify,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 13.sp,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


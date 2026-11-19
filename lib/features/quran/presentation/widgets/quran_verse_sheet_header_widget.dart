import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class QuranVerseSheetHeaderWidget extends StatelessWidget {
  final String surahName;
  final int verseNumber;
  final VoidCallback onClose;

  const QuranVerseSheetHeaderWidget({
    super.key,
    required this.surahName,
    required this.verseNumber,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primaryDarkSurface
                : AppColors.lightCardSelected,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isDark ? AppColors.accentGold : AppColors.primaryDark,
            ),
          ),
          child: Text(
            context.strings.ayahNumber(verseNumber),
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.accentGoldLight
                  : AppColors.primaryDark,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ),
        8.hor,
        Expanded(
          child: Text(
            surahName,
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            size: 20.sp,
          ),
          onPressed: onClose,
          splashRadius: 20.r,
        ),
      ],
    );
  }
}


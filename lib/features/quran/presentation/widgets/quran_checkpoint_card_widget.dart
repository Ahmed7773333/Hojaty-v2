import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/quran/data/models/quran_checkpoint_model.dart';

class QuranCheckpointCardWidget extends StatelessWidget {
  final QuranCheckpointModel checkpoint;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const QuranCheckpointCardWidget({
    super.key,
    required this.checkpoint,
    required this.onTap,
    required this.onDelete,
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
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.accentGold.withValues(alpha: 0.15)
                          : AppColors.accentGold.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.bookmark_rounded,
                      color: isDark
                          ? AppColors.accentGoldLight
                          : AppColors.accentGold,
                      size: 18.sp,
                    ),
                  ),
                  12.hor,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${checkpoint.surahName} : ${checkpoint.verseNumber}',
                          style: context.textTheme.titleSmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                        2.ver,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.primaryDarkSurface
                                : AppColors.lightCardSelected,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '${context.strings.safha} ${checkpoint.pageNumber}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.accentGoldLight
                                  : AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      size: 20.sp,
                    ),
                    onPressed: onDelete,
                    tooltip: context.strings.delete,
                  ),
                ],
              ),
              12.ver,
              Text(
                checkpoint.verseContent.isNotEmpty
                    ? checkpoint.verseContent
                    : checkpoint.verseContentEmaly,
                textAlign: TextAlign.justify,
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 1.6,
                  fontFamily: "Hafs Smart",
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


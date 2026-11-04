import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:flutter/material.dart';
import '../../../data/models/book_chapter_model.dart';

class BookChapterTileWidget extends StatelessWidget {
  final BookChapterModel chapter;
  final int index;
  final int hadithsCount;
  final VoidCallback onTap;

  const BookChapterTileWidget({
    super.key,
    required this.chapter,
    required this.index,
    required this.hadithsCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Material(
      color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.lightCardSelected,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorderSelected
                        : AppColors.primaryDark.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: isDark
                          ? AppColors.accentGold
                          : AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              14.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.arabic,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (chapter.english.isNotEmpty) ...[
                      4.ver,
                      Text(
                        chapter.english,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    4.ver,
                    Text(
                      '$hadithsCount ${context.strings.hadithWord}',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

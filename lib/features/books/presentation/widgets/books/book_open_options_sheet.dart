import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/book_info_model.dart';

class BookOpenOptionsSheet extends StatelessWidget {
  final BookInfoModel book;
  final VoidCallback onReadText;
  final VoidCallback onOpenPdf;

  const BookOpenOptionsSheet({
    super.key,
    required this.book,
    required this.onReadText,
    required this.onOpenPdf,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          16.ver,
          Text(
            book.getDisplayTitle(isAr),
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: isDark ? Colors.white : AppColors.primaryDark,
            ),
          ),
          4.ver,
          Text(
            book.getDisplayAuthor(isAr),
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontSize: 12.sp,
            ),
          ),
          20.ver,
          Material(
            color: isDark ? AppColors.darkCardUnselected : AppColors.lightCardSelected,
            borderRadius: BorderRadius.circular(14.r),
            child: InkWell(
              onTap: onReadText,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.accentGold.withValues(alpha: 0.4)
                        : AppColors.primaryDark.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        color: isDark ? AppColors.accentGold : Colors.white,
                        size: 22.sp,
                      ),
                    ),
                    14.hor,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.strings.readBookText,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: isDark ? AppColors.accentGoldLight : AppColors.primaryDark,
                            ),
                          ),
                          2.ver,
                          Text(
                            '${book.hadithCount} ${context.strings.hadithWord}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.sp,
                      color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
          12.ver,
          Material(
            color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14.r),
            child: InkWell(
              onTap: onOpenPdf,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDarkBackground
                            : AppColors.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf_rounded,
                        color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                        size: 22.sp,
                      ),
                    ),
                    14.hor,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.strings.viewPdf,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: isDark ? Colors.white : AppColors.primaryDark,
                            ),
                          ),
                          2.ver,
                          Text(
                            '${book.sizeMb} MB • ${context.strings.hasPdfBadge}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.sp,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

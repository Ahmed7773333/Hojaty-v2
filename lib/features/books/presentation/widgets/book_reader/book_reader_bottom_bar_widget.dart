import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_reader_theme_model.dart';

class BookReaderBottomBarWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final BookReaderThemeModel theme;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onJumpToPage;

  const BookReaderBottomBarWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.theme,
    required this.onPageChanged,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onJumpToPage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: MediaQuery.of(context).padding.bottom + 10.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkHeader : AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (totalPages > 1)
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.accentGold,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
                thumbColor: AppColors.accentGoldLight,
                overlayColor: AppColors.accentGold.withValues(alpha: 0.2),
                trackHeight: 3.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              ),
              child: Slider(
                value: currentPage.clamp(1, totalPages).toDouble(),
                min: 1.0,
                max: totalPages.toDouble(),
                onChanged: (val) {
                  onPageChanged(val.round());
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: currentPage > 1 ? onPreviousPage : null,
                icon: Icon(
                  Icons.navigate_before_rounded,
                  color: currentPage > 1 ? Colors.white : Colors.white30,
                  size: 26.sp,
                ),
                tooltip: context.strings.previousPage,
              ),
              GestureDetector(
                onTap: onJumpToPage,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app_rounded, color: AppColors.accentGoldLight, size: 14.sp),
                      6.hor,
                      Text(
                        '${context.strings.pageWord} $currentPage / $totalPages',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: currentPage < totalPages ? onNextPage : null,
                icon: Icon(
                  Icons.navigate_next_rounded,
                  color: currentPage < totalPages ? Colors.white : Colors.white30,
                  size: 26.sp,
                ),
                tooltip: context.strings.nextPage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


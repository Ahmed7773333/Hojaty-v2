import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:flutter/material.dart';

class BooksHeaderWidget extends StatelessWidget {
  final VoidCallback onBack;

  const BooksHeaderWidget({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.h,
        bottom: 14.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkHeader : AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          8.hor,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.strings.hadithBooksTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                  ),
                ),
                2.ver,
                Text(
                  context.strings.hadithBooksSubtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.accentGoldLight,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: AppColors.accentGold,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}

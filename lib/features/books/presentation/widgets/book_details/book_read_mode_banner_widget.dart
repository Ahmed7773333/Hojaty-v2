import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class BookReadModeBannerWidget extends StatelessWidget {
  final VoidCallback onTap;

  const BookReadModeBannerWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isDark
                    ? AppColors.accentGold.withValues(alpha: 0.5)
                    : AppColors.primaryDark.withValues(alpha: 0.3),
                width: 1.2,
              ),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.primaryDarkSurface,
                        AppColors.darkCardUnselected,
                      ]
                    : [AppColors.lightCardSelected, AppColors.lightSurface],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    color: isDark ? AppColors.accentGold : Colors.white,
                    size: 20.sp,
                  ),
                ),
                12.hor,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.strings.readFullBook,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.accentGoldLight
                              : AppColors.primaryDark,
                          fontSize: 13.sp,
                        ),
                      ),
                      2.ver,
                      Text(
                        'تصفح صفحات الكتاب بالكامل مع البحث وتصدير PDF',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
    );
  }
}

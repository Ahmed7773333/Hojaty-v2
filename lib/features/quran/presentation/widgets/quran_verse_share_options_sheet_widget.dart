import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_style.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';

class QuranVerseShareOptionsSheetWidget extends StatelessWidget {
  final VoidCallback onShareVerseOnly;
  final VoidCallback onShareWithTafseer;

  const QuranVerseShareOptionsSheetWidget({
    super.key,
    required this.onShareVerseOnly,
    required this.onShareWithTafseer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return LiquidGlassContainer(
      variant: LiquidGlassSurfaceVariant.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      blurSigma: LiquidGlassStyle.maxBlurSigma,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      fallbackDecoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.ver,
            Text(
              context.strings.shareVerse,
              style: context.textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            16.ver,
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onShareVerseOnly();
              },
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardUnselected
                      : AppColors.lightCardSelected.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: isDark
                          ? AppColors.accentGold
                          : AppColors.primaryDark,
                      size: 22.sp,
                    ),
                    12.hor,
                    Expanded(
                      child: Text(
                        context.strings.shareVerseOnly,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
            ),
            10.ver,
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onShareWithTafseer();
              },
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardUnselected
                      : AppColors.lightCardSelected.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: isDark
                          ? AppColors.accentGold
                          : AppColors.primaryDark,
                      size: 22.sp,
                    ),
                    12.hor,
                    Expanded(
                      child: Text(
                        context.strings.shareVerseWithTafseer,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
            ),
            12.ver,
          ],
        ),
      ),
    );
  }
}


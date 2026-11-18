import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class AdhanLibraryBannerCardWidget extends StatelessWidget {
  const AdhanLibraryBannerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.adhanSoundsLibrary),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColors.primaryDarkBackground,
                    AppColors.darkCardUnselected,
                  ]
                : [AppColors.primaryDarkBackground, const Color(0xFF1E3A34)],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDarkBackground.withValues(
                alpha: isDark ? 0.3 : 0.2,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.library_music_rounded,
                color: AppColors.accentGoldLight,
                size: 24.r,
              ),
            ),
            14.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.openAdhanLibrary,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                    ),
                  ),
                  4.ver,
                  Text(
                    context.strings.openAdhanLibraryDesc,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            10.hor,
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.white.withValues(alpha: 0.7),
              size: 16.r,
            ),
          ],
        ),
      ),
    );
  }
}

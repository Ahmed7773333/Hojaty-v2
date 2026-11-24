import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';

class HomeDailyStoryBannerWidget extends StatelessWidget {
  const HomeDailyStoryBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final goldColor =
        isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark;
    final borderRadius = BorderRadius.circular(20.r);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: LiquidGlassContainer(
        variant: LiquidGlassSurfaceVariant.card,
        borderRadius: borderRadius,
        customBorderColor: AppColors.accentGold.withValues(alpha: 0.55),
        fallbackDecoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCardUnselected
              : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: isDark ? 0.4 : 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () => context.pushNamed(AppRoutes.dailyStory),
            borderRadius: borderRadius,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.storyEmeraldTop,
                      AppColors.storyEmeraldBottom,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.accentGold.withValues(alpha: 0.5),
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome_mosaic_rounded,
                  color: AppColors.accentGoldLight,
                  size: 22.r,
                ),
              ),
              12.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            context.strings.dailyStoryBannerTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 15.sp,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        8.hor,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withValues(
                              alpha: isDark ? 0.2 : 0.14,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            context.strings.dailyStoryBannerBadge,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: goldColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.ver,
                    Text(
                      context.strings.dailyStoryBannerSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              8.hor,
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.r,
                color: goldColor,
              ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}


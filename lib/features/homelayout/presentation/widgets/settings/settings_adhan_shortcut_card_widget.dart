import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_times_route_args.dart';

class SettingsAdhanShortcutCardWidget extends StatelessWidget {
  const SettingsAdhanShortcutCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return LiquidGlassContainer(
      variant: LiquidGlassSurfaceVariant.brandCard,
      borderRadius: BorderRadius.circular(20.r),
      fallbackDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.primaryDarkBackground,
                  AppColors.darkCardUnselected,
                ]
              : [
                  AppColors.primaryDarkBackground,
                  AppColors.primaryDarkSurface,
                ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarkBackground.withValues(
              alpha: isDark ? 0.3 : 0.16,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed(
              AppRoutes.prayerTimes,
              extra: const PrayerTimesRouteArgs(initialTabIndex: 1),
            );
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: AppColors.accentGoldLight,
                size: 22.r,
              ),
            ),
            14.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.adhanSettingsShortcutTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5.sp,
                    ),
                  ),
                  3.ver,
                  Text(
                    context.strings.adhanSettingsShortcutSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            8.hor,
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.accentGoldLight,
              size: 16.r,
            ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

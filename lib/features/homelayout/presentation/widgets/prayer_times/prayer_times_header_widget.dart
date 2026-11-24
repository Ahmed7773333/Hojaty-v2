import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_border_edges.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';

class PrayerTimesHeaderWidget extends StatelessWidget {
  final VoidCallback? onOpenAdhanSettings;

  const PrayerTimesHeaderWidget({
    super.key,
    this.onOpenAdhanSettings,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      width: double.infinity,
      variant: LiquidGlassSurfaceVariant.brandHeader,
      borderEdges: LiquidGlassBorderEdges.bottomOnly,
      showShadow: false,
      fallbackColor: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              spacing: 12.w,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.white,
                    size: 18.r,
                  ),
                ),
                Expanded(
                  child: Text(
                    context.strings.fullPrayerTimesTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                if (onOpenAdhanSettings != null)
                  IconButton(
                    onPressed: onOpenAdhanSettings,
                    tooltip: context.strings.tabAdhanSettings,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.white.withValues(alpha: 0.12),
                      shape: const CircleBorder(),
                    ),
                    icon: Icon(
                      Icons.tune_rounded,
                      color: AppColors.accentGoldLight,
                      size: 20.r,
                    ),
                  ),
              ],
            ),

            // 12.ver,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: Row(
            //         children: [
            //           Icon(
            //             Icons.location_on_outlined,
            //             size: 14.r,
            //             color: AppColors.darkTextSecondary,
            //           ),
            //           4.hor,
            //           Flexible(
            //             child: Text(
            //               context.strings.prayerTimesAddress,
            //               textAlign: TextAlign.end,
            //               style: context.textTheme.bodySmall?.copyWith(
            //                 color: AppColors.darkTextSecondary,
            //                 fontSize: 11.sp,
            //               ),
            //               maxLines: 1,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     6.hor,
            //     InkWell(
            //       onTap: () {},
            //       child: Text(
            //         context.strings.changeLocation,
            //         style: context.textTheme.bodySmall?.copyWith(
            //           color: AppColors.accentGoldLight,
            //           fontWeight: FontWeight.w600,
            //           fontSize: 12.sp,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

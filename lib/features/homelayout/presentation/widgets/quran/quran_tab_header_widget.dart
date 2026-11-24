import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hojaty/config/theme/liquid_glass_border_edges.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/assets.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';

class QuranTabHeaderWidget extends StatelessWidget {
  const QuranTabHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      width: double.infinity,
      variant: LiquidGlassSurfaceVariant.brandHeader,
      borderEdges: LiquidGlassBorderEdges.bottomOnly,
      showShadow: false,
      fallbackColor: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.quranKareem,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 26.sp,
                    ),
                  ),
                  6.ver,
                  Text(
                    context.strings.select_qirat,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryDarkSurface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.darkBorderUnselected.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: SvgPicture.asset(
                Assets.quranQuickAccessIcon,
                width: 28.w,
                height: 28.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.accentGold,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_border_edges.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';

class AthkarHeaderWidget extends StatelessWidget {
  const AthkarHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      width: double.infinity,
      variant: LiquidGlassSurfaceVariant.brandHeader,
      borderEdges: LiquidGlassBorderEdges.bottomOnly,
      showShadow: false,
      fallbackColor: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.strings.athkar,
              style: context.textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 26.sp,
              ),
            ),
            4.ver,
            Text(
              context.strings.athkarSubtitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.darkTextSecondary,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

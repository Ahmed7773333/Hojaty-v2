import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';
import 'package:material_ui/material_ui.dart';

class HifzEmptyPlanCard extends StatelessWidget {
  final VoidCallback onCreateCustomPlan;

  const HifzEmptyPlanCard({
    super.key,
    required this.onCreateCustomPlan,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(22.r),
      padding: EdgeInsets.all(20.r),
      fallbackDecoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: AppColors.accentGold,
              size: 22.r,
            ),
          ),
          12.ver,
          Text(
            context.strings.hifzEmptyPlanTitle,
            style: context.textTheme.titleLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          6.ver,
          Text(
            context.strings.hifzEmptyPlanSubtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          16.ver,
          CustomElevatedButton(
            text: context.strings.hifzCustomPlan,
            height: 46.h,
            borderRadius: 16.r,
            onPressed: onCreateCustomPlan,
          ),
        ],
      ),
    );
  }
}


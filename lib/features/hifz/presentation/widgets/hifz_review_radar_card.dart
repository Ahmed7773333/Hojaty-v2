import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:material_ui/material_ui.dart';

class HifzReviewRadarCard extends StatelessWidget {
  final int dueCount;
  final int estimatedMinutes;
  final List<String> surahNames;
  final VoidCallback onReviewNow;

  const HifzReviewRadarCard({
    super.key,
    required this.dueCount,
    required this.estimatedMinutes,
    required this.surahNames,
    required this.onReviewNow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final surahsSummary = surahNames.take(3).join(' • ');

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(20.r),
      padding: EdgeInsets.all(16.r),
      fallbackDecoration: BoxDecoration(
        color: isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.radar_rounded,
              color: AppColors.accentGold,
              size: 22.r,
            ),
          ),
          12.hor,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.hifzReviewRadarTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                2.ver,
                Text(
                  context.strings.hifzReviewDueCount(
                    dueCount,
                    estimatedMinutes,
                  ),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (surahsSummary.isNotEmpty) ...[
                  2.ver,
                  Text(
                    surahsSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          10.hor,
          ElevatedButton(
            onPressed: onReviewNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGold,
              foregroundColor: AppColors.primaryDarkHeader,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              context.strings.hifzReviewNow,
              style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.primaryDarkHeader,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


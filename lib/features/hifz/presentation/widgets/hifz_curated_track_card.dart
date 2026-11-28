import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/hifz/domain/entities/curated_track.dart';
import 'package:material_ui/material_ui.dart';

class HifzCuratedTrackCard extends StatelessWidget {
  final CuratedTrack track;
  final bool isActive;
  final VoidCallback onTap;

  const HifzCuratedTrackCard({
    super.key,
    required this.track,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SizedBox(
      width: 224.w,
      child: LiquidGlassContainer(
        borderRadius: BorderRadius.circular(18.r),
        fallbackDecoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isActive
                ? AppColors.accentGold
                : (isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected),
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark
                                ? AppColors.accentGold
                                : AppColors.primaryDark)
                            .withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '${track.totalAyahs}',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.accentGold
                              : AppColors.primaryDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      isActive
                          ? Icons.check_circle_rounded
                          : Icons.play_circle_outline_rounded,
                      color: isActive
                          ? AppColors.accentGold
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                      size: 20.r,
                    ),
                  ],
                ),
                10.ver,
                Text(
                  track.localizedTitle(isArabic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                4.ver,
                Text(
                  track.localizedSubtitle(isArabic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  context.strings.hifzStartJourney,
                  style: context.textTheme.labelMedium?.copyWith(
                    color:
                        isDark ? AppColors.accentGold : AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


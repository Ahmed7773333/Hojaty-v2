import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_plan.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';
import 'package:material_ui/material_ui.dart';

class HifzHeroPlanCard extends StatelessWidget {
  final HifzPlan plan;
  final VoidCallback onStartToday;
  final VoidCallback onTestMemorization;

  const HifzHeroPlanCard({
    super.key,
    required this.plan,
    required this.onStartToday,
    required this.onTestMemorization,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final startMapped = GlobalAyahMapper.fromGlobalAyahId(
      plan.todayStartGlobalAyah,
    );
    final endMapped = GlobalAyahMapper.fromGlobalAyahId(
      plan.todayEndGlobalAyah,
    );
    final surahInfo = QuranConstants.surahMap[startMapped.surah];
    final surahLabel = isArabic
        ? (surahInfo?.name ?? '')
        : (surahInfo?.englishName ?? '');
    final percentText = '${(plan.progress * 100).round()}%';

    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(22.r),
      padding: EdgeInsets.all(18.r),
      fallbackDecoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderSelected.withValues(alpha: 0.45)
              : AppColors.lightBorderSelected.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.accentGold : AppColors.primaryDark)
                      .withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  context.strings.hifzDayProgress(
                    plan.currentDayNumber,
                    plan.estimatedTotalDays,
                  ),
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                percentText,
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          10.ver,
          Text(
            plan.title,
            style: context.textTheme.titleLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          6.ver,
          Text(
            '$surahLabel • ${context.strings.hifzAyahRange(startMapped.ayah, endMapped.ayah)}',
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          12.ver,
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: plan.progress,
              minHeight: 8.h,
              backgroundColor: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.accentGold : AppColors.primaryDark,
              ),
            ),
          ),
          16.ver,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomElevatedButton(
                  text: context.strings.hifzStartTodaySession,
                  height: 46.h,
                  borderRadius: 16.r,
                  onPressed: onStartToday,
                ),
              ),
              10.hor,
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: onTestMemorization,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, 46.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.accentGold
                          : AppColors.primaryDark,
                    ),
                    foregroundColor: isDark
                        ? AppColors.accentGold
                        : AppColors.primaryDark,
                  ),
                  icon: Icon(Icons.visibility_outlined, size: 18.r),
                  label: Text(
                    context.strings.hifzTestMemorization,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


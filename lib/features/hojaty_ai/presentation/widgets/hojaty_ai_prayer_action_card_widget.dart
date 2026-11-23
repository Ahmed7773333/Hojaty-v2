import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';

class HojatyAiPrayerActionCardWidget extends StatelessWidget {
  final AiToolActionResultModel action;

  const HojatyAiPrayerActionCardWidget({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final res = action.result;
    final city = res['city'] as String? ?? 'القاهرة';
    final nextPrayer = res['nextPrayer'] as String? ?? 'الصلاة القادمة';
    final remaining = res['remaining'] as String? ?? '';
    final timesMap = (res['times'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        const <String, String>{};

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardUnselected
            : AppColors.lightCardUnselected,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                color: isDark
                    ? AppColors.accentGoldLight
                    : AppColors.accentGoldDark,
                size: 20.r,
              ),
              8.hor,
              Expanded(
                child: Text(
                  'مواقيت الصلاة - $city',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.prayerTimes),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'عرض الكل',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.accentGoldLight
                              : AppColors.accentGoldDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.hor,
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10.r,
                        color: isDark
                            ? AppColors.accentGoldLight
                            : AppColors.accentGoldDark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (remaining.isNotEmpty) ...[
            8.ver,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_top_rounded,
                    size: 14.r,
                    color: isDark
                        ? AppColors.accentGoldLight
                        : AppColors.accentGoldDark,
                  ),
                  6.hor,
                  Text(
                    'المتبقي على صلاة $nextPrayer: $remaining',
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (timesMap.isNotEmpty) ...[
            10.ver,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: timesMap.entries.map((entry) {
                  final isNext = entry.key == nextPrayer;
                  return Container(
                    margin: EdgeInsets.only(left: 6.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isNext
                          ? AppColors.accentGold.withValues(alpha: 0.2)
                          : (isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isNext
                            ? (isDark
                                ? AppColors.accentGoldLight
                                : AppColors.accentGoldDark)
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entry.key,
                          style: context.textTheme.labelSmall?.copyWith(
                            fontWeight:
                                isNext ? FontWeight.bold : FontWeight.normal,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        4.ver,
                        Text(
                          entry.value,
                          style: context.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


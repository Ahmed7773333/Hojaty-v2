import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/hijri_calendar_helper.dart';

class CalendarGridWidget extends StatelessWidget {
  final String title;
  final List<CalendarGridCell> cells;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final bool isCurrentMonth;
  final VoidCallback? onReturnToToday;

  const CalendarGridWidget({
    super.key,
    required this.title,
    required this.cells,
    this.onPrev,
    this.onNext,
    this.isCurrentMonth = true,
    this.onReturnToToday,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final weekdays = isArabic
        ? ['جمعة', 'سبت', 'أحد', 'اثنين', 'ثلاثاء', 'اربعاء', 'خميس']
        : ['Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: onPrev,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.r,
                  color: isDark ? AppColors.white : AppColors.primaryDark,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isCurrentMonth && onReturnToToday != null) ...[
                      6.hor,
                      InkWell(
                        onTap: onReturnToToday,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.primaryDark.withValues(alpha: 0.5)
                                : AppColors.primaryDarkBackground
                                    .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color:
                                  AppColors.accentGold.withValues(alpha: 0.5),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.today_rounded,
                                size: 12.r,
                                color: AppColors.accentGold,
                              ),
                              4.hor,
                              Text(
                                context.strings.today,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.primaryDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: onNext,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: isDark ? AppColors.white : AppColors.primaryDark,
                ),
              ),
            ],
          ),
          Divider(
            height: 16.h,
            thickness: 1,
            color: isDark
                ? AppColors.darkBorderUnselected.withValues(alpha: 0.5)
                : AppColors.lightBorderUnselected.withValues(alpha: 0.6),
          ),
          8.ver,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays
                .map(
                  (w) => Expanded(
                    child: Text(
                      w,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          12.ver,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final cell = cells[index];
              final isCurrent = cell.isCurrentMonth;
              final isActive = cell.isActive && isCurrent;

              return Center(
                child: Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryDarkBackground
                        : (isCurrent
                            ? (isDark
                                ? AppColors.white.withValues(alpha: 0.08)
                                : const Color(0xFFEFF6F4))
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      '${cell.dayNumber}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isActive
                            ? AppColors.white
                            : (isCurrent
                                ? (isDark
                                    ? AppColors.white
                                    : AppColors.primaryDark)
                                : (isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted)),
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// ARCHIVED ORIGINAL CALENDAR GRID WIDGET
// =========================================================================
// class CalendarGridWidget extends StatelessWidget {
//   final String title;
//   final int activeDay;
//   final VoidCallback? onPrev;
//   final VoidCallback? onNext;
//
//   const CalendarGridWidget({
//     super.key,
//     required this.title,
//     this.activeDay = 9,
//     this.onPrev,
//     this.onNext,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDark;
//     final weekdays = [
//       'جمعة',
//       'سبت',
//       'أحد',
//       'اثنين',
//       'ثلاثاء',
//       'اربعاء',
//       'خميس',
//     ];
//     ...
//   }
// }

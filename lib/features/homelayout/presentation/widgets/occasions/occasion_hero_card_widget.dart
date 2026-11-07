import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/live_time_helper.dart';
import '../../../data/models/occasion_item_model.dart';
import 'live_timer_display.dart';

class OccasionHeroCardWidget extends StatelessWidget {
  final OccasionItemModel occasion;
  final VoidCallback onTap;

  const OccasionHeroCardWidget({
    super.key,
    required this.occasion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final target = occasion.targetDateTime;
    final targetEnd = target != null
        ? DateTime(target.year, target.month, target.day)
        : DateTime(now.year, now.month, now.day + occasion.daysRemaining);

    return RepaintBoundary(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.strings.upcomingOccasion,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.accentGoldLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                    4.ver,
                    Text(
                      occasion.title,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.ver,
                    Text(
                      occasion.gregorianDate,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.darkTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              12.hor,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LiveTimerDisplay(
                    end: targetEnd,
                    format: LiveTimeFormat.short,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                  4.ver,
                  Text(
                    context.strings.daysRemainingUnit(occasion.daysRemaining),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
}
}

// =========================================================================
// ARCHIVED PREVIOUS OCCASION HERO CARD WIDGET
// =========================================================================
// class OccasionHeroCardWidget extends StatelessWidget {
//   final OccasionItemModel occasion;
//   final VoidCallback onTap;
//
//   const OccasionHeroCardWidget({
//     super.key,
//     required this.occasion,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18.r),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
//         decoration: BoxDecoration(
//           color: AppColors.primaryDark,
//           borderRadius: BorderRadius.circular(18.r),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primaryDark.withValues(alpha: 0.2),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   context.strings.upcomingOccasion,
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: AppColors.accentGoldLight,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 12.sp,
//                   ),
//                 ),
//                 4.ver,
//                 Text(
//                   occasion.title,
//                   style: context.textTheme.titleLarge?.copyWith(
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 20.sp,
//                   ),
//                 ),
//                 4.ver,
//                 Text(
//                   occasion.gregorianDate,
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: AppColors.darkTextSecondary,
//                     fontSize: 12.sp,
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '10:15:20',
//                   style: context.textTheme.titleLarge?.copyWith(
//                     color: AppColors.accentGold,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 18.sp,
//                   ),
//                 ),
//                 4.ver,
//                 Text(
//                   '${context.strings.daysRemainingUnit(1)} ${context.strings.nextPrayerRemaining}',
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: AppColors.darkTextSecondary,
//                     fontSize: 11.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

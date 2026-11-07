import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/live_time_helper.dart';
import '../../../data/models/occasion_item_model.dart';
import 'live_timer_display.dart';

class OccasionDetailHeaderWidget extends StatelessWidget {
  final OccasionItemModel occasion;

  const OccasionDetailHeaderWidget({super.key, required this.occasion});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final target = occasion.targetDateTime;
    final targetEnd = target != null
        ? DateTime(target.year, target.month, target.day)
        : DateTime(now.year, now.month, now.day + occasion.daysRemaining);

    return Container(
      width: double.infinity,
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white.withValues(alpha: 0.12),
                    padding: EdgeInsets.all(10.r),
                    shape: const CircleBorder(),
                  ),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.white,
                    size: 18.r,
                  ),
                ),
                12.hor,
                Text(
                  context.strings.occasionDetailsTitle,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 22.sp,
                  ),
                ),
              ],
            ),
            16.ver,
            Text(
              occasion.title,
              style: context.textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.center,
            ),
            12.ver,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: LiveTimerDisplay(
                end: targetEnd,
                format: LiveTimeFormat.timerWithDays,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ),
            8.ver,
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// ARCHIVED PREVIOUS OCCASION DETAIL HEADER WIDGET
// =========================================================================
// class OccasionDetailHeaderWidget extends StatelessWidget {
//   final OccasionItemModel occasion;
//
//   const OccasionDetailHeaderWidget({super.key, required this.occasion});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: AppColors.primaryDarkBackground,
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//       child: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             Row(
//               spacing: 12,
//               children: [
//                 IconButton(
//                   onPressed: () => context.pop(),
//                   style: IconButton.styleFrom(
//                     backgroundColor: AppColors.white.withValues(alpha: 0.12),
//                     padding: EdgeInsets.all(10.r),
//                     shape: const CircleBorder(),
//                   ),
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: AppColors.white,
//                     size: 18.r,
//                   ),
//                 ),
//                 Text(
//                   context.strings.occasionDetailsTitle,
//                   style: context.textTheme.titleLarge?.copyWith(
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 22.sp,
//                   ),
//                 ),
//               ],
//             ),
//             16.ver,
//             Text(
//               occasion.title,
//               style: context.textTheme.headlineMedium?.copyWith(
//                 color: AppColors.white,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 22.sp,
//               ),
//             ),
//             12.ver,
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
//               decoration: BoxDecoration(
//                 color: AppColors.accentGold,
//                 borderRadius: BorderRadius.circular(20.r),
//               ),
//               child: Text(
//                 context.strings.daysRemainingText(occasion.daysRemaining),
//                 style: context.textTheme.bodySmall?.copyWith(
//                   color: AppColors.primaryDark,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 13.sp,
//                 ),
//               ),
//             ),
//             8.ver,
//           ],
//         ),
//       ),
//     );
//   }
// }

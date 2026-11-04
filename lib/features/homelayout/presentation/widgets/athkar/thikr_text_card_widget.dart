import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/thikr_item_model.dart';

class ThikrTextCardWidget extends StatelessWidget {
  final ThikrItemModel thikr;

  const ThikrTextCardWidget({
    super.key,
    required this.thikr,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            thikr.text,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              height: 1.8,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (thikr.reference.isNotEmpty) ...[
            16.ver,
            Text(
              thikr.reference,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                fontSize: 12.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================
// ARCHIVED ORIGINAL THIKR TEXT CARD WIDGET
// ==========================================
// class ThikrTextCardWidget extends StatelessWidget {
//   final ThikrItemModel thikr;
// 
//   const ThikrTextCardWidget({
//     super.key,
//     required this.thikr,
//   });
// 
//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDark;
// 
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.w),
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
//         borderRadius: BorderRadius.circular(18.r),
//         border: Border.all(
//           color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
//           width: 1.0,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.black.withValues(alpha: 0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             thikr.text,
//             textAlign: TextAlign.center,
//             style: context.textTheme.titleMedium?.copyWith(
//               height: 1.8,
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           16.ver,
//           Text(
//             thikr.reference,
//             style: context.textTheme.bodySmall?.copyWith(
//               color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
//               fontSize: 12.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


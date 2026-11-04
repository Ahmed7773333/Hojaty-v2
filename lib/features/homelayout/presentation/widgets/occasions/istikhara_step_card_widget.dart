import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/istikhara_step_model.dart';

class IstikharaStepCardWidget extends StatelessWidget {
  final IstikharaStepModel step;

  const IstikharaStepCardWidget({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final hasTitle = step.title.trim().isNotEmpty;
    final hasDescription = step.description.trim().isNotEmpty;

    final String displayText;
    if (hasTitle && hasDescription) {
      displayText = '${step.title}: ${step.description}';
    } else if (hasTitle) {
      displayText = step.title;
    } else {
      displayText = step.description;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCardUnselected
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                '${step.stepNumber}',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
          12.hor,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCardUnselected
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
                  width: 1.0,
                ),
              ),
              child: Text(
                displayText,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ARCHIVED ORIGINAL ISTIKHARA STEP CARD CODE
// ==========================================
// class IstikharaStepCardWidget extends StatelessWidget {
//   final IstikharaStepModel step;
// 
//   const IstikharaStepCardWidget({super.key, required this.step});
// 
//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDark;
// 
//     return Container(
//       margin: EdgeInsets.only(bottom: 10.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 42.r,
//             height: 42.r,
//             decoration: BoxDecoration(
//               color: isDark
//                   ? AppColors.darkCardUnselected
//                   : AppColors.lightSurface,
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(
//                 color: isDark
//                     ? AppColors.darkBorderUnselected
//                     : AppColors.lightBorderUnselected,
//                 width: 1.0,
//               ),
//             ),
//             child: Center(
//               child: Text(
//                 '${step.stepNumber}',
//                 style: context.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w700,
//                   color: isDark
//                       ? AppColors.darkTextSecondary
//                       : AppColors.lightTextSecondary,
//                   fontSize: 15.sp,
//                 ),
//               ),
//             ),
//           ),
//           12.hor,
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//               decoration: BoxDecoration(
//                 color: isDark
//                     ? AppColors.darkCardUnselected
//                     : AppColors.lightSurface,
//                 borderRadius: BorderRadius.circular(14.r),
//                 border: Border.all(
//                   color: isDark
//                       ? AppColors.darkBorderUnselected
//                       : AppColors.lightBorderUnselected,
//                   width: 1.0,
//                 ),
//               ),
//               child: Text(
//                 '${step.title}: ${step.description}',
//                 style: context.textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 13.sp,
//                   height: 1.4,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


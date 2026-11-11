import 'package:hojaty/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';
import 'settings_app_version_badge_widget.dart';

class SettingsAppCardWidget extends StatelessWidget {
  const SettingsAppCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        final dynamicHijriDate =
            state.ramadanCheckData?.hijriDate.formatted ??
            context.strings.homeHijriDate;
        final locationName = state.prayerCityName.isNotEmpty
            ? state.prayerCityName
            : '';

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
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
            spacing: 12.w,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.accentGoldExtraLight,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: SvgPicture.asset(
                  Assets.homeNavBarIcon,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryDark,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            context.strings.anaOsalyTitle,
                            style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        8.hor,
                        const SettingsAppVersionBadgeWidget(),
                      ],
                    ),
                    4.ver,
                    Text(
                      locationName,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.darkTextSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                    2.ver,
                    Text(
                      dynamicHijriDate,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.accentGoldLight,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =========================================================================
// ARCHIVED ORIGINAL SETTINGS APP CARD WIDGET
// =========================================================================
// class SettingsAppCardWidget extends StatelessWidget {
//   const SettingsAppCardWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
//       decoration: BoxDecoration(
//         color: AppColors.primaryDark,
//         borderRadius: BorderRadius.circular(18.r),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryDark.withValues(alpha: 0.2),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         spacing: 12.w,
//         children: [
//           Container(
//             padding: EdgeInsets.all(12.r),
//             decoration: BoxDecoration(
//               color: AppColors.accentGoldExtraLight,
//               borderRadius: BorderRadius.circular(20.r),
//             ),
//             child: SvgPicture.asset(
//               Assets.homeNavBarIcon,
//               colorFilter: const ColorFilter.mode(
//                 AppColors.primaryDark,
//                 BlendMode.srcIn,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   context.strings.anaOsalyTitle,
//                   style: context.textTheme.titleLarge?.copyWith(
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 18.sp,
//                   ),
//                 ),
//                 4.ver,
//                 Text(
//                   context.strings.homeLocation,
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: AppColors.darkTextSecondary,
//                     fontSize: 11.sp,
//                   ),
//                 ),
//                 2.ver,
//                 Text(
//                   context.strings.homeHijriDate,
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: AppColors.accentGoldLight,
//                     fontSize: 11.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

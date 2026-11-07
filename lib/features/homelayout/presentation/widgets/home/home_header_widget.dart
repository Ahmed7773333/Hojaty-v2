import 'package:hojaty/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';
import 'home_share_button_widget.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final dynamicGregorianDate = DateFormat(
      'EEEE، d MMMM yyyy',
      lang,
    ).format(now);

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.ramadanCheckData?.hijriDate != curr.ramadanCheckData?.hijriDate ||
          prev.prayerCityName != curr.prayerCityName ||
          prev.currentLanguage != curr.currentLanguage,
      builder: (context, state) {
        final dynamicHijriDate =
            state.ramadanCheckData?.hijriDate.formatted ??
            context.strings.homeHijriDate;
        final locationName = state.prayerCityName.isNotEmpty
            ? state.prayerCityName
            : '';

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.r,
                          color: AppColors.darkTextSecondary,
                        ),
                        4.hor,
                        Text(
                          locationName,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.darkTextSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    4.ver,
                    Text(
                      dynamicGregorianDate,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    2.ver,
                    Text(
                      dynamicHijriDate,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.accentGoldLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              const HomeShareButtonWidget(),
            ],
          ),
        );
      },
    );
  }
}

// =========================================================================
// ARCHIVED ORIGINAL HOME HEADER WIDGET
// =========================================================================
// class HomeHeaderWidget extends StatelessWidget {
//   const HomeHeaderWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       context.strings.homeLocation,
//                       style: context.textTheme.bodySmall?.copyWith(
//                         color: AppColors.darkTextSecondary,
//                         fontSize: 12.sp,
//                       ),
//                     ),
//                     4.hor,
//                     Icon(
//                       Icons.location_on_outlined,
//                       size: 14.r,
//                       color: AppColors.darkTextSecondary,
//                     ),
//                   ],
//                 ),
//                 4.ver,
//                 Text(
//                   context.strings.homeGregorianDate,
//                   style: context.textTheme.titleMedium?.copyWith(
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 16.sp,
//                   ),
//                 ),
//                 2.ver,
//                 Text(
//                   context.strings.homeHijriDate,
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: AppColors.accentGoldLight,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 13.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: () => context.pushNamed(AppRoutes.notifications),
//             style: IconButton.styleFrom(
//               backgroundColor: AppColors.white.withValues(alpha: 0.12),
//               padding: EdgeInsets.all(10.r),
//               shape: const CircleBorder(),
//             ),
//             icon: SvgPicture.asset(Assets.notificationIcon),
//           ),
//         ],
//       ),
//     );
//   }
// }

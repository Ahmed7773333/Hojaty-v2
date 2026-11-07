import 'package:hojaty/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/live_time_helper.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';
import 'live_timer_display.dart';

class RamadanHeroCardWidget extends StatelessWidget {
  const RamadanHeroCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.ramadanCheckData != curr.ramadanCheckData ||
          prev.currentLanguage != curr.currentLanguage,
      builder: (context, state) {
        final data = state.ramadanCheckData;
        final nextRamadan = data?.nextRamadan;
        final targetEnd = nextRamadan?.targetDateTime ?? DateTime(2027, 2, 8);
        final isRamadan = data?.isRamadan ?? false;
        final hijriDate = data?.hijriDate;

        final isArabic = Localizations.localeOf(context).languageCode == 'ar';

        final ramadanDateStr = isRamadan
            ? (isArabic
                  ? '${hijriDate?.dayNumber ?? 1} رمضان ${hijriDate?.year ?? 1448} هـ'
                  : '${hijriDate?.dayNumber ?? 1} Ramadan ${hijriDate?.year ?? 1448} AH')
            : (isArabic
                  ? '1 رمضان ${hijriDate?.year ?? 1448} هـ (${nextRamadan?.date ?? '08-02-2027'})'
                  : '1 Ramadan ${hijriDate?.year ?? 1448} AH (${nextRamadan?.date ?? '08-02-2027'})');

        final remainingDays = targetEnd.difference(DateTime.now()).inDays;

        return RepaintBoundary(
          child: Container(
            padding: EdgeInsets.all(22.r),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(Assets.ramadanIcon),
                  8.hor,
                  Text(
                    context.strings.ramadanKareem,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.accentGoldLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              8.ver,
              Text(
                isRamadan
                    ? (isArabic
                          ? 'اليوم ${hijriDate?.dayNumber ?? 1} من رمضان'
                          : 'Day ${hijriDate?.dayNumber ?? 1} of Ramadan')
                    : context.strings.ramadanDay1Title,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 24.sp,
                ),
              ),
              4.ver,
              Text(
                ramadanDateStr,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.darkTextSecondary,
                  fontSize: 13.sp,
                ),
              ),
              20.ver,
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            isRamadan
                                ? (isArabic
                                      ? 'متبقى على الإفطار'
                                      : 'Time until Iftar')
                                : context.strings.remainingOnRamadan,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.darkTextSecondary,
                              fontSize: 13.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        8.hor,
                        if (!isRamadan)
                          Text(
                            nextRamadan?.formattedTimeLeft(
                                  language: isArabic ? 'ar' : 'en',
                                ) ??
                                (isArabic
                                    ? '5 أشهر و 12 يوم'
                                    : '5 months 12 days'),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.accentGoldLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                      ],
                    ),
                    12.ver,
                    Center(
                      child: LiveTimerDisplay(
                        end: targetEnd,
                        format: LiveTimeFormat.short,
                        style: context.textTheme.headlineLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 32.sp,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    4.ver,
                    if (!isRamadan)
                      Center(
                        child: Text(
                          context.strings.daysRemainingUnit(remainingDays),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.darkTextSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    if (isRamadan) ...[
                      12.ver,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isArabic ? 'المغرب 07:10 م' : 'Maghrib 07:10 PM',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.darkTextSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            isArabic ? 'الفجر 05:10 ص' : 'Fajr 05:10 AM',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.darkTextSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
    );
  }
}

// =========================================================================
// ARCHIVED ORIGINAL RAMADAN HERO CARD WIDGET
// =========================================================================
// class RamadanHeroCardWidget extends StatelessWidget {
//   const RamadanHeroCardWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(22.r),
//       decoration: BoxDecoration(
//         color: AppColors.primaryDark,
//         borderRadius: BorderRadius.circular(22.r),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryDark.withValues(alpha: 0.25),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(Assets.ramadanIcon),
//               8.hor,
//               Text(
//                 context.strings.ramadanKareem,
//                 style: context.textTheme.bodySmall?.copyWith(
//                   color: AppColors.accentGoldLight,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 12.sp,
//                 ),
//               ),
//             ],
//           ),
//           8.ver,
//           Text(
//             context.strings.ramadanDay1Title,
//             style: context.textTheme.headlineMedium?.copyWith(
//               color: AppColors.white,
//               fontWeight: FontWeight.w800,
//               fontSize: 24.sp,
//             ),
//           ),
//           4.ver,
//           Text(
//             context.strings.ramadanDay1Date,
//             style: context.textTheme.bodySmall?.copyWith(
//               color: AppColors.darkTextSecondary,
//               fontSize: 13.sp,
//             ),
//           ),
//           20.ver,
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//             decoration: BoxDecoration(
//               color: AppColors.black.withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   context.strings.remainingOnRamadan,
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: AppColors.darkTextSecondary,
//                     fontSize: 13.sp,
//                   ),
//                 ),
//                 8.ver,
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.baseline,
//                   textBaseline: TextBaseline.alphabetic,
//                   children: [
//                     Text(
//                       '60:15:20',
//                       style: context.textTheme.headlineLarge?.copyWith(
//                         color: AppColors.white,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 30.sp,
//                         letterSpacing: 1.5,
//                       ),
//                     ),
//                     8.hor,
//                     Text(
//                       context.strings.daysRemainingUnit(1),
//                       style: context.textTheme.bodySmall?.copyWith(
//                         color: AppColors.darkTextSecondary,
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

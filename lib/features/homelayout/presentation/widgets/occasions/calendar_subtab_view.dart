import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/hijri_calendar_helper.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_event.dart';
import '../../bloc/homelayout_state.dart';
import 'calendar_grid_widget.dart';

class CalendarSubtabView extends StatelessWidget {
  const CalendarSubtabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final lang = isArabic ? 'ar' : 'en';

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.activeHijriMonth != curr.activeHijriMonth ||
          prev.activeHijriYear != curr.activeHijriYear ||
          prev.activeGregorianMonth != curr.activeGregorianMonth ||
          prev.activeGregorianYear != curr.activeGregorianYear ||
          prev.ramadanCheckData != curr.ramadanCheckData ||
          prev.currentLanguage != curr.currentLanguage,
      builder: (context, state) {
        final hijriData = state.ramadanCheckData?.hijriDate;
        final realHijriMonth = hijriData?.monthNumber ?? 3;
        final realHijriYear = hijriData?.yearNumber ?? 1448;
        final realHijriDay = hijriData?.dayNumber ?? 12;

        final isCurrentHijri = state.activeHijriMonth == realHijriMonth &&
            state.activeHijriYear == realHijriYear;

        final hijriMonthName = HijriCalendarHelper.getHijriMonthName(
          state.activeHijriMonth,
          language: lang,
        );
        final hijriTitle = '$hijriMonthName ${state.activeHijriYear}';

        final hijriCells = HijriCalendarHelper.generateHijriMonthGrid(
          monthNumber: state.activeHijriMonth,
          yearNumber: state.activeHijriYear,
          activeDay: isCurrentHijri ? realHijriDay : -1,
        );

        final now = DateTime.now();
        final isCurrentGreg = state.activeGregorianMonth == now.month &&
            state.activeGregorianYear == now.year;

        final gregMonthName = HijriCalendarHelper.getGregorianMonthName(
          state.activeGregorianMonth,
          language: lang,
        );
        final gregTitle = '$gregMonthName ${state.activeGregorianYear}';

        final gregCells = HijriCalendarHelper.generateGregorianMonthGrid(
          year: state.activeGregorianYear,
          month: state.activeGregorianMonth,
          activeDay: isCurrentGreg ? now.day : -1,
        );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.strings.hijriCalendarTitle,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              10.ver,
              CalendarGridWidget(
                title: hijriTitle,
                cells: hijriCells,
                isCurrentMonth: isCurrentHijri,
                onReturnToToday: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const ResetHijriMonthToCurrentEvent());
                },
                onPrev: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const NavigateHijriMonthEvent(-1));
                },
                onNext: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const NavigateHijriMonthEvent(1));
                },
              ),
              20.ver,
              Text(
                context.strings.gregorianCalendarTitle,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              10.ver,
              CalendarGridWidget(
                title: gregTitle,
                cells: gregCells,
                isCurrentMonth: isCurrentGreg,
                onReturnToToday: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const ResetGregorianMonthToCurrentEvent());
                },
                onPrev: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const NavigateGregorianMonthEvent(-1));
                },
                onNext: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const NavigateGregorianMonthEvent(1));
                },
              ),
              24.ver,
            ],
          ),
        );
      },
    );
  }
}

// =========================================================================
// ARCHIVED ORIGINAL CALENDAR SUBTAB VIEW
// =========================================================================
// class CalendarSubtabView extends StatelessWidget {
//   const CalendarSubtabView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDark;
//
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             context.strings.hijriCalendarTitle,
//             style: context.textTheme.bodyMedium?.copyWith(
//               color: isDark
//                   ? AppColors.darkTextSecondary
//                   : AppColors.lightTextSecondary,
//               fontWeight: FontWeight.w600,
//               fontSize: 13.sp,
//             ),
//           ),
//           10.ver,
//           const CalendarGridWidget(title: 'ربيع الأول 1448', activeDay: 9),
//           20.ver,
//           Text(
//             context.strings.gregorianCalendarTitle,
//             style: context.textTheme.bodyMedium?.copyWith(
//               color: isDark
//                   ? AppColors.darkTextSecondary
//                   : AppColors.lightTextSecondary,
//               fontWeight: FontWeight.w600,
//               fontSize: 13.sp,
//             ),
//           ),
//           10.ver,
//           const CalendarGridWidget(title: 'أغسطس 2026', activeDay: 9),
//           24.ver,
//         ],
//       ),
//     );
//   }
// }

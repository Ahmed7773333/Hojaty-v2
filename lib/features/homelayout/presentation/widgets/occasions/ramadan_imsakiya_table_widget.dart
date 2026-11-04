import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayers_helper.dart';
import '../../../data/models/ramadan_imsakiya_day_model.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';

class RamadanImsakiyaTableWidget extends StatelessWidget {
  const RamadanImsakiyaTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final lang = Localizations.localeOf(context).languageCode;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        final data = state.ramadanCheckData;
        final nextRamadan = data?.nextRamadan;
        final ramadanStart =
            nextRamadan?.targetDateTime ?? DateTime(2027, 2, 8);
        final hijriYear = data?.hijriDate.year ?? 1448;

        const helper = PrayersHelper(coordinates: GeoCoordinates.cairo);
        final imsakiyaDays = helper.generateRamadanImsakiya(
          ramadanStartDate: ramadanStart,
          now: DateTime.now(),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.strings.ramadanImsakiya,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  context.strings.hijriYearLabel(hijriYear),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            12.ver,
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCardUnselected
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected,
                  width: 1.0,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Table Header
                  Container(
                    color: AppColors.primaryDark,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    child: Row(
                      children: [
                        _buildCell(
                          context,
                          context.strings.dayColumn,
                          flex: 1,
                          isHeader: true,
                        ),
                        _buildCell(
                          context,
                          context.strings.fajr,
                          flex: 2,
                          isHeader: true,
                        ),
                        _buildCell(
                          context,
                          context.strings.dhuhr,
                          flex: 2,
                          isHeader: true,
                        ),
                        _buildCell(
                          context,
                          context.strings.asr,
                          flex: 2,
                          isHeader: true,
                        ),
                        _buildCell(
                          context,
                          context.strings.maghrib,
                          flex: 2,
                          isHeader: true,
                        ),
                        _buildCell(
                          context,
                          context.strings.isha,
                          flex: 2,
                          isHeader: true,
                        ),
                      ],
                    ),
                  ),

                  // Table Rows
                  ...List.generate(imsakiyaDays.length, (index) {
                    final day = imsakiyaDays[index];
                    final isHighlighted = day.isCurrentDay;

                    final rowBg = isHighlighted
                        ? (isDark
                            ? AppColors.darkCardSelected
                            : AppColors.accentGoldExtraLight)
                        : Colors.transparent;

                    return Container(
                      color: rowBg,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              children: [
                                _buildCell(
                                  context,
                                  '${day.dayNumber}',
                                  flex: 1,
                                  isHighlighted: isHighlighted,
                                ),
                                _buildCell(
                                  context,
                                  PrayersHelper.formatTimeTo12Hour(
                                    day.fajr,
                                    language: lang,
                                  ),
                                  flex: 2,
                                  isHighlighted: isHighlighted,
                                ),
                                _buildCell(
                                  context,
                                  PrayersHelper.formatTimeTo12Hour(
                                    day.dhuhr,
                                    language: lang,
                                  ),
                                  flex: 2,
                                  isHighlighted: isHighlighted,
                                ),
                                _buildCell(
                                  context,
                                  PrayersHelper.formatTimeTo12Hour(
                                    day.asr,
                                    language: lang,
                                  ),
                                  flex: 2,
                                  isHighlighted: isHighlighted,
                                ),
                                _buildCell(
                                  context,
                                  PrayersHelper.formatTimeTo12Hour(
                                    day.maghrib,
                                    language: lang,
                                  ),
                                  flex: 2,
                                  isHighlighted: isHighlighted,
                                ),
                                _buildCell(
                                  context,
                                  PrayersHelper.formatTimeTo12Hour(
                                    day.isha,
                                    language: lang,
                                  ),
                                  flex: 2,
                                  isHighlighted: isHighlighted,
                                ),
                              ],
                            ),
                          ),
                          if (index < imsakiyaDays.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: isDark
                                  ? AppColors.darkBorderUnselected
                                      .withValues(alpha: 0.3)
                                  : AppColors.lightBorderUnselected
                                      .withValues(alpha: 0.6),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCell(
    BuildContext context,
    String text, {
    required int flex,
    bool isHeader = false,
    bool isHighlighted = false,
  }) {
    final isDark = context.isDark;

    Color textColor;
    if (isHeader) {
      textColor = AppColors.white;
    } else if (isHighlighted) {
      textColor =
          isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark;
    } else {
      textColor =
          isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    }

    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontWeight: (isHeader || isHighlighted)
              ? FontWeight.w700
              : FontWeight.w600,
          fontSize: isHeader ? 11.5.sp : 10.sp,
        ),
      ),
    );
  }
}

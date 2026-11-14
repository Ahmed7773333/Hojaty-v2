import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/user_hive_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayers_helper.dart';
import '../../../data/models/ramadan_imsakiya_day_model.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_state.dart';
import 'ramadan_imsakiya_cell_widget.dart';
import 'ramadan_imsakiya_row_widget.dart';

class RamadanImsakiyaTableWidget extends StatefulWidget {
  const RamadanImsakiyaTableWidget({super.key});

  @override
  State<RamadanImsakiyaTableWidget> createState() =>
      _RamadanImsakiyaTableWidgetState();
}

class _RamadanImsakiyaTableWidgetState
    extends State<RamadanImsakiyaTableWidget> {
  DateTime? _lastComputedDate;
  DateTime? _lastStartDate;
  List<RamadanImsakiyaDayModel> _cachedDays = const [];

  List<RamadanImsakiyaDayModel> _getImsakiyaDays(DateTime ramadanStart) {
    final now = DateTime.now();
    if (_lastStartDate == ramadanStart &&
        _lastComputedDate?.day == now.day &&
        _lastComputedDate?.month == now.month &&
        _lastComputedDate?.year == now.year &&
        _cachedDays.isNotEmpty) {
      return _cachedDays;
    }

    final coords = UserHiveHelper.getCachedCoordinates();
    final helper = PrayersHelper(coordinates: coords);
    _lastStartDate = ramadanStart;
    _lastComputedDate = now;
    _cachedDays = helper.generateRamadanImsakiya(
      ramadanStartDate: ramadanStart,
      now: now,
    );
    return _cachedDays;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final lang = Localizations.localeOf(context).languageCode;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.ramadanCheckData != curr.ramadanCheckData ||
          prev.currentLanguage != curr.currentLanguage,
      builder: (context, state) {
        final data = state.ramadanCheckData;
        final nextRamadan = data?.nextRamadan;
        final ramadanStart =
            nextRamadan?.targetDateTime ?? DateTime(2027, 2, 8);
        final hijriYear = data?.hijriDate.year ?? 1448;
        final imsakiyaDays = _getImsakiyaDays(ramadanStart);

        return RepaintBoundary(
          child: Column(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        children: [
                          RamadanImsakiyaCellWidget(
                            text: context.strings.dayColumn,
                            flex: 1,
                            isHeader: true,
                          ),
                          RamadanImsakiyaCellWidget(
                            text: context.strings.fajr,
                            flex: 2,
                            isHeader: true,
                          ),
                          RamadanImsakiyaCellWidget(
                            text: context.strings.dhuhr,
                            flex: 2,
                            isHeader: true,
                          ),
                          RamadanImsakiyaCellWidget(
                            text: context.strings.asr,
                            flex: 2,
                            isHeader: true,
                          ),
                          RamadanImsakiyaCellWidget(
                            text: context.strings.maghrib,
                            flex: 2,
                            isHeader: true,
                          ),
                          RamadanImsakiyaCellWidget(
                            text: context.strings.isha,
                            flex: 2,
                            isHeader: true,
                          ),
                        ],
                      ),
                    ),

                    // Table Rows
                    ...List.generate(imsakiyaDays.length, (index) {
                      return RamadanImsakiyaRowWidget(
                        day: imsakiyaDays[index],
                        language: lang,
                        showDivider: index < imsakiyaDays.length - 1,
                      );
                    }),
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

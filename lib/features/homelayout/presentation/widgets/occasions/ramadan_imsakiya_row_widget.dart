import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/data/models/ramadan_imsakiya_day_model.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/ramadan_imsakiya_cell_widget.dart';

class RamadanImsakiyaRowWidget extends StatelessWidget {
  final RamadanImsakiyaDayModel day;
  final String language;
  final bool showDivider;

  const RamadanImsakiyaRowWidget({
    super.key,
    required this.day,
    required this.language,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isHighlighted = day.isCurrentDay;

    final rowBg = isHighlighted
        ? (isDark ? AppColors.darkCardSelected : AppColors.accentGoldExtraLight)
        : Colors.transparent;

    return ColoredBox(
      color: rowBg,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              children: [
                RamadanImsakiyaCellWidget(
                  text: '${day.dayNumber}',
                  flex: 1,
                  isHighlighted: isHighlighted,
                ),
                RamadanImsakiyaCellWidget(
                  text: PrayersHelper.formatTimeTo12Hour(
                    day.fajr,
                    language: language,
                  ),
                  flex: 2,
                  isHighlighted: isHighlighted,
                ),
                RamadanImsakiyaCellWidget(
                  text: PrayersHelper.formatTimeTo12Hour(
                    day.dhuhr,
                    language: language,
                  ),
                  flex: 2,
                  isHighlighted: isHighlighted,
                ),
                RamadanImsakiyaCellWidget(
                  text: PrayersHelper.formatTimeTo12Hour(
                    day.asr,
                    language: language,
                  ),
                  flex: 2,
                  isHighlighted: isHighlighted,
                ),
                RamadanImsakiyaCellWidget(
                  text: PrayersHelper.formatTimeTo12Hour(
                    day.maghrib,
                    language: language,
                  ),
                  flex: 2,
                  isHighlighted: isHighlighted,
                ),
                RamadanImsakiyaCellWidget(
                  text: PrayersHelper.formatTimeTo12Hour(
                    day.isha,
                    language: language,
                  ),
                  flex: 2,
                  isHighlighted: isHighlighted,
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: isDark
                  ? AppColors.darkBorderUnselected.withValues(alpha: 0.3)
                  : AppColors.lightBorderUnselected.withValues(alpha: 0.6),
            ),
        ],
      ),
    );
  }
}

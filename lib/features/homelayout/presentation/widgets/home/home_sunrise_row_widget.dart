import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';

class HomeSunriseRowWidget extends StatelessWidget {
  final DateTime sunriseTime;
  final bool isNext;

  const HomeSunriseRowWidget({
    super.key,
    required this.sunriseTime,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final rowBg = isNext
        ? (isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected)
        : AppColors.transparent;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wb_twilight_outlined,
                size: 24.r,
                color: isDark ? AppColors.white : AppColors.primaryDark,
              ),
              8.hor,
              Text(
                context.strings.sunrise,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          Text(
            PrayersHelper.formatTimeTo12Hour(
              sunriseTime,
              language: Localizations.localeOf(context).languageCode,
            ),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}

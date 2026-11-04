import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayer_time_model.dart';

class PrayerTypeIconWidget extends StatelessWidget {
  final PrayerType type;
  final double? size;
  final Color? color;

  const PrayerTypeIconWidget({
    super.key,
    required this.type,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final defaultMonochromeColor =
        color ?? (isDark ? AppColors.white : AppColors.primaryDark);

    switch (type) {
      case PrayerType.fajr:
        return SvgPicture.asset(
          Assets.fajrIcon,
          colorFilter: ColorFilter.mode(
            defaultMonochromeColor,
            BlendMode.srcIn,
          ),
        );
      case PrayerType.dhuhr:
        return SvgPicture.asset(
          Assets.dhuhrIcon,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      case PrayerType.asr:
        return SvgPicture.asset(
          Assets.asrIcon,
          colorFilter: ColorFilter.mode(
            defaultMonochromeColor,
            BlendMode.srcIn,
          ),
        );
      case PrayerType.maghrib:
        return SvgPicture.asset(
          Assets.maghribIcon,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      case PrayerType.isha:
        return SvgPicture.asset(
          Assets.ishaIcon,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
    }
  }
}

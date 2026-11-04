import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../data/models/athkar_category_model.dart';

class AthkarCategoryIconWidget extends StatelessWidget {
  final AthkarCategoryType type;

  const AthkarCategoryIconWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final monochromeColor = isDark ? AppColors.white : AppColors.primaryDark;

    switch (type) {
      case AthkarCategoryType.morning:
        return SvgPicture.asset(Assets.morningAzkharIcon);
      case AthkarCategoryType.evening:
        return SvgPicture.asset(Assets.eveningAzkharIcon);
      case AthkarCategoryType.sleep:
        return SvgPicture.asset(Assets.beforeSleepAzkharIcon);
      case AthkarCategoryType.afterPrayer:
        return SvgPicture.asset(
          Assets.afterPrayerAzkharIcon,
          colorFilter: ColorFilter.mode(monochromeColor, BlendMode.srcIn),
        );
      case AthkarCategoryType.misc:
        return SvgPicture.asset(Assets.varietyAzkharIcon);
      case AthkarCategoryType.sebha:
        return Icon(
          Icons.fingerprint_rounded,
          color: monochromeColor,
          size: 28,
        );
      case AthkarCategoryType.istikhara:
        return SvgPicture.asset(
          Assets.afterPrayerAzkharIcon,
          colorFilter: ColorFilter.mode(monochromeColor, BlendMode.srcIn),
        );
    }
  }
}

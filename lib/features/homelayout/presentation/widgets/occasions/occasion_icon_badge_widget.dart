import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/occasion_item_model.dart';

class OccasionIconBadgeWidget extends StatelessWidget {
  final OccasionIconType type;

  const OccasionIconBadgeWidget({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case OccasionIconType.sheep:
        return Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6F4),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.pets_rounded,
            color: AppColors.primaryDark,
            size: 24.r,
          ),
        );
      case OccasionIconType.calendar:
        return Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6F4),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.calendar_today_rounded,
            color: AppColors.primaryDark,
            size: 24.r,
          ),
        );
      case OccasionIconType.sparkle:
      case OccasionIconType.prophetBirthday:
        return Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6F4),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primaryDark,
            size: 24.r,
          ),
        );
    }
  }
}

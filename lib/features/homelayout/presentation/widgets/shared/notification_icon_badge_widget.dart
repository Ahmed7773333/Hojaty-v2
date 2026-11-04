import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/notification_item_model.dart';

class NotificationIconBadgeWidget extends StatelessWidget {
  final NotificationIconType type;

  const NotificationIconBadgeWidget({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case NotificationIconType.prayer:
        return Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6F4),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.mosque_rounded,
            color: AppColors.primaryDark,
            size: 24.r,
          ),
        );
      case NotificationIconType.occasion:
        return Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF4E8),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.crop_square_rounded,
            color: AppColors.accentGoldDark,
            size: 24.r,
          ),
        );
      case NotificationIconType.athkar:
        return Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6F4),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.wb_twilight_rounded,
            color: const Color(0xFFEA580C),
            size: 24.r,
          ),
        );
    }
  }
}

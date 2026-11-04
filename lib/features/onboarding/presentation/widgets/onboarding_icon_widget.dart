import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/onboarding_item_model.dart';

class OnboardingIconWidget extends StatelessWidget {
  final OnboardingIconType type;

  const OnboardingIconWidget({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case OnboardingIconType.prayerTimes:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.nightlight_round,
              size: 38.r,
              color: AppColors.darkTextSecondary.withValues(alpha: 0.8),
            ),
            Positioned(
              top: 18.r,
              right: 18.r,
              child: Container(
                width: 6.r,
                height: 6.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentGoldLight,
                ),
              ),
            ),
          ],
        );
      case OnboardingIconType.quranAthkar:
        return Icon(
          Icons.menu_book_rounded,
          size: 38.r,
          color: AppColors.accentGoldLight,
        );
      case OnboardingIconType.anaOsaly:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 38.r,
              color: AppColors.darkTextSecondary,
            ),
            Icon(
              Icons.check,
              size: 22.r,
              color: AppColors.accentGoldLight,
            ),
          ],
        );
      case OnboardingIconType.hijriCalendar:
        return Icon(
          Icons.calendar_month_rounded,
          size: 38.r,
          color: AppColors.accentGoldLight,
        );
    }
  }
}

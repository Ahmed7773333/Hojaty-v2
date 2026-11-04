import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/adhan_sound_model.dart';

class AdhanSoundRowWidget extends StatelessWidget {
  final AdhanSoundModel sound;
  final bool isSelected;
  final VoidCallback onTap;

  const AdhanSoundRowWidget({
    super.key,
    required this.sound,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIconData(AdhanSoundIconType type) {
    switch (type) {
      case AdhanSoundIconType.makkah:
        return Icons.crop_square_rounded;
      case AdhanSoundIconType.madinah:
        return Icons.mosque_rounded;
      case AdhanSoundIconType.mic:
        return Icons.mic_rounded;
      case AdhanSoundIconType.bell:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getIconColor(AdhanSoundIconType type) {
    switch (type) {
      case AdhanSoundIconType.makkah:
        return AppColors.primaryDark;
      case AdhanSoundIconType.madinah:
        return AppColors.accentGoldDark;
      case AdhanSoundIconType.mic:
        return const Color(0xFF4B5563);
      case AdhanSoundIconType.bell:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconData(sound.iconType),
                  color: _getIconColor(sound.iconType),
                  size: 20.r,
                ),
                12.hor,

                Text(
                  sound.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Container(
                width: 22.r,
                height: 22.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryDarkBackground,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.white,
                  size: 14.r,
                ),
              )
            else
              const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }
}

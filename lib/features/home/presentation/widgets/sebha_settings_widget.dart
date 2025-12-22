import 'package:flutter/material.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart'; // fallback extension

class SebhaSettingsWidget extends StatelessWidget {
  final bool isSoundEnabled;
  final bool isVibrateEnabled;
  final VoidCallback onReset;
  final VoidCallback onToggleSound;
  final VoidCallback onToggleVibrate;

  const SebhaSettingsWidget({
    super.key,
    required this.isSoundEnabled,
    required this.isVibrateEnabled,
    required this.onReset,
    required this.onToggleSound,
    required this.onToggleVibrate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SettingToggle(
          enabled: true,
          onTap: onReset,
          iconOn: Icons.refresh,
          iconOff: Icons.refresh,
          label: context.strings.reset,
        ),
        _SettingToggle(
          enabled: isSoundEnabled,
          onTap: onToggleSound,
          iconOn: Icons.volume_up,
          iconOff: Icons.volume_off,
          label: context.strings.sound,
        ),
        _SettingToggle(
          enabled: isVibrateEnabled,
          onTap: onToggleVibrate,
          iconOn: Icons.vibration,
          iconOff: Icons.vibration_outlined,
          label: context.strings.vibrate,
        ),
      ],
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;
  final IconData iconOn;
  final IconData iconOff;
  final String label;

  const _SettingToggle({
    required this.enabled,
    required this.onTap,
    required this.iconOn,
    required this.iconOff,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final bg = enabled
        ? AppColor.secondaryColor.withValues(alpha: .12)
        : AppColor.surfaceColor;
    final border = enabled ? AppColor.secondaryColor : Colors.grey.shade300;
    final icon = enabled ? iconOn : iconOff;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72.w,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .02),
              blurRadius: 6.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: enabled ? AppColor.secondaryColor : Colors.grey,
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: AppTextStyles.notoKufiArabicBody13Medium.copyWith(
                color: enabled ? AppColor.secondaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

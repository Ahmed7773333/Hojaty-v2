import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:flutter/material.dart';

class RadioSpeedPickerDialog extends StatelessWidget {
  final double currentSpeed;
  final ValueChanged<double> onSpeedSelected;

  const RadioSpeedPickerDialog({
    super.key,
    required this.currentSpeed,
    required this.onSpeedSelected,
  });

  static const List<double> speeds = [0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        context.strings.playbackSpeed,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: speeds.map((speed) {
          final isSelected = (currentSpeed - speed).abs() < 0.01;
          final label = speed == 1.0
              ? '${speed}x (${context.strings.speedNormal})'
              : '${speed}x';

          return ListTile(
            dense: true,
            title: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected
                    ? AppColors.accentGold
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
              ),
            ),
            trailing: isSelected
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.accentGold,
                    size: 20,
                  )
                : null,
            onTap: () {
              onSpeedSelected(speed);
              context.pop();
            },
          );
        }).toList(),
      ),
    );
  }
}

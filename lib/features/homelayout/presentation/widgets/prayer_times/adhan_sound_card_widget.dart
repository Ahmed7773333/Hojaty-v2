import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/adhan_sound_model.dart';
import 'adhan_sound_row_widget.dart';

class AdhanSoundCardWidget extends StatelessWidget {
  final List<AdhanSoundModel> sounds;
  final String selectedId;
  final ValueChanged<String> onSelect;

  const AdhanSoundCardWidget({
    super.key,
    required this.sounds,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.adhanSoundSectionTitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
        10.ver,
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
              width: 1.0,
            ),
          ),
          child: Column(
            children: List.generate(sounds.length, (index) {
              final sound = sounds[index];
              return Column(
                children: [
                  AdhanSoundRowWidget(
                    sound: sound,
                    isSelected: selectedId == sound.id,
                    onTap: () => onSelect(sound.id),
                  ),
                  if (index < sounds.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? AppColors.darkBorderUnselected.withValues(
                              alpha: 0.5,
                            )
                          : AppColors.lightBorderUnselected.withValues(
                              alpha: 0.6,
                            ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/adhan_sound_model.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_more_sounds_button_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_sound_row_widget.dart';

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
        12.ver,
        const AdhanMoreSoundsButtonWidget(),
      ],
    );
  }
}

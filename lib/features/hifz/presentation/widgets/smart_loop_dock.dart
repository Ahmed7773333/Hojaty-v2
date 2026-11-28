import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_state.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_stepper_control.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';
import 'package:material_ui/material_ui.dart';

class SmartLoopDock extends StatelessWidget {
  final HifzSessionState state;
  final VoidCallback onPickReciter;
  final VoidCallback onCycleSpeed;
  final VoidCallback onToggleTestingMode;
  final VoidCallback onCycleAyahRepeat;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onCycleRangeRepeat;
  final VoidCallback onToggleChaining;
  final VoidCallback onTogglePauseToRepeat;
  final VoidCallback onCompleteWird;

  const SmartLoopDock({
    super.key,
    required this.state,
    required this.onPickReciter,
    required this.onCycleSpeed,
    required this.onToggleTestingMode,
    required this.onCycleAyahRepeat,
    required this.onTogglePlayPause,
    required this.onCycleRangeRepeat,
    required this.onToggleChaining,
    required this.onTogglePauseToRepeat,
    required this.onCompleteWird,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isTesting = state.phase == SessionPhase.testingMode;
    final isPlaying = state.phase == SessionPhase.playing ||
        state.phase == SessionPhase.pausingForRepeat;
    final ayahRepeatLabel =
        state.ayahRepeatCount == -1 ? '∞' : '${state.ayahRepeatCount}×';
    final rangeRepeatLabel = '${state.rangeRepeatCount}×';
    final speedLabel = '${state.playbackSpeed}×';

    return LiquidGlassContainer(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
      fallbackDecoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onPickReciter,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardUnselected
                            : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorderUnselected
                              : AppColors.lightBorderUnselected,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.record_voice_over_rounded,
                            size: 16.r,
                            color: AppColors.accentGold,
                          ),
                          6.hor,
                          Expanded(
                            child: Text(
                              state.reciter.localizedName(isArabic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.labelMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18.r,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                8.hor,
                ActionChip(
                  onPressed: onCycleSpeed,
                  label: Text(speedLabel),
                ),
                8.hor,
                FilterChip(
                  selected: isTesting,
                  onSelected: (_) => onToggleTestingMode(),
                  avatar: Icon(
                    isTesting
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_outlined,
                    size: 16.r,
                  ),
                  label: Text(
                    isTesting
                        ? context.strings.hifzShowText
                        : context.strings.hifzHideToTest,
                  ),
                ),
              ],
            ),
            12.ver,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: HifzStepperControl(
                    label: context.strings.hifzAyahRepeatLabel,
                    valueLabel: ayahRepeatLabel,
                    onTap: onCycleAyahRepeat,
                  ),
                ),
                16.hor,
                FloatingActionButton(
                  heroTag: 'hifz_studio_play_fab',
                  onPressed: onTogglePlayPause,
                  backgroundColor:
                      isDark ? AppColors.accentGold : AppColors.primaryDark,
                  foregroundColor:
                      isDark ? AppColors.primaryDarkHeader : AppColors.white,
                  child: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 32.r,
                  ),
                ),
                16.hor,
                Expanded(
                  child: HifzStepperControl(
                    label: context.strings.hifzRangeRepeatLabel,
                    valueLabel: rangeRepeatLabel,
                    onTap: onCycleRangeRepeat,
                  ),
                ),
              ],
            ),
            10.ver,
            Wrap(
              spacing: 10.w,
              alignment: WrapAlignment.center,
              children: [
                FilterChip(
                  selected: state.cumulativeChaining,
                  onSelected: (_) => onToggleChaining(),
                  avatar: Icon(Icons.link_rounded, size: 16.r),
                  label: Text(context.strings.hifzChainingChip),
                ),
                FilterChip(
                  selected: state.pauseToRepeat,
                  onSelected: (_) => onTogglePauseToRepeat(),
                  avatar: Icon(Icons.mic_none_rounded, size: 16.r),
                  label: Text(context.strings.hifzPauseChip),
                ),
              ],
            ),
            10.ver,
            CustomElevatedButton(
              text: context.strings.hifzCompleteWird,
              height: 44.h,
              borderRadius: 16.r,
              onPressed: onCompleteWird,
            ),
          ],
        ),
      ),
    );
  }
}


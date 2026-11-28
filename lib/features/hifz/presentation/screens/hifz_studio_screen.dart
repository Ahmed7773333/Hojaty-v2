import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/widgets/liquid_glass_backdrop.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_hub_cubit.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_cubit.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_state.dart';
import 'package:hojaty/features/hifz/presentation/widgets/focus_card_view.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_live_phase_bar.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_offline_banner.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_reciter_picker_sheet.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_studio_header.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_studio_settings_sheet.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_wird_completion_dialog.dart';
import 'package:hojaty/features/hifz/presentation/widgets/mushaf_overlay_view.dart';
import 'package:hojaty/features/hifz/presentation/widgets/repeat_countdown_pill.dart';
import 'package:hojaty/features/hifz/presentation/widgets/smart_loop_dock.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:material_ui/material_ui.dart';

class HifzStudioScreen extends StatelessWidget {
  const HifzStudioScreen({super.key});

  static const List<int> _ayahRepeatCycle = [1, 3, 5, 7, 10, -1];
  static const List<int> _rangeRepeatCycle = [1, 2, 3, 5];

  void _handleBack(BuildContext context, HifzSessionState state) {
    if (state.isAudioActive) {
      context.read<HifzSessionCubit>().minimizeSession();
    }
    Navigator.of(context).pop();
  }

  Future<void> _completeWird(
    BuildContext context,
    HifzSessionState state,
  ) async {
    final sessionCubit = context.read<HifzSessionCubit>();
    final hubCubit = context.read<HifzHubCubit>();
    await sessionCubit.markWirdCompleted();
    await hubCubit.completeTodayWird(
      planId: state.planId,
      startGlobalAyah: state.rangeStartGlobalAyah,
      endGlobalAyah: state.rangeEndGlobalAyah,
    );
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => HifzWirdCompletionDialog(
        onDone: () {
          Navigator.of(dialogContext).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocBuilder<HifzSessionCubit, HifzSessionState>(
      builder: (context, state) {
        final cubit = context.read<HifzSessionCubit>();
        final startMapped = GlobalAyahMapper.fromGlobalAyahId(
          state.rangeStartGlobalAyah,
        );
        final endMapped = GlobalAyahMapper.fromGlobalAyahId(
          state.rangeEndGlobalAyah,
        );
        final surahInfo = QuranConstants.surahMap[startMapped.surah];
        final surahName = isArabic
            ? (surahInfo?.name ?? '')
            : (surahInfo?.englishName ?? '');
        final headerTitle =
            '$surahName (${context.strings.hifzAyahRange(startMapped.ayah, endMapped.ayah)})';

        return PopScope(
          onPopInvokedWithResult: (didPop, _) {
            if (didPop && state.isAudioActive) {
              cubit.minimizeSession();
            }
          },
          child: Scaffold(
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            body: LiquidGlassBackdrop(
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    HifzStudioHeader(
                      title: headerTitle,
                      viewMode: state.viewMode,
                      onBack: () => _handleBack(context, state),
                      onViewModeChanged: cubit.setViewMode,
                      onOpenSettings: () => showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: AppColors.transparent,
                        builder: (_) => const HifzStudioSettingsSheet(),
                      ),
                    ),
                    HifzLivePhaseBar(
                      step: state.currentStep,
                      stepProgress: state.stepProgress,
                    ),
                    if (state.phase == SessionPhase.offlineBlocked &&
                        state.offlineBlockedAyah != null)
                      HifzOfflineBanner(
                        ayahNumber: GlobalAyahMapper.fromGlobalAyahId(
                          state.offlineBlockedAyah!,
                        ).ayah,
                        onSwitchToSilentTest:
                            cubit.switchToSilentTestingFromOffline,
                      ),
                    if (state.phase == SessionPhase.pausingForRepeat)
                      RepeatCountdownPill(
                        remainingListenable: cubit.pauseRemainingListenable,
                        totalListenable: cubit.pauseTotalListenable,
                        onSkip: cubit.skipPause,
                      ),
                    Expanded(
                      child: state.viewMode == ViewMode.focusCard
                          ? FocusCardView(
                              ayahs: state.ayahContents,
                              activeGlobalAyahId: state.activeGlobalAyahId,
                              isTestingMode:
                                  state.phase == SessionPhase.testingMode,
                              revealedAyahs: state.revealedAyahs,
                              hintedAyahs: state.hintedAyahs,
                              masteredAyahs: state.masteredAyahs,
                              needsReviewAyahs: state.needsReviewAyahs,
                              ayahCacheMap: state.ayahCacheMap,
                              onSelectAyah: cubit.selectAyah,
                              onHintFirstWords: cubit.revealFirstWordsHint,
                              onHintAudio: cubit.playAudioHint,
                              onMarkResult: (id, mastered) =>
                                  cubit.markAyahResult(id, mastered: mastered),
                            )
                          : MushafOverlayView(
                              ayahs: state.ayahContents,
                              activeGlobalAyahId: state.activeGlobalAyahId,
                              isTestingMode:
                                  state.phase == SessionPhase.testingMode,
                              revealedAyahs: state.revealedAyahs,
                              onTapAyah: cubit.selectAyah,
                            ),
                    ),
                    SmartLoopDock(
                      state: state,
                      onPickReciter: () => showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: AppColors.transparent,
                        builder: (_) => HifzReciterPickerSheet(
                          selectedReciterId: state.reciter.id,
                          onSelect: cubit.setReciter,
                        ),
                      ),
                      onCycleSpeed: cubit.cyclePlaybackSpeed,
                      onToggleTestingMode: cubit.toggleTestingMode,
                      onCycleAyahRepeat: () {
                        final idx = _ayahRepeatCycle.indexOf(
                          state.ayahRepeatCount,
                        );
                        final next =
                            _ayahRepeatCycle[(idx + 1) % _ayahRepeatCycle.length];
                        cubit.setAyahRepeatCount(next);
                      },
                      onTogglePlayPause: cubit.togglePlayPause,
                      onCycleRangeRepeat: () {
                        final idx = _rangeRepeatCycle.indexOf(
                          state.rangeRepeatCount,
                        );
                        final next =
                            _rangeRepeatCycle[(idx + 1) % _rangeRepeatCycle.length];
                        cubit.setRangeRepeatCount(next);
                      },
                      onToggleChaining: cubit.toggleCumulativeChaining,
                      onTogglePauseToRepeat: cubit.togglePauseToRepeat,
                      onCompleteWird: () => _completeWird(context, state),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


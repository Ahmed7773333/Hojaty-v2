import 'package:hojaty/features/hifz/domain/entities/hifz_step.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';

/// Pure Dart deterministic playback queue generator for Hifz memorization.
class GeneratePlaybackQueue {
  const GeneratePlaybackQueue();

  /// Generates a flat, deterministic list of [HifzStep]s for [startGlobalAyah]..[endGlobalAyah].
  ///
  /// - Prepends Basmalah (`001001`) once when starting on ayah 1 of any surah except
  ///   Al-Fatihah (1) and At-Tawbah (9).
  /// - Supports infinity mode when [ayahRepeatCount] == `-1`.
  /// - Supports Cumulative Chaining (`الربط التراكمي`) after each newly repeated ayah.
  List<HifzStep> call({
    required int startGlobalAyah,
    required int endGlobalAyah,
    required int ayahRepeatCount,
    required int rangeRepeatCount,
    required bool cumulativeChaining,
    bool includeBasmalahIfStartOfSurah = true,
  }) {
    RangeError.checkValueInInterval(
      startGlobalAyah,
      1,
      GlobalAyahMapper.totalAyahs,
      'startGlobalAyah',
    );
    RangeError.checkValueInInterval(
      endGlobalAyah,
      startGlobalAyah,
      GlobalAyahMapper.totalAyahs,
      'endGlobalAyah',
    );

    final steps = <HifzStep>[];

    if (includeBasmalahIfStartOfSurah) {
      final first = GlobalAyahMapper.fromGlobalAyahId(startGlobalAyah);
      if (first.ayah == 1 && first.surah != 1 && first.surah != 9) {
        steps.add(
          const HifzStep(
            globalAyahId: 1,
            surah: 1,
            ayah: 1,
            repeatIndex: 1,
            totalRepeats: 1,
            rangeLoopIndex: 1,
            stepType: StepType.basmalah,
          ),
        );
      }
    }

    final safeRangeRepeats = rangeRepeatCount.clamp(1, 50);
    final isInfinity = ayahRepeatCount == -1;
    final safeAyahRepeats = isInfinity ? 1 : ayahRepeatCount.clamp(1, 50);

    for (int rangePass = 1; rangePass <= safeRangeRepeats; rangePass++) {
      for (int g = startGlobalAyah; g <= endGlobalAyah; g++) {
        final mapped = GlobalAyahMapper.fromGlobalAyahId(g);

        if (isInfinity) {
          steps.add(
            HifzStep(
              globalAyahId: g,
              surah: mapped.surah,
              ayah: mapped.ayah,
              repeatIndex: 1,
              totalRepeats: -1,
              rangeLoopIndex: rangePass,
              stepType: StepType.singleRepeat,
            ),
          );
        } else {
          for (int r = 1; r <= safeAyahRepeats; r++) {
            steps.add(
              HifzStep(
                globalAyahId: g,
                surah: mapped.surah,
                ayah: mapped.ayah,
                repeatIndex: r,
                totalRepeats: safeAyahRepeats,
                rangeLoopIndex: rangePass,
                stepType: StepType.singleRepeat,
              ),
            );
          }
        }

        if (cumulativeChaining && g > startGlobalAyah) {
          for (int c = startGlobalAyah; c <= g; c++) {
            final chainMapped = GlobalAyahMapper.fromGlobalAyahId(c);
            steps.add(
              HifzStep(
                globalAyahId: c,
                surah: chainMapped.surah,
                ayah: chainMapped.ayah,
                repeatIndex: 1,
                totalRepeats: 1,
                rangeLoopIndex: rangePass,
                stepType: StepType.chainLink,
              ),
            );
          }
        }
      }
    }

    return steps;
  }

  /// Snaps `currentStepIndex` to the first matching step of [currentGlobalAyahId]
  /// inside [newQueue] after a live mid-session config mutation.
  int snapStepIndex({
    required List<HifzStep> newQueue,
    required int currentGlobalAyahId,
    StepType? preferredType,
  }) {
    if (newQueue.isEmpty) return 0;

    if (preferredType != null && preferredType != StepType.basmalah) {
      final exactPreferred = newQueue.indexWhere(
        (s) =>
            s.globalAyahId == currentGlobalAyahId &&
            s.stepType == preferredType,
      );
      if (exactPreferred != -1) return exactPreferred;
    }

    final nonBasmalahMatch = newQueue.indexWhere(
      (s) =>
          s.globalAyahId == currentGlobalAyahId &&
          s.stepType != StepType.basmalah,
    );
    if (nonBasmalahMatch != -1) return nonBasmalahMatch;

    final anyMatch = newQueue.indexWhere(
      (s) => s.globalAyahId == currentGlobalAyahId,
    );
    if (anyMatch != -1) return anyMatch;

    final nextGreater = newQueue.indexWhere(
      (s) =>
          s.globalAyahId >= currentGlobalAyahId &&
          s.stepType != StepType.basmalah,
    );
    return nextGreater != -1 ? nextGreater : 0;
  }
}


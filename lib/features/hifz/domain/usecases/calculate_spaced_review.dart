import 'dart:math' as math;

import 'package:hojaty/features/hifz/domain/entities/ayah_mastery.dart';

/// Leitner 5-Box Spaced Repetition scheduler for Hifz ayahs.
class CalculateSpacedReview {
  const CalculateSpacedReview();

  /// Intervals in days for Box 1 through Box 5.
  static const List<int> leitnerIntervalDays = <int>[1, 3, 7, 14, 30];

  /// Creates the initial Box 1 mastery entry when an ayah is first memorized.
  AyahMastery createInitial({
    required int globalAyahId,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    return AyahMastery(
      globalAyahId: globalAyahId,
      masteryLevel: 1,
      lastReviewedAt: timestamp,
      nextReviewAt: timestamp.add(Duration(days: leitnerIntervalDays[0])),
      lapseCount: 0,
    );
  }

  /// Computes the updated [AyahMastery] after a review attempt.
  ///
  /// - On [recalled] == true: promotes `level = min(5, level + 1)`.
  /// - On [recalled] == false: demotes `level = max(1, level - 1)` and increments `lapseCount`.
  AyahMastery call({
    AyahMastery? existing,
    required int globalAyahId,
    required bool recalled,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    final currentLevel = (existing?.masteryLevel ?? 1).clamp(1, 5);
    final currentLapses = existing?.lapseCount ?? 0;

    final int newLevel;
    final int newLapses;

    if (recalled) {
      newLevel = math.min(5, currentLevel + 1);
      newLapses = currentLapses;
    } else {
      newLevel = math.max(1, currentLevel - 1);
      newLapses = currentLapses + 1;
    }

    final intervalDays = leitnerIntervalDays[newLevel - 1];
    return AyahMastery(
      globalAyahId: globalAyahId,
      masteryLevel: newLevel,
      lastReviewedAt: timestamp,
      nextReviewAt: timestamp.add(Duration(days: intervalDays)),
      lapseCount: newLapses,
    );
  }
}


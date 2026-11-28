import 'package:equatable/equatable.dart';

/// Leitner 5-box mastery record for a single ayah (`ayah_mastery`).
class AyahMastery extends Equatable {
  final int globalAyahId;
  final int masteryLevel;
  final DateTime lastReviewedAt;
  final DateTime nextReviewAt;
  final int lapseCount;

  const AyahMastery({
    required this.globalAyahId,
    required this.masteryLevel,
    required this.lastReviewedAt,
    required this.nextReviewAt,
    required this.lapseCount,
  });

  AyahMastery copyWith({
    int? globalAyahId,
    int? masteryLevel,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    int? lapseCount,
  }) {
    return AyahMastery(
      globalAyahId: globalAyahId ?? this.globalAyahId,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lapseCount: lapseCount ?? this.lapseCount,
    );
  }

  @override
  List<Object?> get props => [
        globalAyahId,
        masteryLevel,
        lastReviewedAt,
        nextReviewAt,
        lapseCount,
      ];
}


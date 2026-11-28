import 'package:equatable/equatable.dart';

/// Daily memorization & review activity entry (`hifz_activity_logs`).
class HifzActivityLog extends Equatable {
  final int? id;
  final int? planId;
  final String dateYmd;
  final int ayahsMemorized;
  final int ayahsReviewed;
  final int listeningSeconds;

  const HifzActivityLog({
    this.id,
    this.planId,
    required this.dateYmd,
    required this.ayahsMemorized,
    required this.ayahsReviewed,
    required this.listeningSeconds,
  });

  @override
  List<Object?> get props => [
        id,
        planId,
        dateYmd,
        ayahsMemorized,
        ayahsReviewed,
        listeningSeconds,
      ];
}


import 'package:equatable/equatable.dart';

/// Persistent Hifz memorization plan stored in SQLite (`hifz_plans`).
class HifzPlan extends Equatable {
  final int? id;
  final String? trackKey;
  final String title;
  final int surahId;
  final int startGlobalAyah;
  final int endGlobalAyah;
  final int currentGlobalAyah;
  final int dailyTargetAyahs;
  final bool isActive;
  final DateTime createdAt;

  const HifzPlan({
    this.id,
    this.trackKey,
    required this.title,
    required this.surahId,
    required this.startGlobalAyah,
    required this.endGlobalAyah,
    required this.currentGlobalAyah,
    required this.dailyTargetAyahs,
    required this.isActive,
    required this.createdAt,
  });

  int get totalAyahs => (endGlobalAyah - startGlobalAyah + 1).clamp(1, 6236);

  int get completedAyahs =>
      (currentGlobalAyah - startGlobalAyah).clamp(0, totalAyahs);

  double get progress => (completedAyahs / totalAyahs).clamp(0.0, 1.0);

  bool get isCompleted => currentGlobalAyah > endGlobalAyah;

  int get todayStartGlobalAyah =>
      currentGlobalAyah.clamp(startGlobalAyah, endGlobalAyah);

  int get todayEndGlobalAyah =>
      (todayStartGlobalAyah + dailyTargetAyahs - 1).clamp(
        todayStartGlobalAyah,
        endGlobalAyah,
      );

  int get estimatedTotalDays =>
      (totalAyahs / dailyTargetAyahs.clamp(1, 286)).ceil().clamp(1, 999);

  int get currentDayNumber {
    if (isCompleted) return estimatedTotalDays;
    final day =
        (completedAyahs / dailyTargetAyahs.clamp(1, 286)).floor() + 1;
    return day.clamp(1, estimatedTotalDays);
  }

  HifzPlan copyWith({
    int? id,
    String? trackKey,
    String? title,
    int? surahId,
    int? startGlobalAyah,
    int? endGlobalAyah,
    int? currentGlobalAyah,
    int? dailyTargetAyahs,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return HifzPlan(
      id: id ?? this.id,
      trackKey: trackKey ?? this.trackKey,
      title: title ?? this.title,
      surahId: surahId ?? this.surahId,
      startGlobalAyah: startGlobalAyah ?? this.startGlobalAyah,
      endGlobalAyah: endGlobalAyah ?? this.endGlobalAyah,
      currentGlobalAyah: currentGlobalAyah ?? this.currentGlobalAyah,
      dailyTargetAyahs: dailyTargetAyahs ?? this.dailyTargetAyahs,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        trackKey,
        title,
        surahId,
        startGlobalAyah,
        endGlobalAyah,
        currentGlobalAyah,
        dailyTargetAyahs,
        isActive,
        createdAt,
      ];
}


import 'package:equatable/equatable.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';

/// Curated memorization journey loaded from `assets/data/hifz_tracks.json`.
class CuratedTrack extends Equatable {
  final String trackKey;
  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final int surahId;
  final int startGlobalAyah;
  final int endGlobalAyah;
  final int dailyTargetAyahs;
  final int reviewEveryNDays;
  final int estimatedDays;
  final String difficulty;

  const CuratedTrack({
    required this.trackKey,
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.surahId,
    required this.startGlobalAyah,
    required this.endGlobalAyah,
    required this.dailyTargetAyahs,
    required this.reviewEveryNDays,
    required this.estimatedDays,
    required this.difficulty,
  });

  int get totalAyahs =>
      (endGlobalAyah - startGlobalAyah + 1).clamp(1, GlobalAyahMapper.totalAyahs);

  String localizedTitle(bool isArabic) => isArabic ? titleAr : titleEn;

  String localizedSubtitle(bool isArabic) => isArabic ? subtitleAr : subtitleEn;

  @override
  List<Object?> get props => [
        trackKey,
        titleAr,
        titleEn,
        subtitleAr,
        subtitleEn,
        surahId,
        startGlobalAyah,
        endGlobalAyah,
        dailyTargetAyahs,
        reviewEveryNDays,
        estimatedDays,
        difficulty,
      ];
}


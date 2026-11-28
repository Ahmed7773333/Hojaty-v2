import 'package:hojaty/features/hifz/domain/entities/curated_track.dart';

/// JSON serialization adapter for [CuratedTrack].
class CuratedTrackModel {
  const CuratedTrackModel._();

  static CuratedTrack fromJson(Map<String, dynamic> json) {
    return CuratedTrack(
      trackKey: json['track_key'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? (json['title_ar'] as String? ?? ''),
      subtitleAr: json['subtitle_ar'] as String? ?? '',
      subtitleEn: json['subtitle_en'] as String? ?? (json['subtitle_ar'] as String? ?? ''),
      surahId: (json['surah_id'] as num?)?.toInt() ?? 0,
      startGlobalAyah: (json['start_global_ayah'] as num?)?.toInt() ?? 1,
      endGlobalAyah: (json['end_global_ayah'] as num?)?.toInt() ?? 1,
      dailyTargetAyahs: (json['daily_target_ayahs'] as num?)?.toInt() ?? 5,
      reviewEveryNDays: (json['review_every_n_days'] as num?)?.toInt() ?? 4,
      estimatedDays: (json['estimated_days'] as num?)?.toInt() ?? 7,
      difficulty: json['difficulty'] as String? ?? 'beginner',
    );
  }
}


import 'package:equatable/equatable.dart';
import 'package:hojaty/features/hifz/domain/entities/ayah_mastery.dart';
import 'package:hojaty/features/hifz/domain/entities/curated_track.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_plan.dart';
import 'package:hojaty/features/hifz/domain/entities/surah_cache_summary.dart';

enum HifzHubStatus { initial, loading, success, failure }

class HifzHubState extends Equatable {
  final HifzHubStatus status;
  final HifzPlan? activePlan;
  final List<HifzPlan> allPlans;
  final List<AyahMastery> dueReviews;
  final List<String> dueSurahNamesAr;
  final List<String> dueSurahNamesEn;
  final int dueEstimatedMinutes;
  final int streakDays;
  final List<CuratedTrack> curatedTracks;
  final int totalCachedBytes;
  final List<SurahCacheSummary> cachedSurahSummaries;
  final int? downloadingSurahId;
  final String? downloadingReciterId;
  final double surahDownloadProgress;
  final String? errorMessage;

  const HifzHubState({
    this.status = HifzHubStatus.initial,
    this.activePlan,
    this.allPlans = const [],
    this.dueReviews = const [],
    this.dueSurahNamesAr = const [],
    this.dueSurahNamesEn = const [],
    this.dueEstimatedMinutes = 0,
    this.streakDays = 0,
    this.curatedTracks = const [],
    this.totalCachedBytes = 0,
    this.cachedSurahSummaries = const [],
    this.downloadingSurahId,
    this.downloadingReciterId,
    this.surahDownloadProgress = 0.0,
    this.errorMessage,
  });

  HifzHubState copyWith({
    HifzHubStatus? status,
    HifzPlan? activePlan,
    bool clearActivePlan = false,
    List<HifzPlan>? allPlans,
    List<AyahMastery>? dueReviews,
    List<String>? dueSurahNamesAr,
    List<String>? dueSurahNamesEn,
    int? dueEstimatedMinutes,
    int? streakDays,
    List<CuratedTrack>? curatedTracks,
    int? totalCachedBytes,
    List<SurahCacheSummary>? cachedSurahSummaries,
    int? downloadingSurahId,
    String? downloadingReciterId,
    bool clearDownloadingSurah = false,
    double? surahDownloadProgress,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HifzHubState(
      status: status ?? this.status,
      activePlan: clearActivePlan ? null : (activePlan ?? this.activePlan),
      allPlans: allPlans ?? this.allPlans,
      dueReviews: dueReviews ?? this.dueReviews,
      dueSurahNamesAr: dueSurahNamesAr ?? this.dueSurahNamesAr,
      dueSurahNamesEn: dueSurahNamesEn ?? this.dueSurahNamesEn,
      dueEstimatedMinutes: dueEstimatedMinutes ?? this.dueEstimatedMinutes,
      streakDays: streakDays ?? this.streakDays,
      curatedTracks: curatedTracks ?? this.curatedTracks,
      totalCachedBytes: totalCachedBytes ?? this.totalCachedBytes,
      cachedSurahSummaries: cachedSurahSummaries ?? this.cachedSurahSummaries,
      downloadingSurahId: clearDownloadingSurah
          ? null
          : (downloadingSurahId ?? this.downloadingSurahId),
      downloadingReciterId: clearDownloadingSurah
          ? null
          : (downloadingReciterId ?? this.downloadingReciterId),
      surahDownloadProgress:
          surahDownloadProgress ?? this.surahDownloadProgress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        activePlan,
        allPlans,
        dueReviews,
        dueSurahNamesAr,
        dueSurahNamesEn,
        dueEstimatedMinutes,
        streakDays,
        curatedTracks,
        totalCachedBytes,
        cachedSurahSummaries,
        downloadingSurahId,
        downloadingReciterId,
        surahDownloadProgress,
        errorMessage,
      ];
}


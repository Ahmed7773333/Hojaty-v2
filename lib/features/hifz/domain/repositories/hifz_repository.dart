import 'package:hojaty/features/hifz/domain/entities/ayah_mastery.dart';
import 'package:hojaty/features/hifz/domain/entities/curated_track.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_plan.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/domain/entities/surah_cache_summary.dart';

/// Persistence and data contract for the Hifz memorization feature.
abstract class HifzRepository {
  Stream<void> get onDataChanged;

  // Curated Tracks
  Future<List<CuratedTrack>> getCuratedTracks();

  // Plans
  Future<HifzPlan?> getActivePlan();
  Future<List<HifzPlan>> getAllPlans();
  Future<HifzPlan> createPlan(HifzPlan plan, {bool setAsActive = true});
  Future<void> setActivePlan(int planId);
  Future<void> updatePlanProgress(int planId, int newCurrentGlobalAyah);
  Future<void> deletePlan(int planId);

  // Mastery / Spaced Repetition
  Future<List<AyahMastery>> getDueReviews({DateTime? asOf});
  Future<void> upsertMastery(AyahMastery mastery);
  Future<void> upsertMasteryBatch(List<AyahMastery> entries);
  Future<AyahMastery?> getMastery(int globalAyahId);

  // Activity & Streaks
  Future<void> logActivity({
    int? planId,
    required String dateYmd,
    int ayahsMemorizedDelta = 0,
    int ayahsReviewedDelta = 0,
    int listeningSecondsDelta = 0,
  });
  Future<int> getStreakDays({DateTime? asOf});

  // Audio Cache Index
  Future<int> getTotalCachedBytes();
  Future<List<SurahCacheSummary>> getCachedSurahSummaries();

  // Session Config Preferences
  Future<HifzSessionConfig> loadSessionConfig();
  Future<void> saveSessionConfig(HifzSessionConfig config);
}


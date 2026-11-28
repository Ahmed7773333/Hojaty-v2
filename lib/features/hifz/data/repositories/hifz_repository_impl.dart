import 'package:hojaty/features/hifz/data/datasources/curated_tracks_loader.dart';
import 'package:hojaty/features/hifz/data/datasources/hifz_local_dao.dart';
import 'package:hojaty/features/hifz/domain/entities/ayah_mastery.dart';
import 'package:hojaty/features/hifz/domain/entities/curated_track.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_plan.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/domain/entities/surah_cache_summary.dart';
import 'package:hojaty/features/hifz/domain/repositories/hifz_repository.dart';

class HifzRepositoryImpl implements HifzRepository {
  final HifzLocalDao localDao;
  final CuratedTracksLoader curatedTracksLoader;

  const HifzRepositoryImpl({
    required this.localDao,
    required this.curatedTracksLoader,
  });

  @override
  Stream<void> get onDataChanged => localDao.onDataChanged;

  @override
  Future<List<CuratedTrack>> getCuratedTracks() =>
      curatedTracksLoader.loadTracks();

  @override
  Future<HifzPlan?> getActivePlan() => localDao.getActivePlan();

  @override
  Future<List<HifzPlan>> getAllPlans() => localDao.getAllPlans();

  @override
  Future<HifzPlan> createPlan(HifzPlan plan, {bool setAsActive = true}) =>
      localDao.createPlan(plan, setAsActive: setAsActive);

  @override
  Future<void> setActivePlan(int planId) => localDao.setActivePlan(planId);

  @override
  Future<void> updatePlanProgress(int planId, int newCurrentGlobalAyah) =>
      localDao.updatePlanProgress(planId, newCurrentGlobalAyah);

  @override
  Future<void> deletePlan(int planId) => localDao.deletePlan(planId);

  @override
  Future<List<AyahMastery>> getDueReviews({DateTime? asOf}) =>
      localDao.getDueReviews(asOf: asOf);

  @override
  Future<AyahMastery?> getMastery(int globalAyahId) =>
      localDao.getMastery(globalAyahId);

  @override
  Future<void> upsertMastery(AyahMastery mastery) =>
      localDao.upsertMastery(mastery);

  @override
  Future<void> upsertMasteryBatch(List<AyahMastery> entries) =>
      localDao.upsertMasteryBatch(entries);

  @override
  Future<void> logActivity({
    int? planId,
    required String dateYmd,
    int ayahsMemorizedDelta = 0,
    int ayahsReviewedDelta = 0,
    int listeningSecondsDelta = 0,
  }) =>
      localDao.logActivity(
        planId: planId,
        dateYmd: dateYmd,
        ayahsMemorizedDelta: ayahsMemorizedDelta,
        ayahsReviewedDelta: ayahsReviewedDelta,
        listeningSecondsDelta: listeningSecondsDelta,
      );

  @override
  Future<int> getStreakDays({DateTime? asOf}) =>
      localDao.getStreakDays(asOf: asOf);

  @override
  Future<int> getTotalCachedBytes() => localDao.getTotalCachedBytes();

  @override
  Future<List<SurahCacheSummary>> getCachedSurahSummaries() =>
      localDao.getCachedSurahSummaries();

  @override
  Future<HifzSessionConfig> loadSessionConfig() => localDao.loadSessionConfig();

  @override
  Future<void> saveSessionConfig(HifzSessionConfig config) =>
      localDao.saveSessionConfig(config);
}


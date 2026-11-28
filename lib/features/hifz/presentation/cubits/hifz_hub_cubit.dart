import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/features/hifz/data/datasources/audio_cache_manager.dart';
import 'package:hojaty/features/hifz/data/datasources/hifz_local_dao.dart';
import 'package:hojaty/features/hifz/domain/entities/curated_track.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_plan.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:hojaty/features/hifz/domain/repositories/hifz_repository.dart';
import 'package:hojaty/features/hifz/domain/usecases/calculate_spaced_review.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_hub_state.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';

class HifzHubCubit extends Cubit<HifzHubState> {
  final HifzRepository repository;
  final AudioCacheManager cacheManager;
  final CalculateSpacedReview calculateSpacedReview;

  StreamSubscription<void>? _dataChangedSub;
  CancelToken? _surahDownloadCancel;

  HifzHubCubit({
    required this.repository,
    required this.cacheManager,
    required this.calculateSpacedReview,
  }) : super(const HifzHubState()) {
    _dataChangedSub = repository.onDataChanged.listen((_) {
      unawaited(refresh());
    });
  }

  Future<void> load() async {
    emit(state.copyWith(status: HifzHubStatus.loading, clearError: true));
    await refresh();
  }

  Future<void> refresh() async {
    try {
      final results = await Future.wait([
        repository.getActivePlan(),
        repository.getAllPlans(),
        repository.getDueReviews(),
        repository.getStreakDays(),
        repository.getCuratedTracks(),
        repository.getTotalCachedBytes(),
        repository.getCachedSurahSummaries(),
      ]);

      if (isClosed) return;

      final activePlan = results[0] as HifzPlan?;
      final allPlans = results[1] as List<HifzPlan>;
      final dueReviews = results[2] as List<dynamic>;
      final typedDue = dueReviews.cast<dynamic>().isEmpty
          ? state.dueReviews.take(0).toList()
          : await repository.getDueReviews();

      final surahNamesAr = <String>[];
      final surahNamesEn = <String>[];
      final seenSurahs = <int>{};
      for (final item in typedDue) {
        final mapped = GlobalAyahMapper.fromGlobalAyahId(item.globalAyahId);
        if (seenSurahs.add(mapped.surah)) {
          final info = QuranConstants.surahMap[mapped.surah];
          if (info != null) {
            surahNamesAr.add(info.name);
            surahNamesEn.add(info.englishName);
          }
        }
      }

      final estimatedMinutes =
          typedDue.isEmpty ? 0 : (typedDue.length * 0.4).ceil().clamp(1, 60);

      emit(
        state.copyWith(
          status: HifzHubStatus.success,
          activePlan: activePlan,
          clearActivePlan: activePlan == null,
          allPlans: allPlans,
          dueReviews: typedDue,
          dueSurahNamesAr: surahNamesAr,
          dueSurahNamesEn: surahNamesEn,
          dueEstimatedMinutes: estimatedMinutes,
          streakDays: results[3] as int,
          curatedTracks: results[4] as List<CuratedTrack>,
          totalCachedBytes: results[5] as int,
          cachedSurahSummaries: (results[6] as List).cast(),
          clearError: true,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: HifzHubStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<HifzPlan> startCuratedTrack(
    CuratedTrack track, {
    required bool isArabic,
  }) async {
    final plan = HifzPlan(
      trackKey: track.trackKey,
      title: track.localizedTitle(isArabic),
      surahId: track.surahId,
      startGlobalAyah: track.startGlobalAyah,
      endGlobalAyah: track.endGlobalAyah,
      currentGlobalAyah: track.startGlobalAyah,
      dailyTargetAyahs: track.dailyTargetAyahs,
      isActive: true,
      createdAt: DateTime.now(),
    );
    final created = await repository.createPlan(plan);
    await refresh();
    return created;
  }

  Future<HifzPlan> createCustomPlan({
    required String title,
    required int surahId,
    required int startGlobalAyah,
    required int endGlobalAyah,
    required int dailyTargetAyahs,
  }) async {
    final plan = HifzPlan(
      title: title,
      surahId: surahId,
      startGlobalAyah: startGlobalAyah,
      endGlobalAyah: endGlobalAyah,
      currentGlobalAyah: startGlobalAyah,
      dailyTargetAyahs: dailyTargetAyahs,
      isActive: true,
      createdAt: DateTime.now(),
    );
    final created = await repository.createPlan(plan);
    await refresh();
    return created;
  }

  Future<void> switchActivePlan(int planId) async {
    await repository.setActivePlan(planId);
    await refresh();
  }

  Future<void> deletePlan(int planId) async {
    await repository.deletePlan(planId);
    await refresh();
  }

  Future<void> completeTodayWird({
    int? planId,
    required int startGlobalAyah,
    required int endGlobalAyah,
  }) async {
    final now = DateTime.now();
    final ayahsCount = (endGlobalAyah - startGlobalAyah + 1).clamp(1, 6236);
    final masteryEntries = [
      for (int g = startGlobalAyah; g <= endGlobalAyah; g++)
        calculateSpacedReview.createInitial(globalAyahId: g, now: now),
    ];

    await repository.upsertMasteryBatch(masteryEntries);
    await repository.logActivity(
      planId: planId,
      dateYmd: HifzLocalDao.formatYmd(now),
      ayahsMemorizedDelta: ayahsCount,
    );

    if (planId != null) {
      final active = state.activePlan;
      if (active != null && active.id == planId) {
        final nextCurrent = (endGlobalAyah + 1).clamp(
          active.startGlobalAyah,
          active.endGlobalAyah + 1,
        );
        await repository.updatePlanProgress(planId, nextCurrent);
      }
    }

    await refresh();
  }

  Future<void> recordReviewResult(int globalAyahId, bool recalled) async {
    final now = DateTime.now();
    final existing = await repository.getMastery(globalAyahId);
    final updated = calculateSpacedReview(
      existing: existing,
      globalAyahId: globalAyahId,
      recalled: recalled,
      now: now,
    );
    await repository.upsertMastery(updated);
    await repository.logActivity(
      planId: state.activePlan?.id,
      dateYmd: HifzLocalDao.formatYmd(now),
      ayahsReviewedDelta: 1,
    );
    await refresh();
  }

  Future<void> downloadSurahForOffline({
    required Reciter reciter,
    required int surahId,
    required AudioQuality quality,
  }) async {
    _surahDownloadCancel?.cancel();
    final cancelToken = CancelToken();
    _surahDownloadCancel = cancelToken;

    emit(
      state.copyWith(
        downloadingSurahId: surahId,
        downloadingReciterId: reciter.id,
        surahDownloadProgress: 0.0,
        clearError: true,
      ),
    );

    try {
      await cacheManager.downloadSurah(
        reciter: reciter,
        surahId: surahId,
        quality: quality,
        cancelToken: cancelToken,
        onProgress: (completed, total) {
          if (isClosed) return;
          final progress = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;
          emit(state.copyWith(surahDownloadProgress: progress));
        },
      );
    } on DioException catch (e) {
      if (!CancelToken.isCancel(e) && !isClosed) {
        emit(state.copyWith(errorMessage: e.message ?? 'Download failed'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            clearDownloadingSurah: true,
            surahDownloadProgress: 0.0,
          ),
        );
        await refresh();
      }
    }
  }

  void cancelSurahDownload() {
    _surahDownloadCancel?.cancel();
    _surahDownloadCancel = null;
    emit(
      state.copyWith(
        clearDownloadingSurah: true,
        surahDownloadProgress: 0.0,
      ),
    );
  }

  Future<void> clearTemporaryCache() async {
    await cacheManager.clearUnpinnedCache();
    await refresh();
  }

  Future<void> deleteSurahCache(String reciterId, int surahId) async {
    await cacheManager.deleteSurahCache(reciterId, surahId);
    await refresh();
  }

  @override
  Future<void> close() {
    _dataChangedSub?.cancel();
    _surahDownloadCancel?.cancel();
    return super.close();
  }
}


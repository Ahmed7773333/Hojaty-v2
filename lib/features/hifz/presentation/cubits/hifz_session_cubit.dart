import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/features/hifz/data/datasources/audio_cache_manager.dart';
import 'package:hojaty/features/hifz/data/datasources/hifz_local_dao.dart';
import 'package:hojaty/features/hifz/data/datasources/hifz_quran_text_resolver.dart';
import 'package:hojaty/features/hifz/data/models/reciter_registry.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_step.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:hojaty/features/hifz/domain/repositories/hifz_repository.dart';
import 'package:hojaty/features/hifz/domain/usecases/calculate_spaced_review.dart';
import 'package:hojaty/features/hifz/domain/usecases/generate_playback_queue.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';
import 'package:hojaty/features/hifz/engine/hifz_platform_channel.dart';
import 'package:hojaty/features/hifz/engine/hifz_session_orchestrator.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_state.dart';

class HifzSessionCubit extends Cubit<HifzSessionState> {
  final HifzRepository repository;
  final HifzQuranTextResolver textResolver;
  final AudioCacheManager cacheManager;
  final GeneratePlaybackQueue generatePlaybackQueue;
  final CalculateSpacedReview calculateSpacedReview;
  final HifzSessionOrchestrator orchestrator;

  bool _prefsLoaded = false;
  bool _isArabic = true;

  HifzSessionCubit({
    required this.repository,
    required this.textResolver,
    required this.cacheManager,
    required this.generatePlaybackQueue,
    required this.calculateSpacedReview,
    required this.orchestrator,
  }) : super(const HifzSessionState()) {
    _bindOrchestratorCallbacks();
    unawaited(_loadPreferences());
  }

  ValueListenable<Duration> get pauseRemainingListenable =>
      orchestrator.pauseRemainingNotifier;
  ValueListenable<Duration> get pauseTotalListenable =>
      orchestrator.pauseTotalNotifier;

  void _bindOrchestratorCallbacks() {
    orchestrator.onStepChanged = (stepIndex) {
      if (isClosed) return;
      emit(
        state.copyWith(
          phase: SessionPhase.playing,
          currentStepIndex: stepIndex,
          clearOfflineBlockedAyah: true,
          clearError: true,
        ),
      );
      _syncWakelock();
    };

    orchestrator.onSilencePauseChanged = (isPausing) {
      if (isClosed) return;
      emit(
        state.copyWith(
          phase: isPausing
              ? SessionPhase.pausingForRepeat
              : SessionPhase.playing,
        ),
      );
      _syncWakelock();
    };

    orchestrator.onCacheStatusChanged = (globalAyahId, status) {
      if (isClosed) return;
      final updated = Map<int, AudioCacheStatus>.from(state.ayahCacheMap);
      updated[globalAyahId] = status;
      emit(state.copyWith(ayahCacheMap: updated));
    };

    orchestrator.onOfflineBlocked = (globalAyahId) {
      if (isClosed) return;
      emit(
        state.copyWith(
          phase: SessionPhase.offlineBlocked,
          offlineBlockedAyah: globalAyahId,
        ),
      );
      _syncWakelock();
    };

    orchestrator.onQueueCompleted = () {
      if (isClosed) return;
      emit(state.copyWith(phase: SessionPhase.pausedByUser));
      _syncWakelock();
    };

    orchestrator.onError = (message) {
      if (isClosed) return;
      emit(
        state.copyWith(
          phase: SessionPhase.error,
          errorMessage: message,
        ),
      );
      _syncWakelock();
    };

    orchestrator.onListeningSecondTick = (seconds) {
      unawaited(
        repository.logActivity(
          planId: state.planId,
          dateYmd: HifzLocalDao.formatYmd(DateTime.now()),
          listeningSecondsDelta: seconds,
        ),
      );
    };
  }

  Future<void> _loadPreferences() async {
    if (_prefsLoaded) return;
    _prefsLoaded = true;
    try {
      final config = await repository.loadSessionConfig();
      if (isClosed) return;
      final reciter = ReciterRegistry.byId(config.reciterId);
      emit(
        state.copyWith(
          reciter: reciter,
          audioQuality: config.audioQuality,
          ayahRepeatCount: config.ayahRepeatCount,
          rangeRepeatCount: config.rangeRepeatCount,
          cumulativeChaining: config.cumulativeChaining,
          pauseToRepeat: config.pauseToRepeat,
          pauseMode: config.pauseMode,
          fixedPauseSeconds: config.fixedPauseSeconds,
          playbackSpeed: config.playbackSpeed,
        ),
      );
    } catch (_) {
      // Fall back to defaults safely.
    }
  }

  Future<void> _persistConfig() async {
    await repository.saveSessionConfig(
      HifzSessionConfig(
        reciterId: state.reciter.id,
        audioQuality: state.audioQuality,
        ayahRepeatCount: state.ayahRepeatCount,
        rangeRepeatCount: state.rangeRepeatCount,
        cumulativeChaining: state.cumulativeChaining,
        pauseToRepeat: state.pauseToRepeat,
        pauseMode: state.pauseMode,
        fixedPauseSeconds: state.fixedPauseSeconds,
        playbackSpeed: state.playbackSpeed,
      ),
    );
  }

  void _syncWakelock() {
    final shouldKeepAwake =
        state.phase == SessionPhase.playing ||
        state.phase == SessionPhase.pausingForRepeat;
    unawaited(HifzPlatformChannel.setWakelock(shouldKeepAwake));
  }

  void _syncOrchestratorConfig() {
    orchestrator.configure(
      reciter: state.reciter,
      quality: state.audioQuality,
      speed: state.playbackSpeed,
      pauseToRepeat: state.pauseToRepeat,
      pauseMode: state.pauseMode,
      fixedPauseSeconds: state.fixedPauseSeconds,
      isArabic: _isArabic,
    );
  }

  /// Launches a Hifz memorization or review session for [startGlobalAyah]..[endGlobalAyah].
  Future<void> startSession({
    required int startGlobalAyah,
    required int endGlobalAyah,
    int? planId,
    bool isReviewSession = false,
    bool startInTestingMode = false,
    bool autoPlay = true,
    bool isArabic = true,
  }) async {
    _isArabic = isArabic;
    await _loadPreferences();
    await orchestrator.stop();

    final ids = <int>[
      for (int g = startGlobalAyah; g <= endGlobalAyah; g++) g,
    ];
    final contents = await textResolver.resolveAyahs(ids);
    final cacheMap = await cacheManager.getCacheStatuses(state.reciter, ids);

    final queue = generatePlaybackQueue(
      startGlobalAyah: startGlobalAyah,
      endGlobalAyah: endGlobalAyah,
      ayahRepeatCount: state.ayahRepeatCount,
      rangeRepeatCount: state.rangeRepeatCount,
      cumulativeChaining: state.cumulativeChaining,
    );

    if (isClosed) return;

    emit(
      state.copyWith(
        phase: startInTestingMode
            ? SessionPhase.testingMode
            : (autoPlay ? SessionPhase.preparingAudio : SessionPhase.pausedByUser),
        queue: queue,
        currentStepIndex: 0,
        rangeStartGlobalAyah: startGlobalAyah,
        rangeEndGlobalAyah: endGlobalAyah,
        planId: planId,
        clearPlanId: planId == null,
        isReviewSession: isReviewSession,
        ayahContents: contents,
        ayahCacheMap: cacheMap,
        revealedAyahs: const {},
        hintedAyahs: const {},
        masteredAyahs: const {},
        needsReviewAyahs: const {},
        clearOfflineBlockedAyah: true,
        clearError: true,
        isMinimized: false,
      ),
    );

    _syncOrchestratorConfig();

    if (!startInTestingMode && autoPlay && queue.isNotEmpty) {
      await orchestrator.startQueue(queue: queue);
    }
  }

  void setViewMode(ViewMode mode) {
    emit(state.copyWith(viewMode: mode));
  }

  Future<void> togglePlayPause() async {
    if (state.phase == SessionPhase.playing ||
        state.phase == SessionPhase.pausingForRepeat) {
      await orchestrator.pause();
      emit(state.copyWith(phase: SessionPhase.pausedByUser));
      _syncWakelock();
      return;
    }

    if (state.queue.isEmpty) return;
    _syncOrchestratorConfig();

    if (state.phase == SessionPhase.pausedByUser &&
        state.currentStepIndex > 0) {
      emit(state.copyWith(phase: SessionPhase.playing));
      await orchestrator.resume();
      if (!orchestrator.audioHandler.isPlaying) {
        await orchestrator.jumpToStep(state.currentStepIndex);
      }
    } else {
      emit(state.copyWith(phase: SessionPhase.preparingAudio));
      await orchestrator.startQueue(
        queue: state.queue,
        startIndex: state.currentStepIndex,
      );
    }
    _syncWakelock();
  }

  Future<void> skipPause() async {
    await orchestrator.skipPause();
  }

  Future<void> nextAyah() async {
    await orchestrator.nextAyah();
  }

  Future<void> previousAyah() async {
    await orchestrator.previousAyah();
  }

  Future<void> selectAyah(int globalAyahId) async {
    if (state.phase == SessionPhase.testingMode) {
      revealAyah(globalAyahId);
      return;
    }
    final idx = state.queue.indexWhere(
      (s) => s.globalAyahId == globalAyahId && s.stepType != StepType.basmalah,
    );
    if (idx != -1) {
      await orchestrator.jumpToStep(idx);
    }
  }

  void _rebuildQueueAndSnap() {
    if (state.ayahContents.isEmpty) return;
    final currentAyah = state.activeGlobalAyahId;
    final currentType = state.currentStep?.stepType;

    final newQueue = generatePlaybackQueue(
      startGlobalAyah: state.rangeStartGlobalAyah,
      endGlobalAyah: state.rangeEndGlobalAyah,
      ayahRepeatCount: state.ayahRepeatCount,
      rangeRepeatCount: state.rangeRepeatCount,
      cumulativeChaining: state.cumulativeChaining,
    );

    final snappedIndex = generatePlaybackQueue.snapStepIndex(
      newQueue: newQueue,
      currentGlobalAyahId: currentAyah,
      preferredType: currentType,
    );

    orchestrator.updateQueueLive(
      newQueue: newQueue,
      snappedIndex: snappedIndex,
    );

    emit(
      state.copyWith(
        queue: newQueue,
        currentStepIndex: snappedIndex,
      ),
    );
  }

  Future<void> setAyahRepeatCount(int count) async {
    emit(state.copyWith(ayahRepeatCount: count));
    _rebuildQueueAndSnap();
    await _persistConfig();
  }

  Future<void> setRangeRepeatCount(int count) async {
    emit(state.copyWith(rangeRepeatCount: count.clamp(1, 50)));
    _rebuildQueueAndSnap();
    await _persistConfig();
  }

  Future<void> toggleCumulativeChaining() async {
    emit(state.copyWith(cumulativeChaining: !state.cumulativeChaining));
    _rebuildQueueAndSnap();
    await _persistConfig();
  }

  Future<void> togglePauseToRepeat() async {
    emit(state.copyWith(pauseToRepeat: !state.pauseToRepeat));
    _syncOrchestratorConfig();
    await _persistConfig();
  }

  Future<void> setPauseMode(PauseMode mode) async {
    emit(state.copyWith(pauseMode: mode));
    _syncOrchestratorConfig();
    await _persistConfig();
  }

  Future<void> setFixedPauseSeconds(int seconds) async {
    emit(state.copyWith(fixedPauseSeconds: seconds.clamp(2, 25)));
    _syncOrchestratorConfig();
    await _persistConfig();
  }

  Future<void> cyclePlaybackSpeed() async {
    final nextSpeed = switch (state.playbackSpeed) {
      < 0.9 => 1.0,
      < 1.15 => 1.25,
      _ => 0.75,
    };
    emit(state.copyWith(playbackSpeed: nextSpeed));
    _syncOrchestratorConfig();
    await _persistConfig();
  }

  Future<void> setReciter(Reciter reciter) async {
    final ids = state.ayahContents.map((e) => e.globalAyahId).toList();
    final cacheMap = await cacheManager.getCacheStatuses(reciter, ids);
    if (isClosed) return;
    emit(state.copyWith(reciter: reciter, ayahCacheMap: cacheMap));
    _syncOrchestratorConfig();
    await _persistConfig();
    if (state.isAudioActive) {
      await orchestrator.jumpToStep(state.currentStepIndex);
    }
  }

  Future<void> setAudioQuality(AudioQuality quality) async {
    emit(state.copyWith(audioQuality: quality));
    _syncOrchestratorConfig();
    await _persistConfig();
  }

  Future<void> toggleTestingMode() async {
    if (state.phase == SessionPhase.testingMode) {
      emit(
        state.copyWith(
          phase: SessionPhase.pausedByUser,
          revealedAyahs: const {},
          hintedAyahs: const {},
        ),
      );
    } else {
      await orchestrator.pause();
      emit(
        state.copyWith(
          phase: SessionPhase.testingMode,
          revealedAyahs: const {},
          hintedAyahs: const {},
          clearOfflineBlockedAyah: true,
        ),
      );
    }
    _syncWakelock();
  }

  Future<void> switchToSilentTestingFromOffline() async {
    await orchestrator.stop();
    emit(
      state.copyWith(
        phase: SessionPhase.testingMode,
        revealedAyahs: const {},
        hintedAyahs: const {},
        clearOfflineBlockedAyah: true,
      ),
    );
    _syncWakelock();
  }

  void revealAyah(int globalAyahId) {
    final updated = Set<int>.from(state.revealedAyahs)..add(globalAyahId);
    emit(state.copyWith(revealedAyahs: updated));
  }

  void revealFirstWordsHint(int globalAyahId) {
    final updated = Set<int>.from(state.hintedAyahs)..add(globalAyahId);
    emit(state.copyWith(hintedAyahs: updated));
  }

  Future<void> playAudioHint(int globalAyahId) async {
    final mapped = GlobalAyahMapper.fromGlobalAyahId(globalAyahId);
    _syncOrchestratorConfig();
    await orchestrator.playFirstTwoSecondsHint(
      surah: mapped.surah,
      ayah: mapped.ayah,
      globalAyahId: globalAyahId,
    );
  }

  Future<void> markAyahResult(
    int globalAyahId, {
    required bool mastered,
  }) async {
    final masteredSet = Set<int>.from(state.masteredAyahs);
    final reviewSet = Set<int>.from(state.needsReviewAyahs);
    if (mastered) {
      masteredSet.add(globalAyahId);
      reviewSet.remove(globalAyahId);
    } else {
      reviewSet.add(globalAyahId);
      masteredSet.remove(globalAyahId);
    }
    emit(
      state.copyWith(
        masteredAyahs: masteredSet,
        needsReviewAyahs: reviewSet,
      ),
    );

    final now = DateTime.now();
    final existing = await repository.getMastery(globalAyahId);
    final updated = calculateSpacedReview(
      existing: existing,
      globalAyahId: globalAyahId,
      recalled: mastered,
      now: now,
    );
    await repository.upsertMastery(updated);
    await repository.logActivity(
      planId: state.planId,
      dateYmd: HifzLocalDao.formatYmd(now),
      ayahsReviewedDelta: 1,
    );
  }

  Future<void> markWirdCompleted() async {
    await orchestrator.stop();
    emit(state.copyWith(phase: SessionPhase.completed));
    _syncWakelock();
  }

  void minimizeSession() {
    emit(state.copyWith(isMinimized: true));
  }

  void restoreSession() {
    emit(state.copyWith(isMinimized: false));
  }

  Future<void> stopSession() async {
    await orchestrator.stop();
    emit(
      state.copyWith(
        phase: SessionPhase.idle,
        queue: const [],
        ayahContents: const [],
        currentStepIndex: 0,
        isMinimized: false,
        clearOfflineBlockedAyah: true,
        clearError: true,
      ),
    );
    _syncWakelock();
  }

  @override
  Future<void> close() async {
    unawaited(HifzPlatformChannel.setWakelock(false));
    await orchestrator.dispose();
    return super.close();
  }
}


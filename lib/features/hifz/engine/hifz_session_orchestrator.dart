import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hojaty/core/utils/app_audio_art_helper.dart';
import 'package:hojaty/features/hifz/data/datasources/audio_cache_manager.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_step.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:hojaty/features/hifz/engine/hifz_audio_handler.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// Step-by-step execution driver for Hifz playback, Pause-to-Repeat silence,
/// sliding-window pre-fetching, and graceful offline handling.
class HifzSessionOrchestrator {
  final HifzAudioHandler audioHandler;
  final AudioCacheManager cacheManager;

  /// High-frequency countdown notifiers for 60/120 FPS UI updates without rebuilding root state.
  final ValueNotifier<Duration> pauseRemainingNotifier =
      ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<Duration> pauseTotalNotifier =
      ValueNotifier<Duration>(Duration.zero);

  List<HifzStep> _queue = const [];
  int _currentStepIndex = 0;
  Reciter? _reciter;
  AudioQuality _quality = AudioQuality.kbps128;
  double _speed = 1.0;
  bool _pauseToRepeat = false;
  PauseMode _pauseMode = PauseMode.dynamicDuration;
  int _fixedPauseSeconds = 5;
  bool _isArabic = true;

  bool _isPausedByUser = false;
  bool _isInSilencePause = false;
  bool _isHintPlayback = false;
  Duration _lastAyahDuration = const Duration(seconds: 4);
  Duration _activeSilenceTotal = Duration.zero;
  int _executionToken = 0;
  CancelToken? _activeDownloadCancel;

  StreamSubscription<ProcessingState>? _processingSub;
  StreamSubscription<Duration>? _positionSub;

  void Function(int stepIndex)? onStepChanged;
  void Function(bool isPausingForRepeat)? onSilencePauseChanged;
  void Function(int globalAyahId, AudioCacheStatus status)? onCacheStatusChanged;
  void Function(int globalAyahId)? onOfflineBlocked;
  void Function()? onQueueCompleted;
  void Function(String message)? onError;
  void Function(int seconds)? onListeningSecondTick;

  DateTime? _lastListeningTick;

  HifzSessionOrchestrator({
    required this.audioHandler,
    required this.cacheManager,
  }) {
    _processingSub = audioHandler.processingStateStream.listen(
      _onProcessingStateChanged,
    );
    _positionSub = audioHandler.positionStream.listen(_onPositionChanged);
    audioHandler.onPauseRequested = () {
      unawaited(pause());
    };
    audioHandler.onResumeRequested = () {
      unawaited(resume());
    };
  }

  void configure({
    required Reciter reciter,
    required AudioQuality quality,
    required double speed,
    required bool pauseToRepeat,
    required PauseMode pauseMode,
    required int fixedPauseSeconds,
    required bool isArabic,
  }) {
    _reciter = reciter;
    _quality = quality;
    _speed = speed;
    _pauseToRepeat = pauseToRepeat;
    _pauseMode = pauseMode;
    _fixedPauseSeconds = fixedPauseSeconds;
    _isArabic = isArabic;
    if (!_isInSilencePause) {
      unawaited(audioHandler.setSpeed(speed));
    }
  }

  Future<void> startQueue({
    required List<HifzStep> queue,
    int startIndex = 0,
  }) async {
    _queue = queue;
    _currentStepIndex = startIndex.clamp(0, queue.isEmpty ? 0 : queue.length - 1);
    _isPausedByUser = false;
    _isInSilencePause = false;
    _isHintPlayback = false;
    await _playCurrentStep();
  }

  void updateQueueLive({
    required List<HifzStep> newQueue,
    required int snappedIndex,
  }) {
    _queue = newQueue;
    _currentStepIndex =
        snappedIndex.clamp(0, newQueue.isEmpty ? 0 : newQueue.length - 1);
  }

  Future<void> jumpToStep(int stepIndex) async {
    if (_queue.isEmpty) return;
    _currentStepIndex = stepIndex.clamp(0, _queue.length - 1);
    _isPausedByUser = false;
    _isInSilencePause = false;
    _isHintPlayback = false;
    await _playCurrentStep();
  }

  Future<void> skipPause() async {
    if (!_isInSilencePause) return;
    _isInSilencePause = false;
    pauseRemainingNotifier.value = Duration.zero;
    onSilencePauseChanged?.call(false);
    await _advanceAfterStep();
  }

  Future<void> nextAyah() async {
    if (_queue.isEmpty) return;
    final currentGlobal = _queue[_currentStepIndex].globalAyahId;
    final nextIdx = _queue.indexWhere(
      (s) => s.globalAyahId != currentGlobal && s.stepType != StepType.basmalah,
      _currentStepIndex + 1,
    );
    if (nextIdx != -1) {
      await jumpToStep(nextIdx);
    } else if (_currentStepIndex + 1 < _queue.length) {
      await jumpToStep(_currentStepIndex + 1);
    }
  }

  Future<void> previousAyah() async {
    if (_queue.isEmpty) return;
    final currentGlobal = _queue[_currentStepIndex].globalAyahId;
    int prevIdx = -1;
    for (int i = _currentStepIndex - 1; i >= 0; i--) {
      if (_queue[i].globalAyahId != currentGlobal) {
        prevIdx = i;
        break;
      }
    }
    if (prevIdx != -1) {
      final targetGlobal = _queue[prevIdx].globalAyahId;
      while (prevIdx > 0 && _queue[prevIdx - 1].globalAyahId == targetGlobal) {
        prevIdx--;
      }
      await jumpToStep(prevIdx);
    } else {
      await jumpToStep(0);
    }
  }

  Future<void> pause() async {
    _isPausedByUser = true;
    await audioHandler.pause();
  }

  Future<void> resume() async {
    _isPausedByUser = false;
    if (audioHandler.isPlaying) return;
    if (_queue.isNotEmpty) {
      await audioHandler.resume();
    }
  }

  Future<void> stop() async {
    _executionToken++;
    _activeDownloadCancel?.cancel();
    _activeDownloadCancel = null;
    _isPausedByUser = false;
    _isInSilencePause = false;
    _isHintPlayback = false;
    pauseRemainingNotifier.value = Duration.zero;
    await audioHandler.stop();
  }

  /// Plays the first 2 seconds of an ayah as a gentle memorization hint.
  Future<void> playFirstTwoSecondsHint({
    required int surah,
    required int ayah,
    required int globalAyahId,
  }) async {
    final reciter = _reciter;
    if (reciter == null) return;
    _executionToken++;
    final token = _executionToken;
    _isHintPlayback = true;
    _isInSilencePause = false;

    try {
      final path = await cacheManager.getOrDownload(
        reciter: reciter,
        surah: surah,
        ayah: ayah,
        quality: _quality,
      );
      if (token != _executionToken) return;
      final surahName = QuranConstants.surahMap[surah]?.name ?? '';
      await audioHandler.playLocalAyah(
        filePath: path,
        speed: 1.0,
        clipEnd: const Duration(seconds: 2),
        mediaItem: MediaItem(
          id: 'hifz_hint_$globalAyahId',
          title: 'سورة $surahName — آية $ayah',
          artist: '${reciter.localizedName(_isArabic)} • حِفظي',
          album: 'حِفظي',
          artUri: AppAudioArtHelper.logoUri,
        ),
      );
    } catch (_) {
      onOfflineBlocked?.call(globalAyahId);
    }
  }

  Future<void> _playCurrentStep() async {
    if (_queue.isEmpty || _reciter == null) return;
    if (_currentStepIndex < 0 || _currentStepIndex >= _queue.length) {
      onQueueCompleted?.call();
      return;
    }

    _executionToken++;
    final token = _executionToken;
    _isInSilencePause = false;
    _isHintPlayback = false;

    final step = _queue[_currentStepIndex];
    final reciter = _reciter!;

    // Emit UI step update BEFORE starting audio so highlights stay synchronized.
    onStepChanged?.call(_currentStepIndex);
    onCacheStatusChanged?.call(step.globalAyahId, AudioCacheStatus.downloading);

    _activeDownloadCancel?.cancel();
    final cancelToken = CancelToken();
    _activeDownloadCancel = cancelToken;

    try {
      final filePath = await cacheManager.getOrDownload(
        reciter: reciter,
        surah: step.surah,
        ayah: step.ayah,
        quality: _quality,
        cancelToken: cancelToken,
      );
      if (token != _executionToken || _isPausedByUser) return;

      onCacheStatusChanged?.call(step.globalAyahId, AudioCacheStatus.cached);

      // Sliding-window prefetch for next 3 unique ayahs.
      final upcomingIds = <int>[];
      for (int i = _currentStepIndex + 1; i < _queue.length; i++) {
        final gid = _queue[i].globalAyahId;
        if (gid != step.globalAyahId && !upcomingIds.contains(gid)) {
          upcomingIds.add(gid);
          if (upcomingIds.length >= 3) break;
        }
      }
      unawaited(
        cacheManager.prefetchWindow(
          reciter: reciter,
          globalAyahIds: upcomingIds,
          quality: _quality,
        ),
      );

      final surahName = QuranConstants.surahMap[step.surah]?.name ?? '';
      final repeatLabel = step.isInfinity
          ? '∞'
          : '${step.repeatIndex}/${step.totalRepeats}';
      final title = step.stepType == StepType.basmalah
          ? 'بسم الله الرحمن الرحيم'
          : 'سورة $surahName — آية ${step.ayah} (تكرار $repeatLabel)';

      await audioHandler.playLocalAyah(
        filePath: filePath,
        speed: _speed,
        mediaItem: MediaItem(
          id: 'hifz_${reciter.id}_${step.globalAyahId}_${step.repeatIndex}',
          title: title,
          artist: '${reciter.localizedName(_isArabic)} • حِفظي',
          album: 'حِفظي',
          artUri: AppAudioArtHelper.logoUri,
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e) || token != _executionToken) return;
      onCacheStatusChanged?.call(step.globalAyahId, AudioCacheStatus.failed);
      onOfflineBlocked?.call(step.globalAyahId);
    } catch (e) {
      if (token != _executionToken) return;
      onCacheStatusChanged?.call(step.globalAyahId, AudioCacheStatus.failed);
      onError?.call(e.toString());
    }
  }

  void _onPositionChanged(Duration position) {
    if (_isInSilencePause) {
      final remaining = _activeSilenceTotal - position;
      pauseRemainingNotifier.value =
          remaining.isNegative ? Duration.zero : remaining;
      return;
    }

    if (audioHandler.isPlaying && !_isHintPlayback) {
      final now = DateTime.now();
      if (_lastListeningTick == null ||
          now.difference(_lastListeningTick!).inSeconds >= 5) {
        if (_lastListeningTick != null) {
          onListeningSecondTick?.call(5);
        }
        _lastListeningTick = now;
      }
    }
  }

  void _onProcessingStateChanged(ProcessingState state) {
    if (state != ProcessingState.completed) return;
    if (_isPausedByUser) return;

    if (_isHintPlayback) {
      _isHintPlayback = false;
      unawaited(audioHandler.stop());
      return;
    }

    if (_isInSilencePause) {
      _isInSilencePause = false;
      pauseRemainingNotifier.value = Duration.zero;
      onSilencePauseChanged?.call(false);
      unawaited(_advanceAfterStep());
      return;
    }

    if (_queue.isEmpty || _currentStepIndex >= _queue.length) return;
    final step = _queue[_currentStepIndex];
    final measured = audioHandler.currentDuration;
    if (measured != null && measured > Duration.zero) {
      _lastAyahDuration = measured;
    }

    if (_pauseToRepeat && step.stepType != StepType.basmalah) {
      unawaited(_enterSilencePause(step));
    } else {
      unawaited(_advanceAfterStep());
    }
  }

  Future<void> _enterSilencePause(HifzStep step) async {
    final Duration pauseDuration;
    if (_pauseMode == PauseMode.fixed) {
      pauseDuration = Duration(seconds: _fixedPauseSeconds.clamp(2, 25));
    } else {
      final computedMs =
          (_lastAyahDuration.inMilliseconds * 1.15).round().clamp(3000, 20000);
      pauseDuration = Duration(milliseconds: computedMs);
    }

    _isInSilencePause = true;
    _activeSilenceTotal = pauseDuration;
    pauseTotalNotifier.value = pauseDuration;
    pauseRemainingNotifier.value = pauseDuration;
    onSilencePauseChanged?.call(true);

    final surahName = QuranConstants.surahMap[step.surah]?.name ?? '';
    await audioHandler.playSilencePause(
      duration: pauseDuration,
      mediaItem: MediaItem(
        id: 'hifz_pause_${step.globalAyahId}',
        title: 'دورك للترديد — سورة $surahName آية ${step.ayah}',
        artist: 'حِفظي',
        album: 'حِفظي',
        artUri: AppAudioArtHelper.logoUri,
      ),
    );
  }

  Future<void> _advanceAfterStep() async {
    if (_queue.isEmpty) return;
    final step = _queue[_currentStepIndex];

    // Infinity mode loops the current step indefinitely until user skips or toggles off.
    if (step.isInfinity) {
      await _playCurrentStep();
      return;
    }

    if (_currentStepIndex + 1 < _queue.length) {
      _currentStepIndex++;
      await _playCurrentStep();
    } else {
      onQueueCompleted?.call();
    }
  }

  Future<void> dispose() async {
    await stop();
    await _processingSub?.cancel();
    await _positionSub?.cancel();
    pauseRemainingNotifier.dispose();
    pauseTotalNotifier.dispose();
  }
}


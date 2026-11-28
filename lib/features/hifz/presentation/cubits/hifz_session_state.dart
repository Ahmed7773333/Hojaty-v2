import 'package:equatable/equatable.dart';
import 'package:hojaty/features/hifz/data/models/reciter_registry.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_ayah_content.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_step.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';

enum SessionPhase {
  idle,
  preparingAudio,
  playing,
  pausingForRepeat,
  pausedByUser,
  testingMode,
  completed,
  offlineBlocked,
  error,
}

enum ViewMode { focusCard, mushafOverlay }

class HifzSessionState extends Equatable {
  final SessionPhase phase;
  final ViewMode viewMode;
  final List<HifzStep> queue;
  final int currentStepIndex;
  final int rangeStartGlobalAyah;
  final int rangeEndGlobalAyah;
  final int? planId;
  final bool isReviewSession;
  final List<HifzAyahContent> ayahContents;
  final Reciter reciter;
  final AudioQuality audioQuality;
  final int ayahRepeatCount;
  final int rangeRepeatCount;
  final bool cumulativeChaining;
  final bool pauseToRepeat;
  final PauseMode pauseMode;
  final int fixedPauseSeconds;
  final double playbackSpeed;
  final Set<int> revealedAyahs;
  final Set<int> hintedAyahs;
  final Set<int> masteredAyahs;
  final Set<int> needsReviewAyahs;
  final Map<int, AudioCacheStatus> ayahCacheMap;
  final int? offlineBlockedAyah;
  final String? errorMessage;
  final bool isMinimized;

  const HifzSessionState({
    this.phase = SessionPhase.idle,
    this.viewMode = ViewMode.focusCard,
    this.queue = const [],
    this.currentStepIndex = 0,
    this.rangeStartGlobalAyah = 1,
    this.rangeEndGlobalAyah = 1,
    this.planId,
    this.isReviewSession = false,
    this.ayahContents = const [],
    this.reciter = ReciterRegistry.husaryMuallim,
    this.audioQuality = AudioQuality.kbps128,
    this.ayahRepeatCount = 3,
    this.rangeRepeatCount = 1,
    this.cumulativeChaining = true,
    this.pauseToRepeat = false,
    this.pauseMode = PauseMode.dynamicDuration,
    this.fixedPauseSeconds = 5,
    this.playbackSpeed = 1.0,
    this.revealedAyahs = const {},
    this.hintedAyahs = const {},
    this.masteredAyahs = const {},
    this.needsReviewAyahs = const {},
    this.ayahCacheMap = const {},
    this.offlineBlockedAyah,
    this.errorMessage,
    this.isMinimized = false,
  });

  bool get hasActiveSession =>
      phase != SessionPhase.idle && ayahContents.isNotEmpty;

  bool get isAudioActive =>
      phase == SessionPhase.playing ||
      phase == SessionPhase.pausingForRepeat ||
      phase == SessionPhase.preparingAudio;

  HifzStep? get currentStep =>
      (currentStepIndex >= 0 && currentStepIndex < queue.length)
          ? queue[currentStepIndex]
          : null;

  int get activeGlobalAyahId {
    final step = currentStep;
    if (step != null && step.stepType != StepType.basmalah) {
      return step.globalAyahId;
    }
    if (ayahContents.isNotEmpty) {
      return ayahContents.first.globalAyahId;
    }
    return rangeStartGlobalAyah;
  }

  HifzAyahContent? get activeAyahContent {
    final targetId = activeGlobalAyahId;
    for (final item in ayahContents) {
      if (item.globalAyahId == targetId) return item;
    }
    return ayahContents.isNotEmpty ? ayahContents.first : null;
  }

  double get stepProgress => queue.isEmpty
      ? 0.0
      : ((currentStepIndex + 1) / queue.length).clamp(0.0, 1.0);

  HifzSessionState copyWith({
    SessionPhase? phase,
    ViewMode? viewMode,
    List<HifzStep>? queue,
    int? currentStepIndex,
    int? rangeStartGlobalAyah,
    int? rangeEndGlobalAyah,
    int? planId,
    bool clearPlanId = false,
    bool? isReviewSession,
    List<HifzAyahContent>? ayahContents,
    Reciter? reciter,
    AudioQuality? audioQuality,
    int? ayahRepeatCount,
    int? rangeRepeatCount,
    bool? cumulativeChaining,
    bool? pauseToRepeat,
    PauseMode? pauseMode,
    int? fixedPauseSeconds,
    double? playbackSpeed,
    Set<int>? revealedAyahs,
    Set<int>? hintedAyahs,
    Set<int>? masteredAyahs,
    Set<int>? needsReviewAyahs,
    Map<int, AudioCacheStatus>? ayahCacheMap,
    int? offlineBlockedAyah,
    bool clearOfflineBlockedAyah = false,
    String? errorMessage,
    bool clearError = false,
    bool? isMinimized,
  }) {
    return HifzSessionState(
      phase: phase ?? this.phase,
      viewMode: viewMode ?? this.viewMode,
      queue: queue ?? this.queue,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      rangeStartGlobalAyah: rangeStartGlobalAyah ?? this.rangeStartGlobalAyah,
      rangeEndGlobalAyah: rangeEndGlobalAyah ?? this.rangeEndGlobalAyah,
      planId: clearPlanId ? null : (planId ?? this.planId),
      isReviewSession: isReviewSession ?? this.isReviewSession,
      ayahContents: ayahContents ?? this.ayahContents,
      reciter: reciter ?? this.reciter,
      audioQuality: audioQuality ?? this.audioQuality,
      ayahRepeatCount: ayahRepeatCount ?? this.ayahRepeatCount,
      rangeRepeatCount: rangeRepeatCount ?? this.rangeRepeatCount,
      cumulativeChaining: cumulativeChaining ?? this.cumulativeChaining,
      pauseToRepeat: pauseToRepeat ?? this.pauseToRepeat,
      pauseMode: pauseMode ?? this.pauseMode,
      fixedPauseSeconds: fixedPauseSeconds ?? this.fixedPauseSeconds,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      revealedAyahs: revealedAyahs ?? this.revealedAyahs,
      hintedAyahs: hintedAyahs ?? this.hintedAyahs,
      masteredAyahs: masteredAyahs ?? this.masteredAyahs,
      needsReviewAyahs: needsReviewAyahs ?? this.needsReviewAyahs,
      ayahCacheMap: ayahCacheMap ?? this.ayahCacheMap,
      offlineBlockedAyah: clearOfflineBlockedAyah
          ? null
          : (offlineBlockedAyah ?? this.offlineBlockedAyah),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isMinimized: isMinimized ?? this.isMinimized,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        viewMode,
        queue,
        currentStepIndex,
        rangeStartGlobalAyah,
        rangeEndGlobalAyah,
        planId,
        isReviewSession,
        ayahContents,
        reciter,
        audioQuality,
        ayahRepeatCount,
        rangeRepeatCount,
        cumulativeChaining,
        pauseToRepeat,
        pauseMode,
        fixedPauseSeconds,
        playbackSpeed,
        revealedAyahs,
        hintedAyahs,
        masteredAyahs,
        needsReviewAyahs,
        ayahCacheMap,
        offlineBlockedAyah,
        errorMessage,
        isMinimized,
      ];
}


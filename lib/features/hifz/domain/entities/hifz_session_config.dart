import 'package:equatable/equatable.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';

/// Pause-to-repeat duration mode.
enum PauseMode { dynamicDuration, fixed }

/// Download/cache status for a single ayah audio file.
enum AudioCacheStatus { notCached, downloading, cached, failed }

/// Persisted Hifz studio & playback configuration.
class HifzSessionConfig extends Equatable {
  final String reciterId;
  final AudioQuality audioQuality;
  final int ayahRepeatCount;
  final int rangeRepeatCount;
  final bool cumulativeChaining;
  final bool pauseToRepeat;
  final PauseMode pauseMode;
  final int fixedPauseSeconds;
  final double playbackSpeed;

  const HifzSessionConfig({
    this.reciterId = 'husary_muallim',
    this.audioQuality = AudioQuality.kbps128,
    this.ayahRepeatCount = 3,
    this.rangeRepeatCount = 1,
    this.cumulativeChaining = true,
    this.pauseToRepeat = false,
    this.pauseMode = PauseMode.dynamicDuration,
    this.fixedPauseSeconds = 5,
    this.playbackSpeed = 1.0,
  });

  HifzSessionConfig copyWith({
    String? reciterId,
    AudioQuality? audioQuality,
    int? ayahRepeatCount,
    int? rangeRepeatCount,
    bool? cumulativeChaining,
    bool? pauseToRepeat,
    PauseMode? pauseMode,
    int? fixedPauseSeconds,
    double? playbackSpeed,
  }) {
    return HifzSessionConfig(
      reciterId: reciterId ?? this.reciterId,
      audioQuality: audioQuality ?? this.audioQuality,
      ayahRepeatCount: ayahRepeatCount ?? this.ayahRepeatCount,
      rangeRepeatCount: rangeRepeatCount ?? this.rangeRepeatCount,
      cumulativeChaining: cumulativeChaining ?? this.cumulativeChaining,
      pauseToRepeat: pauseToRepeat ?? this.pauseToRepeat,
      pauseMode: pauseMode ?? this.pauseMode,
      fixedPauseSeconds: fixedPauseSeconds ?? this.fixedPauseSeconds,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
    );
  }

  @override
  List<Object?> get props => [
        reciterId,
        audioQuality,
        ayahRepeatCount,
        rangeRepeatCount,
        cumulativeChaining,
        pauseToRepeat,
        pauseMode,
        fixedPauseSeconds,
        playbackSpeed,
      ];
}


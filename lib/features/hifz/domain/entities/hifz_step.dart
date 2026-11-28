import 'package:equatable/equatable.dart';

/// Step category inside a deterministic Hifz playback queue.
enum StepType { basmalah, singleRepeat, chainLink, fullRangeReview }

/// Single playback step emitted by [GeneratePlaybackQueue].
class HifzStep extends Equatable {
  final int globalAyahId;
  final int surah;
  final int ayah;
  final int repeatIndex;
  final int totalRepeats;
  final int rangeLoopIndex;
  final StepType stepType;

  const HifzStep({
    required this.globalAyahId,
    required this.surah,
    required this.ayah,
    required this.repeatIndex,
    required this.totalRepeats,
    required this.rangeLoopIndex,
    required this.stepType,
  });

  bool get isInfinity => totalRepeats == -1;

  @override
  List<Object?> get props => [
        globalAyahId,
        surah,
        ayah,
        repeatIndex,
        totalRepeats,
        rangeLoopIndex,
        stepType,
      ];
}


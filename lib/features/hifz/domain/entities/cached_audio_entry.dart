import 'package:equatable/equatable.dart';

/// Local audio cache index record (`cached_audio_entries`).
class CachedAudioEntry extends Equatable {
  final String cacheKey;
  final String reciterId;
  final int surahId;
  final int fileSizeBytes;
  final bool isPinned;
  final DateTime lastAccessedAt;

  const CachedAudioEntry({
    required this.cacheKey,
    required this.reciterId,
    required this.surahId,
    required this.fileSizeBytes,
    required this.isPinned,
    required this.lastAccessedAt,
  });

  @override
  List<Object?> get props => [
        cacheKey,
        reciterId,
        surahId,
        fileSizeBytes,
        isPinned,
        lastAccessedAt,
      ];
}


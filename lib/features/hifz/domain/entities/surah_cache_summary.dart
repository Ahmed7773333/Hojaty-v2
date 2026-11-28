import 'package:equatable/equatable.dart';

/// Aggregated cached audio summary for a reciter + surah pair.
class SurahCacheSummary extends Equatable {
  final String reciterId;
  final int surahId;
  final int ayahCount;
  final int totalBytes;
  final bool isFullyPinned;

  const SurahCacheSummary({
    required this.reciterId,
    required this.surahId,
    required this.ayahCount,
    required this.totalBytes,
    required this.isFullyPinned,
  });

  @override
  List<Object?> get props => [
        reciterId,
        surahId,
        ayahCount,
        totalBytes,
        isFullyPinned,
      ];
}


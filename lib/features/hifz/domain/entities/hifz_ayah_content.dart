import 'package:equatable/equatable.dart';

/// Resolved Quran ayah text, page location, and Mushaf bounding boxes for Hifz Studio.
class HifzAyahContent extends Equatable {
  final int globalAyahId;
  final int surahId;
  final int ayahNumber;
  final String surahNameAr;
  final String surahNameEn;
  final int pageNumber;
  final int verseIndexOnPage;
  final String uthmaniText;
  final List<List<double>> bounds;

  const HifzAyahContent({
    required this.globalAyahId,
    required this.surahId,
    required this.ayahNumber,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.pageNumber,
    required this.verseIndexOnPage,
    required this.uthmaniText,
    required this.bounds,
  });

  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  /// Returns the first [count] words of the ayah for First-Word Hint mode.
  String firstWords([int count = 2]) {
    final trimmed = uthmaniText.trim();
    if (trimmed.isEmpty) return '';
    final words = trimmed.split(_whitespaceRegex);
    if (words.length <= count) return trimmed;
    return '${words.take(count).join(' ')} ...';
  }

  @override
  List<Object?> get props => [
        globalAyahId,
        surahId,
        ayahNumber,
        surahNameAr,
        surahNameEn,
        pageNumber,
        verseIndexOnPage,
        uthmaniText,
        bounds,
      ];
}


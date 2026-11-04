import 'quran_constants.dart';

class QuranTextHelper {
  static const Map<String, String> _arabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  static String convertToArabicJuzs(int number) {
    if (number < 1 || number > QuranConstants.arabicOrdinalsJuzs.length) {
      return '';
    }
    return QuranConstants.arabicOrdinalsJuzs[number - 1];
  }

  static String convertToArabicHizbs(int number) {
    if (number < 1 || number > QuranConstants.arabicOrdinalsHezbs.length) {
      return '';
    }
    return QuranConstants.arabicOrdinalsHezbs[number - 1];
  }

  static String getSurahName(int pageNum) {
    final p = pageNum - 1;
    if (p < 0 || p >= QuranConstants.pageInfo.length) return '';
    final pages = QuranConstants.pageInfo[p];
    if (pages.isEmpty) return '';
    final surahNum = pages.length >= 2 ? pages.last.surah : pages.first.surah;
    return QuranConstants.surahMap[surahNum]?.name ?? '';
  }

  static String getVerseEndSymbol(int verseNumber, {bool arabicNumeral = true}) {
    if (!arabicNumeral) return '\u06dd$verseNumber';

    final digits = verseNumber.toString().split('');
    final arabicNumeric = digits.map((d) => _arabicDigits[d] ?? d).join();

    return '\u06dd$arabicNumeric';
  }

  static int getPageNumber(int surahNum, int verseNum) {
    for (int i = 0; i < QuranConstants.pageInfo.length; i++) {
      for (int j = 0; j < QuranConstants.pageInfo[i].length; j++) {
        final info = QuranConstants.pageInfo[i][j];
        if (info.surah == surahNum && info.start <= verseNum && info.end >= verseNum) {
          return i + 1; // 1-based page number
        }
      }
    }
    return 1;
  }

  static int getJuzNumber(int surahNumber, int verseNumber) {
    for (final juz in QuranConstants.juz) {
      if (juz.verses.containsKey(surahNumber)) {
        final range = juz.verses[surahNumber];
        if (range != null && range.length >= 2) {
          if (verseNumber >= range[0] && verseNumber <= range[1]) {
            return juz.id;
          }
        }
      }
    }
    return 1;
  }

  static String normalizeArabic(String text) {
    final diacriticRegex = RegExp(
      r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]',
    );

    String normalized = text;
    normalized = normalized.replaceAll(diacriticRegex, '');
    normalized = normalized
        .replaceAll('ٱ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ئ', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ة', 'ه')
        .replaceAll('ـ', '');

    return normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

import 'package:hojaty/core/constants/app_constants.dart';

class Helper {
  static String convertToArabicJuzs(int number) {
    return AppConstants.arabicOrdinalsJuzs[number - 1];
  }

  static int getJuzNumber(int surahNumber, int verseNumber) {
    for (var juz in AppConstants.juz) {
      if (juz.verses.keys.contains(surahNumber)) {
        if (verseNumber >= (juz.verses[surahNumber])![0] &&
            verseNumber <= juz.verses[surahNumber]![1]) {
          return int.parse(juz.id.toString());
        }
      }
    }
    return -1;
  }

  static String convertToArabicHizbs(int number) {
    return AppConstants.arabicOrdinalsHezbs[number - 1];
  }

  static String getSurahName(int pageNum) {
    final p = pageNum - 1;
    return AppConstants.pageInfo[p].length >= 2
        ? AppConstants.surahMap[AppConstants.pageInfo[p].last.surah]!.name
        : AppConstants.surahMap[AppConstants.pageInfo[p].first.surah]!.name;
  }

  static String getVerseEndSymbol(
    int verseNumber, {
    bool arabicNumeral = true,
  }) {
    var arabicNumeric = '';
    var digits = verseNumber.toString().split("").toList();

    if (!arabicNumeral) return '\u06dd${verseNumber.toString()}';

    const Map arabicNumbers = {
      "0": "٠",
      "1": "۱",
      "2": "۲",
      "3": "۳",
      "4": "٤",
      "5": "٥",
      "6": "٦",
      "7": "۷",
      "8": "۸",
      "9": "۹",
    };

    for (var e in digits) {
      arabicNumeric += arabicNumbers[e];
    }

    return '\u06dd$arabicNumeric';
  }

  static int getPageNumberr(int surahNum, int verseNum) {
    int pageNum = 0;
    for (int i = 0; i < AppConstants.pageInfo.length; i++) {
      for (int j = 0; j < AppConstants.pageInfo[i].length; j++) {
        if (AppConstants.pageInfo[i][j].surah == surahNum &&
            AppConstants.pageInfo[i][j].start <= verseNum &&
            AppConstants.pageInfo[i][j].end >= verseNum) {
          pageNum = i;
          return pageNum;
        }
      }
    }
    return pageNum;
  }

  // Helper function to normalize Arabic text by removing tashkil
  static String normalizeArabic(String text) {
    final diacriticRegex = RegExp(
      r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]',
    );

    String normalized = text;

    // Remove diacritics (Tashkil)
    normalized = normalized.replaceAll(diacriticRegex, '');

    // Normalize common characters
    normalized = normalized
        .replaceAll('ٱ', 'ا') // Small Alef (ٱ) to regular Alif
        .replaceAll('آ', 'ا') // Alif with Madda
        .replaceAll('أ', 'ا') // Alif with Hamza above
        .replaceAll('إ', 'ا') // Alif with Hamza below
        .replaceAll('ى', 'ي') // Alef Maqsura to Ya
        .replaceAll('ئ', 'ي') // Hamza on Ya to Ya
        .replaceAll('ؤ', 'و') // Hamza on Waw to Waw
        .replaceAll('ة', 'ه') // Ta Marbuta to Ha (optional)
        .replaceAll('ـ', ''); // Tatweel (Kashida)

    // Trim spaces
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();

    return normalized.toLowerCase();
  }
}

import 'dart:convert';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:hojaty/features/quran/constants/quran_text_helper.dart';
import 'package:hojaty/features/quran/data/models/page_data_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Quran Constants Integrity Check', () {
    // 1. Verify 114 Surahs
    expect(QuranConstants.surahMap.length, 114);
    expect(QuranConstants.surahMap[1]?.name, 'الفاتحة');
    expect(QuranConstants.surahMap[1]?.pageNumber, 1);
    expect(QuranConstants.surahMap[2]?.name, 'البقرة');
    expect(QuranConstants.surahMap[2]?.pageNumber, 2);
    expect(QuranConstants.surahMap[114]?.name, 'الناس');
    expect(QuranConstants.surahMap[114]?.pageNumber, 604);

    // 2. Verify 30 Juzs & 60 Hizbs
    expect(QuranConstants.juz.length, 30);
    expect(QuranConstants.hezbs.length, 60);
    expect(QuranConstants.arabicOrdinalsJuzs.length, 30);
    expect(QuranConstants.arabicOrdinalsHezbs.length, 60);

    // 3. Verify 604 pages in pageInfo
    expect(QuranConstants.pageInfo.length, 604);
  });

  test('QuranTextHelper Logic Checks', () {
    // Arabic Normalization
    final raw = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ';
    final normalized = QuranTextHelper.normalizeArabic(raw);
    expect(normalized, 'بسم الله الرحمن الرحيم');

    // Ordinal Strings
    expect(QuranTextHelper.convertToArabicJuzs(1), 'الجزء الأول');
    expect(QuranTextHelper.convertToArabicJuzs(30), 'الجزء الثلاثون');
    expect(QuranTextHelper.convertToArabicHizbs(1), 'الحزب الأول');
    expect(QuranTextHelper.convertToArabicHizbs(60), 'الحزب الستون');

    // Page Calculation
    expect(QuranTextHelper.getPageNumber(1, 1), 1);
    expect(QuranTextHelper.getPageNumber(2, 1), 2);
    expect(QuranTextHelper.getPageNumber(114, 1), 604);

    // Surah Name By Page
    expect(QuranTextHelper.getSurahName(1), 'الفاتحة');
    expect(QuranTextHelper.getSurahName(2), 'البقرة');
    expect(QuranTextHelper.getSurahName(604), 'الناس');
  });

  test('PageDataModel fromJson Parsing Check', () {
    final sampleJson = {
      'hasBesmALLAH': true,
      'numberOfBesmALLAH': 1,
      'versesContent': ['بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'],
      'versesNumbers': [1],
      'surahsNames': ['الفاتحة'],
      'hasHead': true,
      'hasQurater': true,
      'isFateha': true,
      'quarterName': 'الحزب الأول',
      'juzName': 'الجزء الأول',
      'numberOfHeads': 1,
      'pageNumber': 1,
      'juzNumber': 1,
      'rubNumber': 1,
      'rubAya': 1,
      'surahsNumber': [1],
      'versesContentEmaly': ['بسم الله الرحمن الرحيم'],
      'tafseer': ['تفسير البسملة'],
      'lineEnds': [1],
      'lineStarts': [1],
    };

    final model = PageDataModel.fromJson(sampleJson);
    expect(model.pageNumber, 1);
    expect(model.hasBesmALLAH, true);
    expect(model.quarterName, 'الحزب الأول');
    expect(model.versesContentEmaly?.first, 'بسم الله الرحمن الرحيم');
    expect(model.tafseer?.first, 'تفسير البسملة');
  });
}

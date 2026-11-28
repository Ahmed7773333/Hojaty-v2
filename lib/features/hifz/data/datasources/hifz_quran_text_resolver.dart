import 'package:hojaty/features/hifz/domain/entities/hifz_ayah_content.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:hojaty/features/quran/constants/quran_text_helper.dart';
import 'package:hojaty/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:hojaty/features/quran/data/models/page_data_model.dart';
import 'package:hojaty/features/quran/presentation/bloc/quran_bloc.dart';

/// Resolves Quranic text, page numbers, and Mushaf bounding boxes for Hifz ayahs
/// directly from Hojaty's existing `QuranBloc` / `QuranLocalDataSource` without
/// duplicating the Quran dataset.
class HifzQuranTextResolver {
  final QuranBloc quranBloc;
  final QuranLocalDataSource quranLocalDataSource;

  Map<int, PageDataModel>? _fallbackPages;

  HifzQuranTextResolver({
    required this.quranBloc,
    required this.quranLocalDataSource,
  });

  Future<Map<int, PageDataModel>> _getPagesMap() async {
    final blocPages = quranBloc.state.quranPages;
    if (blocPages.isNotEmpty) {
      return blocPages;
    }
    if (_fallbackPages != null && _fallbackPages!.isNotEmpty) {
      return _fallbackPages!;
    }
    final loaded = await quranLocalDataSource.getPages();
    _fallbackPages = <int, PageDataModel>{
      for (final p in loaded)
        if (p.pageNumber != null) p.pageNumber!: p,
    };
    return _fallbackPages!;
  }

  /// Resolves a list of [HifzAyahContent] for all [globalAyahIds].
  Future<List<HifzAyahContent>> resolveAyahs(List<int> globalAyahIds) async {
    if (globalAyahIds.isEmpty) return const [];
    final pagesMap = await _getPagesMap();
    final results = <HifzAyahContent>[];

    for (final globalId in globalAyahIds) {
      if (globalId < 1 || globalId > GlobalAyahMapper.totalAyahs) continue;
      final mapped = GlobalAyahMapper.fromGlobalAyahId(globalId);
      final surahInfo = QuranConstants.surahMap[mapped.surah];
      final pageNumber = QuranTextHelper.getPageNumber(
        mapped.surah,
        mapped.ayah,
      );
      final pageData = pagesMap[pageNumber];

      String uthmaniText = '';
      int verseIndexOnPage = -1;
      List<List<double>> bounds = const [];

      if (pageData != null) {
        final versesNumbers = pageData.versesNumbers ?? const <int>[];
        final surahsNumber = pageData.surahsNumber ?? const <int>[];
        final versesContent = pageData.versesContent ?? const <String>[];
        final versesBounds =
            pageData.versesBounds ?? const <List<List<double>>>[];

        for (int i = 0; i < versesNumbers.length; i++) {
          final vSurah =
              i < surahsNumber.length ? surahsNumber[i] : mapped.surah;
          if (vSurah == mapped.surah && versesNumbers[i] == mapped.ayah) {
            verseIndexOnPage = i;
            if (i < versesContent.length) {
              uthmaniText = versesContent[i];
            }
            if (i < versesBounds.length) {
              bounds = versesBounds[i];
            }
            break;
          }
        }
      }

      results.add(
        HifzAyahContent(
          globalAyahId: globalId,
          surahId: mapped.surah,
          ayahNumber: mapped.ayah,
          surahNameAr: surahInfo?.name ?? '',
          surahNameEn: surahInfo?.englishName ?? '',
          pageNumber: pageNumber,
          verseIndexOnPage: verseIndexOnPage,
          uthmaniText: uthmaniText,
          bounds: bounds,
        ),
      );
    }

    return results;
  }
}


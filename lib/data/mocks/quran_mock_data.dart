import '../../features/homelayout/data/models/surah_item_model.dart';
import '../../features/quran/constants/quran_constants.dart';

class QuranMockData {
  static const String lastReadSurahName = 'سورة البقرة';
  static const int lastReadAyahNumber = 125;

  static List<SurahItemModel> get surahs => QuranConstants.surahMap.values.map((s) {
        return SurahItemModel(
          number: s.number,
          arabicName: s.name,
          englishName: s.englishName,
          ayahCount: s.ayahCount,
          isMeccan: s.isMeccan,
          pageNumber: s.pageNumber,
        );
      }).toList();
}

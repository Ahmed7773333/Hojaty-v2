import 'package:hojaty/core/constants/app_constants.dart';

class SearchModel {
  SearchModel({
    required this.surahNum,
    required this.verseNum,
    required this.surahName,
    required this.content,
    required this.pageNum,
    required this.tafseer,
  });

  final int surahNum;
  final int verseNum;
  final int pageNum;
  final String surahName;
  final String content;
  final String tafseer;


  int getPageNumberr() {
    int pageNum = 0;
    for (int i = 0; i < AppConstants.pageInfo.length; i++) {
      for (int j = 0; j < AppConstants.pageInfo[i].length; j++) {
        if (AppConstants.pageInfo[i][j].surah == surahNum &&
            AppConstants.pageInfo[i][j].start <= verseNum &&
            AppConstants.pageInfo[i][j].end >= verseNum) {
          pageNum = i + 1;
          return pageNum;
        }
      }
    }
    return pageNum;
  }
}

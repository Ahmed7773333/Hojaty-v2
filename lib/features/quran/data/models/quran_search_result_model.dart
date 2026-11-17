import 'package:equatable/equatable.dart';

class QuranSearchResultModel extends Equatable {
  final int surahNum;
  final int verseNum;
  final int pageNum;
  final String surahName;
  final String content;
  final String tafseer;

  const QuranSearchResultModel({
    required this.surahNum,
    required this.verseNum,
    required this.pageNum,
    required this.surahName,
    required this.content,
    required this.tafseer,
  });

  @override
  List<Object?> get props => [
        surahNum,
        verseNum,
        pageNum,
        surahName,
        content,
        tafseer,
      ];
}

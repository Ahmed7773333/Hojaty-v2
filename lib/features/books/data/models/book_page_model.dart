import 'package:equatable/equatable.dart';
import 'package:hojaty/features/books/data/models/hadith_item_model.dart';

class BookPageModel extends Equatable {
  final int pageNumber;
  final int chapterId;
  final String chapterTitle;
  final bool isChapterStart;
  final List<HadithItemModel> hadiths;

  const BookPageModel({
    required this.pageNumber,
    required this.chapterId,
    required this.chapterTitle,
    required this.isChapterStart,
    required this.hadiths,
  });

  @override
  List<Object?> get props => [
        pageNumber,
        chapterId,
        chapterTitle,
        isChapterStart,
        hadiths,
      ];
}


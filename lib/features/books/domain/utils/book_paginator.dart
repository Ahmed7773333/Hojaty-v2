import 'package:hojaty/features/books/data/models/book_chapter_model.dart';
import 'package:hojaty/features/books/data/models/book_collection_model.dart';
import 'package:hojaty/features/books/data/models/book_page_model.dart';
import 'package:hojaty/features/books/data/models/hadith_item_model.dart';

class BookPaginationResult {
  final List<BookPageModel> pages;
  final Map<int, int> chapterStartPages;
  final Map<int, int> hadithPages;

  const BookPaginationResult({
    required this.pages,
    required this.chapterStartPages,
    required this.hadithPages,
  });
}

class BookPaginator {
  static const int defaultMaxCharsPerPage = 850;

  static BookPaginationResult paginate({
    required BookCollectionModel collection,
    int? scopedChapterId,
    int maxCharsPerPage = defaultMaxCharsPerPage,
  }) {
    final chapterMap = <int, BookChapterModel>{
      for (final ch in collection.chapters) ch.id: ch,
    };

    final hadithsToPaginate = scopedChapterId != null
        ? collection.hadiths.where((h) => h.chapterId == scopedChapterId).toList()
        : collection.hadiths;

    final pages = <BookPageModel>[];
    final chapterStartPages = <int, int>{};
    final hadithPages = <int, int>{};

    if (hadithsToPaginate.isEmpty) {
      return const BookPaginationResult(
        pages: [],
        chapterStartPages: {},
        hadithPages: {},
      );
    }

    List<HadithItemModel> currentHadiths = [];
    int currentLength = 0;
    int? currentChapterId;
    bool isFirstPageOfChapter = true;

    for (final hadith in hadithsToPaginate) {
      final chId = hadith.chapterId;
      final textLen = hadith.arabic.length;
      final isNewChapter = currentChapterId != null && chId != currentChapterId;

      if (isNewChapter || (currentLength + textLen > maxCharsPerPage && currentHadiths.isNotEmpty)) {
        final pageNum = pages.length + 1;
        final chTitle = chapterMap[currentChapterId]?.arabic ?? '';

        pages.add(
          BookPageModel(
            pageNumber: pageNum,
            chapterId: currentChapterId ?? 0,
            chapterTitle: chTitle,
            isChapterStart: isFirstPageOfChapter,
            hadiths: currentHadiths,
          ),
        );

        for (final h in currentHadiths) {
          hadithPages[h.id] = pageNum;
        }

        if (isNewChapter) {
          isFirstPageOfChapter = true;
        } else {
          isFirstPageOfChapter = false;
        }

        currentHadiths = [hadith];
        currentLength = textLen;
        currentChapterId = chId;

        if (isFirstPageOfChapter) {
          chapterStartPages.putIfAbsent(chId, () => pages.length + 1);
        }
      } else {
        if (currentHadiths.isEmpty) {
          currentChapterId = chId;
          chapterStartPages.putIfAbsent(chId, () => pages.length + 1);
        }
        currentHadiths.add(hadith);
        currentLength += textLen;
      }
    }

    if (currentHadiths.isNotEmpty) {
      final pageNum = pages.length + 1;
      final chTitle = chapterMap[currentChapterId]?.arabic ?? '';

      pages.add(
        BookPageModel(
          pageNumber: pageNum,
          chapterId: currentChapterId ?? 0,
          chapterTitle: chTitle,
          isChapterStart: isFirstPageOfChapter,
          hadiths: currentHadiths,
        ),
      );

      for (final h in currentHadiths) {
        hadithPages[h.id] = pageNum;
      }
    }

    return BookPaginationResult(
      pages: pages,
      chapterStartPages: chapterStartPages,
      hadithPages: hadithPages,
    );
  }
}


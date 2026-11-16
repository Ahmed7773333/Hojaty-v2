import 'package:equatable/equatable.dart';
import 'book_chapter_model.dart';
import 'hadith_item_model.dart';

class BookCollectionModel extends Equatable {
  final int id;
  final String titleAr;
  final String titleEn;
  final String authorAr;
  final String authorEn;
  final List<BookChapterModel> chapters;
  final List<HadithItemModel> hadiths;

  const BookCollectionModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.authorAr,
    required this.authorEn,
    required this.chapters,
    required this.hadiths,
  });

  factory BookCollectionModel.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>?;
    final ar = meta?['arabic'] as Map<String, dynamic>?;
    final en = meta?['english'] as Map<String, dynamic>?;

    final chaptersList = (json['chapters'] as List<dynamic>?)
            ?.map((e) => BookChapterModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    final hadithsList = (json['hadiths'] as List<dynamic>?)
            ?.map((e) => HadithItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    return BookCollectionModel(
      id: json['id'] as int? ?? (meta?['id'] as int? ?? 0),
      titleAr: ar?['title'] as String? ?? '',
      titleEn: en?['title'] as String? ?? '',
      authorAr: ar?['author'] as String? ?? '',
      authorEn: en?['author'] as String? ?? '',
      chapters: chaptersList,
      hadiths: hadithsList,
    );
  }

  factory BookCollectionModel.fromDuaaList(List<dynamic> list, {int id = 18}) {
    final chapters = <BookChapterModel>[];
    final categoryToChapterId = <String, int>{};
    final hadiths = <HadithItemModel>[];

    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;
      final category = item['category'] as String? ?? 'أدعية';
      if (!categoryToChapterId.containsKey(category)) {
        final chapterId = chapters.length + 1;
        categoryToChapterId[category] = chapterId;
        chapters.add(
          BookChapterModel(
            id: chapterId,
            bookId: id,
            arabic: category,
            english: category,
          ),
        );
      }

      final chapterId = categoryToChapterId[category]!;
      final duaaList = (item['duaa'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      var arabicText = duaaList.join('\n\n');

      final source = item['source'] as Map<String, dynamic>?;
      if (source != null) {
        final sourceParts = <String>[];
        final quran = source['quran'] as List<dynamic>?;
        if (quran != null) {
          for (final q in quran) {
            if (q is Map<String, dynamic>) {
              final surah = (q['surah'] as Map<String, dynamic>?)?['name'] ?? '';
              final ayah = q['ayah'];
              if (ayah is Map<String, dynamic>) {
                final from = ayah['from'];
                final to = ayah['to'];
                if (from != null && to != null) {
                  sourceParts.add(from == to ? 'سورة $surah: $from' : 'سورة $surah: $from-$to');
                }
              } else if (ayah != null) {
                sourceParts.add('سورة $surah: $ayah');
              }
            }
          }
        }

        final hadithSources = source['hadith'] as List<dynamic>?;
        if (hadithSources != null) {
          for (final group in hadithSources) {
            if (group is List) {
              for (final h in group) {
                if (h is Map<String, dynamic>) {
                  final takhrij = h['takhrij'] as String?;
                  final book = h['book'] as String?;
                  final num = h['numberOrPage'];
                  final grade = h['grade'] as String?;
                  if (takhrij != null && takhrij.isNotEmpty) {
                    sourceParts.add(takhrij);
                    break;
                  } else if (book != null && book.isNotEmpty) {
                    final part = '$book${num != null ? " ($num)" : ""}${grade != null ? " - $grade" : ""}';
                    sourceParts.add(part);
                    break;
                  }
                }
              }
            }
          }
        }

        if (sourceParts.isNotEmpty) {
          arabicText = '$arabicText\n\nالمصدر:\n${sourceParts.join('\n')}';
        }
      }

      final itemId = item['id'] as int? ?? (hadiths.length + 1);
      hadiths.add(
        HadithItemModel(
          id: itemId,
          idInBook: itemId,
          chapterId: chapterId,
          bookId: id,
          arabic: arabicText,
        ),
      );
    }

    return BookCollectionModel(
      id: id,
      titleAr: 'الدعاء من الكتاب والسنة',
      titleEn: 'Dua from the Quran & Sunnah',
      authorAr: 'سعيد بن علي بن وهف القحطاني',
      authorEn: "Sa'id ibn Wahf al-Qahtani",
      chapters: chapters,
      hadiths: hadiths,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleAr,
        titleEn,
        authorAr,
        authorEn,
        chapters,
        hadiths,
      ];
}


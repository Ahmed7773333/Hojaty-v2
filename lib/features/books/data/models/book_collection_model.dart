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


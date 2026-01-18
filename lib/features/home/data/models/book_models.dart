import 'package:equatable/equatable.dart';

enum BookCategory { nineBooks, forties, other }

class BookInfo extends Equatable {
  final String id;
  final String titleKey;
  final String assetName;
  final String assetPackName;
  final BookCategory category;

  const BookInfo({
    required this.id,
    required this.titleKey,
    required this.assetName,
    required this.assetPackName,
    required this.category,
  });

  @override
  List<Object?> get props => [id, titleKey, assetName, assetPackName, category];
}

class BookCollection extends Equatable {
  final int id;
  final BookMetadata metadata;
  final List<Chapter> chapters;
  final List<HadithItem> hadiths;

  const BookCollection({
    required this.id,
    required this.metadata,
    required this.chapters,
    required this.hadiths,
  });

  factory BookCollection.fromJson(Map<String, dynamic> json) {
    return BookCollection(
      id: json['id'] as int? ?? 0,
      metadata: BookMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hadiths:
          (json['hadiths'] as List<dynamic>?)
              ?.map((e) => HadithItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'metadata': metadata.toJson(),
      'chapters': chapters.map((e) => e.toJson()).toList(),
      'hadiths': hadiths.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, metadata, chapters, hadiths];
}

class BookMetadata extends Equatable {
  final int id;
  final int length;
  final LocalizedContent arabic;
  final LocalizedContent english;

  const BookMetadata({
    required this.id,
    required this.length,
    required this.arabic,
    required this.english,
  });

  factory BookMetadata.fromJson(Map<String, dynamic> json) {
    return BookMetadata(
      id: json['id'] as int? ?? 0,
      length: json['length'] as int? ?? 0,
      arabic: LocalizedContent.fromJson(json['arabic'] as Map<String, dynamic>),
      english: LocalizedContent.fromJson(
        json['english'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'length': length,
      'arabic': arabic.toJson(),
      'english': english.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, length, arabic, english];
}

class LocalizedContent extends Equatable {
  final String title;
  final String author;
  final String introduction;

  const LocalizedContent({
    required this.title,
    required this.author,
    required this.introduction,
  });

  factory LocalizedContent.fromJson(Map<String, dynamic> json) {
    return LocalizedContent(
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      introduction: json['introduction'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'author': author, 'introduction': introduction};
  }

  @override
  List<Object?> get props => [title, author, introduction];
}

class Chapter extends Equatable {
  final int id;
  final int bookId;
  final String arabic;
  final String english;

  const Chapter({
    required this.id,
    required this.bookId,
    required this.arabic,
    required this.english,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int? ?? 0,
      bookId: json['bookId'] as int? ?? 0,
      arabic: json['arabic'] as String? ?? '',
      english: json['english'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'bookId': bookId, 'arabic': arabic, 'english': english};
  }

  @override
  List<Object?> get props => [id, bookId, arabic, english];
}

class HadithItem extends Equatable {
  final int id;
  final int idInBook;
  final int chapterId;
  final int bookId;
  final String arabic;
  final HadithEnglish english;

  const HadithItem({
    required this.id,
    required this.idInBook,
    required this.chapterId,
    required this.bookId,
    required this.arabic,
    required this.english,
  });

  factory HadithItem.fromJson(Map<String, dynamic> json) {
    return HadithItem(
      id: json['id'] as int? ?? 0,
      idInBook: json['idInBook'] as int? ?? 0,
      chapterId: json['chapterId'] as int? ?? 0,
      bookId: json['bookId'] as int? ?? 0,
      arabic: json['arabic'] as String? ?? '',
      english: HadithEnglish.fromJson(json['english'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idInBook': idInBook,
      'chapterId': chapterId,
      'bookId': bookId,
      'arabic': arabic,
      'english': english.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, idInBook, chapterId, bookId, arabic, english];
}

class HadithEnglish extends Equatable {
  final String narrator;
  final String text;

  const HadithEnglish({required this.narrator, required this.text});

  factory HadithEnglish.fromJson(Map<String, dynamic> json) {
    return HadithEnglish(
      narrator: json['narrator'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'narrator': narrator, 'text': text};
  }

  @override
  List<Object?> get props => [narrator, text];
}

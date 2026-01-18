import 'package:equatable/equatable.dart';

// Adhkar Models
class AdhkarCategory extends Equatable {
  final int id;
  final String category;
  final String audio;
  final String filename;
  final List<AdhkarItem> array;

  const AdhkarCategory({
    required this.id,
    required this.category,
    required this.audio,
    required this.filename,
    required this.array,
  });

  factory AdhkarCategory.fromJson(Map<String, dynamic> json) {
    return AdhkarCategory(
      id: json['id'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      audio: json['audio'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      array:
          (json['array'] as List<dynamic>?)
              ?.map((e) => AdhkarItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [id, category, audio, filename, array];
}

class AdhkarItem extends Equatable {
  final int id;
  final String text;
  final int count;
  final String audio;
  final String filename;

  const AdhkarItem({
    required this.id,
    required this.text,
    required this.count,
    required this.audio,
    required this.filename,
  });

  factory AdhkarItem.fromJson(Map<String, dynamic> json) {
    return AdhkarItem(
      id: json['id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      count: json['count'] as int? ?? 1,
      audio: json['audio'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, text, count, audio, filename];
}

// Duaa Models
class DuaaCategory extends Equatable {
  final int id;
  final String category;
  final List<String> duaa;
  final DuaaSource? source;

  const DuaaCategory({
    required this.id,
    required this.category,
    required this.duaa,
    this.source,
  });

  factory DuaaCategory.fromJson(Map<String, dynamic> json) {
    return DuaaCategory(
      id: json['id'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      duaa:
          (json['duaa'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      source: json['source'] != null
          ? DuaaSource.fromJson(json['source'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, category, duaa, source];
}

class DuaaSource extends Equatable {
  final List<String>? quran;
  // Hadith is complex nested list in JSON: "hadith": [ [ { "rawi": ... } ] ]
  // It's a list of list of objects.
  final List<List<DuaaHadithSource>>? hadith;

  const DuaaSource({this.quran, this.hadith});

  factory DuaaSource.fromJson(Map<String, dynamic> json) {
    var hadithList = <List<DuaaHadithSource>>[];
    if (json['hadith'] != null) {
      if (json['hadith'] is List) {
        for (var outer in json['hadith'] as List) {
          if (outer is List) {
            var innerList = outer
                .map(
                  (e) => DuaaHadithSource.fromJson(e as Map<String, dynamic>),
                )
                .toList();
            hadithList.add(innerList);
          }
        }
      }
    }

    return DuaaSource(
      quran: (json['quran'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hadith: hadithList,
    );
  }

  @override
  List<Object?> get props => [quran, hadith];
}

class DuaaHadithSource extends Equatable {
  final String rawi;
  final String mohdith;
  final String book;
  final String numberOrPage;
  final String grade;

  const DuaaHadithSource({
    required this.rawi,
    required this.mohdith,
    required this.book,
    required this.numberOrPage,
    required this.grade,
  });

  factory DuaaHadithSource.fromJson(Map<String, dynamic> json) {
    return DuaaHadithSource(
      rawi: json['rawi'] as String? ?? '',
      mohdith: json['mohdith'] as String? ?? '',
      book: json['book'] as String? ?? '',
      numberOrPage: json['numberOrPage'] as String? ?? '',
      grade: json['grade'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [rawi, mohdith, book, numberOrPage, grade];
}

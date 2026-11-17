import 'package:equatable/equatable.dart';

class HadithItemModel extends Equatable {
  final int id;
  final int idInBook;
  final int chapterId;
  final int bookId;
  final String arabic;
  final String englishNarrator;
  final String englishText;

  const HadithItemModel({
    required this.id,
    required this.idInBook,
    required this.chapterId,
    required this.bookId,
    required this.arabic,
    this.englishNarrator = '',
    this.englishText = '',
  });

  factory HadithItemModel.fromJson(Map<String, dynamic> json) {
    final eng = json['english'] as Map<String, dynamic>?;
    return HadithItemModel(
      id: json['id'] as int? ?? 0,
      idInBook: json['idInBook'] as int? ?? 0,
      chapterId: json['chapterId'] as int? ?? 0,
      bookId: json['bookId'] as int? ?? 0,
      arabic: json['arabic'] as String? ?? '',
      englishNarrator: eng?['narrator'] as String? ?? '',
      englishText: eng?['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idInBook': idInBook,
      'chapterId': chapterId,
      'bookId': bookId,
      'arabic': arabic,
      'english': {
        'narrator': englishNarrator,
        'text': englishText,
      },
    };
  }

  @override
  List<Object?> get props => [
        id,
        idInBook,
        chapterId,
        bookId,
        arabic,
        englishNarrator,
        englishText,
      ];
}


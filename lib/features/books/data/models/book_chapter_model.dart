import 'package:equatable/equatable.dart';

class BookChapterModel extends Equatable {
  final int id;
  final int bookId;
  final String arabic;
  final String english;

  const BookChapterModel({
    required this.id,
    required this.bookId,
    required this.arabic,
    required this.english,
  });

  factory BookChapterModel.fromJson(Map<String, dynamic> json) {
    return BookChapterModel(
      id: json['id'] as int? ?? 0,
      bookId: json['bookId'] as int? ?? 0,
      arabic: json['arabic'] as String? ?? '',
      english: json['english'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'arabic': arabic,
      'english': english,
    };
  }

  @override
  List<Object?> get props => [id, bookId, arabic, english];
}


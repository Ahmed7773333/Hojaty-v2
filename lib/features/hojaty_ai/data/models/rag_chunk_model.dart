import 'package:equatable/equatable.dart';

class RagChunkModel extends Equatable {
  final int id;
  final String category;
  final String sourceTitle;
  final String reference;
  final String content;
  final double similarity;

  const RagChunkModel({
    required this.id,
    required this.category,
    required this.sourceTitle,
    required this.reference,
    required this.content,
    this.similarity = 0.0,
  });

  RagChunkModel copyWith({
    int? id,
    String? category,
    String? sourceTitle,
    String? reference,
    String? content,
    double? similarity,
  }) {
    return RagChunkModel(
      id: id ?? this.id,
      category: category ?? this.category,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      reference: reference ?? this.reference,
      content: content ?? this.content,
      similarity: similarity ?? this.similarity,
    );
  }

  factory RagChunkModel.fromMap(Map<String, dynamic> map, {double similarity = 0.0}) {
    return RagChunkModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      category: map['category'] as String? ?? '',
      sourceTitle: map['source_title'] as String? ?? '',
      reference: map['reference'] as String? ?? '',
      content: map['content'] as String? ?? '',
      similarity: similarity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'source_title': sourceTitle,
      'reference': reference,
      'content': content,
      'similarity': similarity,
    };
  }

  @override
  List<Object?> get props => [id, category, sourceTitle, reference, content, similarity];
}


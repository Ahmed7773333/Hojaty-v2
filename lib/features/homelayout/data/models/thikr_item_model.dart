import 'package:equatable/equatable.dart';

class ThikrItemModel extends Equatable {
  final String id;
  final String text;
  final String reference;
  final int requiredCount;
  final String? audio;
  final String? filename;

  const ThikrItemModel({
    required this.id,
    required this.text,
    this.reference = '',
    required this.requiredCount,
    this.audio,
    this.filename,
  });

  factory ThikrItemModel.fromJson(Map<String, dynamic> json) {
    return ThikrItemModel(
      id: json['id']?.toString() ?? '0',
      text: json['text'] as String? ?? '',
      reference: '',
      requiredCount: json['count'] as int? ?? 1,
      audio: json['audio'] as String?,
      filename: json['filename'] as String?,
    );
  }

  ThikrItemModel copyWith({
    String? id,
    String? text,
    String? reference,
    int? requiredCount,
    String? audio,
    String? filename,
  }) {
    return ThikrItemModel(
      id: id ?? this.id,
      text: text ?? this.text,
      reference: reference ?? this.reference,
      requiredCount: requiredCount ?? this.requiredCount,
      audio: audio ?? this.audio,
      filename: filename ?? this.filename,
    );
  }

  @override
  List<Object?> get props => [id, text, reference, requiredCount, audio, filename];
}

// ==========================================
// ARCHIVED ORIGINAL THIKR ITEM MODEL CODE
// ==========================================
// class ThikrItemModel extends Equatable {
//   final String id;
//   final String text;
//   final String reference;
//   final int requiredCount;
// 
//   const ThikrItemModel({
//     required this.id,
//     required this.text,
//     required this.reference,
//     required this.requiredCount,
//   });
// 
//   @override
//   List<Object?> get props => [id, text, reference, requiredCount];
// }


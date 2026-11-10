import 'package:equatable/equatable.dart';

class AsmaAllahModel extends Equatable {
  final int number;
  final String arabic;
  final String transliteration;
  final String arExplanation;
  final String arMeaning;
  final String enExplanation;
  final String enMeaning;

  const AsmaAllahModel({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.arExplanation,
    required this.arMeaning,
    required this.enExplanation,
    required this.enMeaning,
  });

  factory AsmaAllahModel.fromJson(Map<String, dynamic> json, int number) {
    String extractText(List<dynamic>? list, String lang) {
      if (list == null) return '';
      for (final item in list) {
        if (item is Map && item['lang'] == lang) {
          return item['text'] as String? ?? '';
        }
      }
      return '';
    }

    final explanations = json['explanations'] as List<dynamic>?;
    final meanings = json['meanings'] as List<dynamic>?;

    return AsmaAllahModel(
      number: number,
      arabic: json['arabic'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      arExplanation: extractText(explanations, 'ar'),
      arMeaning: extractText(meanings, 'ar'),
      enExplanation: extractText(explanations, 'en'),
      enMeaning: extractText(meanings, 'en'),
    );
  }

  String getName(bool isAr) => isAr ? arabic : transliteration;

  String getMeaning(bool isAr) {
    if (isAr) {
      return arMeaning.isNotEmpty ? arMeaning : arExplanation;
    } else {
      return enExplanation.isNotEmpty ? enExplanation : enMeaning;
    }
  }

  String getExplanation(bool isAr) {
    if (isAr) {
      return arExplanation.isNotEmpty ? arExplanation : arMeaning;
    } else {
      return enMeaning.isNotEmpty ? enMeaning : enExplanation;
    }
  }

  @override
  List<Object?> get props => [
        number,
        arabic,
        transliteration,
        arExplanation,
        arMeaning,
        enExplanation,
        enMeaning,
      ];
}


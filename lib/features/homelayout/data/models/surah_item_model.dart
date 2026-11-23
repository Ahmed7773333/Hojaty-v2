import 'package:equatable/equatable.dart';

class SurahItemModel extends Equatable {
  final int number;
  final String arabicName;
  final String englishName;
  final int ayahCount;
  final bool isMeccan;
  final int pageNumber;

  const SurahItemModel({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.ayahCount,
    required this.isMeccan,
    this.pageNumber = 1,
  });

  @override
  List<Object?> get props => [
        number,
        arabicName,
        englishName,
        ayahCount,
        isMeccan,
        pageNumber,
      ];
}

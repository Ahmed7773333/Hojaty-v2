import 'package:equatable/equatable.dart';

class SurahInfoModel extends Equatable {
  final int number;
  final String name;
  final String englishName;
  final int ayahCount;
  final String revelationType; // 'Meccan' or 'Medinan'
  final String arabicRevelationType; // 'مكية' or 'مدنية'
  final int pageNumber; // Madīnah Mushaf starting page

  const SurahInfoModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.ayahCount,
    required this.revelationType,
    required this.arabicRevelationType,
    required this.pageNumber,
  });

  bool get isMeccan => revelationType.toLowerCase() == 'meccan' || arabicRevelationType == 'مكية';

  @override
  List<Object?> get props => [
        number,
        name,
        englishName,
        ayahCount,
        revelationType,
        arabicRevelationType,
        pageNumber,
      ];
}

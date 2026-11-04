import 'package:equatable/equatable.dart';

class HezbInfoModel extends Equatable {
  final int id;
  final List<int> firstQuarterVerse;
  final List<int> secondQuarterVerse;
  final List<int> thirdQuarterVerse;
  final List<int> fourthQuarterVerse;

  const HezbInfoModel({
    required this.id,
    required this.firstQuarterVerse,
    required this.secondQuarterVerse,
    required this.thirdQuarterVerse,
    required this.fourthQuarterVerse,
  });

  @override
  List<Object?> get props => [
        id,
        firstQuarterVerse,
        secondQuarterVerse,
        thirdQuarterVerse,
        fourthQuarterVerse,
      ];
}

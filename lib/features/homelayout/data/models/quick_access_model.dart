import 'package:equatable/equatable.dart';

enum QuickAccessType {
  quran,
  athkar,
  occasions,
  prayerTimes,
  radio,
  books,
  sebha
}

class QuickAccessModel extends Equatable {
  final QuickAccessType type;
  final String Function(dynamic s) titleResolver;
  final String Function(dynamic s) subtitleResolver;

  const QuickAccessModel({
    required this.type,
    required this.titleResolver,
    required this.subtitleResolver,
  });

  @override
  List<Object?> get props => [type];
}

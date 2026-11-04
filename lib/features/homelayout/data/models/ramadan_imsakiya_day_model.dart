import 'package:equatable/equatable.dart';

class RamadanImsakiyaDayModel extends Equatable {
  final int dayNumber;
  final DateTime date;
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final bool isCurrentDay;

  const RamadanImsakiyaDayModel({
    required this.dayNumber,
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.isCurrentDay = false,
  });

  @override
  List<Object?> get props => [
        dayNumber,
        date,
        fajr,
        dhuhr,
        asr,
        maghrib,
        isha,
        isCurrentDay,
      ];
}

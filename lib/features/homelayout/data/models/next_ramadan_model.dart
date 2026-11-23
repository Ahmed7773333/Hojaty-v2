import 'package:equatable/equatable.dart';

class NextRamadanModel extends Equatable {
  final String date;
  final String timeLeft;

  const NextRamadanModel({
    required this.date,
    required this.timeLeft,
  });

  /// Parse date format DD-MM-YYYY to DateTime
  DateTime get targetDateTime {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    // Fallback: 2027-02-08
    return DateTime(2027, 2, 8);
  }

  /// Formats remaining time in localized months and days (e.g. "5 أشهر و 12 يوم" or "5 months 12 days")
  String formattedTimeLeft({required String language}) {
    final now = DateTime.now();
    final target = targetDateTime;
    if (target.isBefore(now)) return '';

    int months = (target.year - now.year) * 12 + target.month - now.month;
    int days = target.day - now.day;

    if (days < 0) {
      months -= 1;
      final prevMonthLastDay = DateTime(target.year, target.month, 0).day;
      days += prevMonthLastDay;
    }

    if (language == 'ar') {
      if (months > 0 && days > 0) {
        return '$months أشهر و $days يوم';
      } else if (months > 0) {
        return '$months أشهر';
      } else {
        return '$days يوم';
      }
    } else {
      if (months > 0 && days > 0) {
        return '$months months $days days';
      } else if (months > 0) {
        return '$months months';
      } else {
        return '$days days';
      }
    }
  }

  factory NextRamadanModel.fromJson(Map<String, dynamic> json) {
    return NextRamadanModel(
      date: json['date'] as String? ?? '08-02-2027',
      timeLeft: json['timeLeft'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'timeLeft': timeLeft,
    };
  }

  factory NextRamadanModel.fallback() {
    return const NextRamadanModel(
      date: '08-02-2027',
      timeLeft: '5mo 17d left',
    );
  }

  @override
  List<Object?> get props => [date, timeLeft];
}

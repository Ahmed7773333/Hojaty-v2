import 'package:equatable/equatable.dart';

class HijriDayModel extends Equatable {
  final String title;
  final int number;

  const HijriDayModel({required this.title, required this.number});

  factory HijriDayModel.fromJson(Map<String, dynamic> json) {
    return HijriDayModel(
      title: json['title'] as String? ?? '',
      number: (json['number'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'number': number};
  }

  @override
  List<Object?> get props => [title, number];
}

class HijriMonthModel extends Equatable {
  final int number;
  final String title;

  const HijriMonthModel({required this.number, required this.title});

  factory HijriMonthModel.fromJson(Map<String, dynamic> json) {
    return HijriMonthModel(
      number: (json['number'] as num?)?.toInt() ?? 1,
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'number': number, 'title': title};
  }

  @override
  List<Object?> get props => [number, title];
}

class HijriDateModel extends Equatable {
  final String date;
  final String format;
  final HijriDayModel day;
  final HijriMonthModel month;
  final String year;

  const HijriDateModel({
    required this.date,
    required this.format,
    required this.day,
    required this.month,
    required this.year,
  });

  int get yearNumber => int.tryParse(year) ?? 1448;
  int get monthNumber => month.number;
  int get dayNumber => day.number;

  factory HijriDateModel.fromJson(Map<String, dynamic> json) {
    return HijriDateModel(
      date: json['date'] as String? ?? '',
      format: json['format'] as String? ?? 'DD-MM-YYYY',
      day: json['day'] is Map<String, dynamic>
          ? HijriDayModel.fromJson(json['day'] as Map<String, dynamic>)
          : const HijriDayModel(title: '', number: 1),
      month: json['month'] is Map<String, dynamic>
          ? HijriMonthModel.fromJson(json['month'] as Map<String, dynamic>)
          : const HijriMonthModel(number: 1, title: ''),
      year: json['year']?.toString() ?? '1448',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'format': format,
      'day': day.toJson(),
      'month': month.toJson(),
      'year': year,
    };
  }

  factory HijriDateModel.fallback({required String language}) {
    final isArabic = language == 'ar';
    return HijriDateModel(
      date: '12-03-1448',
      format: 'DD-MM-YYYY',
      day: HijriDayModel(
        title: isArabic ? 'الثلاثاء' : 'Al Thalaata',
        number: 12,
      ),
      month: HijriMonthModel(
        number: 3,
        title: isArabic ? 'ربيع الأول' : 'Rabīʿ al-awwal',
      ),
      year: '1448',
    );
  }

  @override
  List<Object?> get props => [date, format, day, month, year];

  String get formatted => '${day.title}، ${day.number} ${month.title} $year';
}

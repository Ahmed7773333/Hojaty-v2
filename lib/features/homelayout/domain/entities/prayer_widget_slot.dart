import 'package:equatable/equatable.dart';

class PrayerWidgetSlot extends Equatable {
  final String key;
  final String nameAr;
  final String nameEn;
  final String timeFormattedAr;
  final String timeFormattedEn;
  final int timestampMs;

  const PrayerWidgetSlot({
    required this.key,
    required this.nameAr,
    required this.nameEn,
    required this.timeFormattedAr,
    required this.timeFormattedEn,
    required this.timestampMs,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'timeFormattedAr': timeFormattedAr,
      'timeFormattedEn': timeFormattedEn,
      'timestampMs': timestampMs,
    };
  }

  factory PrayerWidgetSlot.fromJson(Map<String, dynamic> json) {
    return PrayerWidgetSlot(
      key: json['key'] as String? ?? 'fajr',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      timeFormattedAr: json['timeFormattedAr'] as String? ?? '',
      timeFormattedEn: json['timeFormattedEn'] as String? ?? '',
      timestampMs: (json['timestampMs'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    key,
    nameAr,
    nameEn,
    timeFormattedAr,
    timeFormattedEn,
    timestampMs,
  ];
}

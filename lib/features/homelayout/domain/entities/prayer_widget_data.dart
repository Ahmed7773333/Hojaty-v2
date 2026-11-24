import 'package:equatable/equatable.dart';
import 'package:hojaty/features/homelayout/domain/entities/prayer_widget_slot.dart';

class PrayerWidgetData extends Equatable {
  final String nextPrayerKey;
  final String nextPrayerNameAr;
  final String nextPrayerNameEn;
  final String nextPrayerTimeFormatted;
  final int nextPrayerTimestampMs;
  final String locationName;
  final String hijriDate;
  final String language;
  final List<PrayerWidgetSlot> schedule;

  const PrayerWidgetData({
    required this.nextPrayerKey,
    required this.nextPrayerNameAr,
    required this.nextPrayerNameEn,
    required this.nextPrayerTimeFormatted,
    required this.nextPrayerTimestampMs,
    required this.locationName,
    required this.hijriDate,
    required this.language,
    required this.schedule,
  });

  @override
  List<Object?> get props => [
    nextPrayerKey,
    nextPrayerNameAr,
    nextPrayerNameEn,
    nextPrayerTimeFormatted,
    nextPrayerTimestampMs,
    locationName,
    hijriDate,
    language,
    schedule,
  ];
}

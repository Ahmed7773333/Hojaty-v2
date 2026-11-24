import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/features/homelayout/data/models/hijri_date_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/domain/entities/prayer_widget_data.dart';
import 'package:hojaty/features/homelayout/domain/entities/prayer_widget_slot.dart';
import 'package:hojaty/features/homelayout/domain/repositories/prayer_widget_repository.dart';

class SyncPrayerWidgetUseCase {
  final PrayerWidgetRepository repository;

  const SyncPrayerWidgetUseCase(this.repository);

  Future<void> call({
    String? language,
    String? locationName,
    HijriDateModel? hijriDate,
    GeoCoordinates? coordinates,
    DateTime? now,
  }) async {
    final currentTime = now ?? DateTime.now();
    final lang = language ?? UserHiveHelper.getUser()?.language ?? 'ar';
    final coords = coordinates ?? UserHiveHelper.getCachedCoordinates();
    final params = UserHiveHelper.getPrayerCalculationParameters(coords);
    final helper = PrayersHelper(coordinates: coords, parameters: params);

    final schedule = _buildTwoDaySchedule(helper, currentTime);
    final nextSlot = schedule.firstWhere(
      (slot) => slot.timestampMs > currentTime.millisecondsSinceEpoch,
      orElse: () => schedule.last,
    );

    final resolvedLocation = (locationName != null && locationName.isNotEmpty)
        ? locationName
        : UserHiveHelper.getCachedPrayerCityName(
            defaultValue: lang == 'ar' ? 'القاهرة' : 'Cairo',
          );

    final briefHijri = _formatBriefHijriDate(hijriDate, lang);

    final payload = PrayerWidgetData(
      nextPrayerKey: nextSlot.key,
      nextPrayerNameAr: nextSlot.nameAr,
      nextPrayerNameEn: nextSlot.nameEn,
      nextPrayerTimeFormatted: lang == 'ar'
          ? nextSlot.timeFormattedAr
          : nextSlot.timeFormattedEn,
      nextPrayerTimestampMs: nextSlot.timestampMs,
      locationName: resolvedLocation,
      hijriDate: briefHijri,
      language: lang,
      schedule: schedule,
    );

    await repository.syncPrayerWidget(payload);
  }

  List<PrayerWidgetSlot> _buildTwoDaySchedule(
    PrayersHelper helper,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final slots = <PrayerWidgetSlot>[
      ..._buildDaySlots(helper, today),
      ..._buildDaySlots(helper, tomorrow),
    ];
    slots.sort((a, b) => a.timestampMs.compareTo(b.timestampMs));
    return slots;
  }

  List<PrayerWidgetSlot> _buildDaySlots(PrayersHelper helper, DateTime day) {
    final times = helper.getPrayerDateTimes(day);
    final sunrise = helper.getSunriseDateTime(day);

    return [
      _createPrayerSlot(PrayerType.fajr, times[PrayerType.fajr]!),
      _createSunriseSlot(sunrise),
      _createPrayerSlot(PrayerType.dhuhr, times[PrayerType.dhuhr]!),
      _createPrayerSlot(PrayerType.asr, times[PrayerType.asr]!),
      _createPrayerSlot(PrayerType.maghrib, times[PrayerType.maghrib]!),
      _createPrayerSlot(PrayerType.isha, times[PrayerType.isha]!),
    ];
  }

  PrayerWidgetSlot _createPrayerSlot(PrayerType type, DateTime time) {
    final baseNameAr = PrayersHelper.getPrayerName(type, language: 'ar');
    final nameEn = PrayersHelper.getPrayerName(type, language: 'en');
    return PrayerWidgetSlot(
      key: type.name,
      nameAr: 'صلاة $baseNameAr',
      nameEn: nameEn,
      timeFormattedAr: PrayersHelper.formatTimeTo12Hour(time, language: 'ar'),
      timeFormattedEn: PrayersHelper.formatTimeTo12Hour(time, language: 'en'),
      timestampMs: time.millisecondsSinceEpoch,
    );
  }

  PrayerWidgetSlot _createSunriseSlot(DateTime time) {
    return PrayerWidgetSlot(
      key: 'sunrise',
      nameAr: 'الشروق',
      nameEn: 'Sunrise',
      timeFormattedAr: PrayersHelper.formatTimeTo12Hour(time, language: 'ar'),
      timeFormattedEn: PrayersHelper.formatTimeTo12Hour(time, language: 'en'),
      timestampMs: time.millisecondsSinceEpoch,
    );
  }

  String _formatBriefHijriDate(HijriDateModel? hijriDate, String language) {
    if (hijriDate == null) return '';
    final suffix = language == 'ar' ? 'هـ' : 'AH';
    if (hijriDate.month.title.isEmpty) return '';
    return '${hijriDate.day.number} ${hijriDate.month.title} ${hijriDate.year} $suffix';
  }
}

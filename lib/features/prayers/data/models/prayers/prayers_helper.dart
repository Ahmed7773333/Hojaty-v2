import 'package:adhan_dart/adhan_dart.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../home/data/models/user_db.dart';
import '../../../../home/data/models/user_db_helper.dart';

class PrayersHelper {
  final User user = UserDbHelper.getById()!;
  final now = DateTime.now();
  PrayerTimes getPrayerTimes(date) {
    CalculationParameters params = CalculationMethodParameters.egyptian();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes(
      coordinates: user.uiLastKnownLocation,
      date: date,
      calculationParameters: params,
      precision: true,
    );
    return prayerTimes;
  }

  /// Calculates prayer times for today.
  Future<Map<String, DateTime>> getTodayPrayerTimes() async {
    final prayerTimes = getPrayerTimes(now);

    // Filter and map only relevant times
    final times = {
      'الفجر': prayerTimes.fajr.toLocal(),
      'الشروق': prayerTimes.sunrise.toLocal(),
      'الظهر': prayerTimes.dhuhr.toLocal(),
      'العصر': prayerTimes.asr.toLocal(),
      'المغرب': prayerTimes.maghrib.toLocal(),
      'العشاء': prayerTimes.isha.toLocal(),
    };

    return times;
  }

  /// Finds the next prayer time and its name.
  Future<MapEntry<String, DateTime>?> getNextPrayerTime(
    Map<String, DateTime> times,
  ) async {
    final prayerTimes = getPrayerTimes(now);

    MapEntry<String, DateTime>? next;

    next = MapEntry(
      prayerTimes.nextPrayer().name,
      prayerTimes.timeForPrayer(prayerTimes.nextPrayer()).toLocal(),
    );
    return next;
  }

  /// Converts 24-hour DateTime to 12-hour formatted string (e.g., "05:30 ص").
  static String formatTimeTo12Hour(DateTime time) {
    // 'ar' locale will format the AM/PM markers correctly (ص/م)
    return DateFormat('hh:mm a', 'ar').format(time);
  }

  /// Gets the current Hijri date (Arabic).
  static String getHijriDateArabic() {
    final hijri = HijriCalendarConfig.now();
    // Format: Day Name Day Number of Month Name Year
    return hijri.getDayName();
  }

  /// Gets the current Gregorian date (Arabic formatted weekday).
  static String getGregorianWeekdayArabic() {
    final now = DateTime.now();
    // EEEE for full weekday name in Arabic
    return DateFormat('EEEE', 'ar').format(now);
  }
}

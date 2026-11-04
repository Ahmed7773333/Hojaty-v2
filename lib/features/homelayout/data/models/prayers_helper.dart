import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'prayer_time_model.dart';
import 'ramadan_imsakiya_day_model.dart';

/// Calculation method for Islamic prayer times.
enum CalculationMethod {
  egyptian, // Egyptian General Authority of Survey (Fajr 19.5°, Isha 17.5°)
  ummAlQura, // Umm Al-Qura, Makkah (Fajr 18.5°, Isha 90 min / 120 in Ramadan)
  muslimWorldLeague, // MWL (Fajr 18°, Isha 17°)
  karachi, // University of Islamic Sciences, Karachi (Fajr 18°, Isha 18°)
  isna, // Islamic Society of North America (Fajr 15°, Isha 15°)
}

/// Madhab for Asr calculation (shadow length ratio).
enum AsrMadhab {
  shafi, // Standard (Shadow factor = 1)
  hanafi, // Hanafi (Shadow factor = 2)
}

/// Geographic coordinates for prayer calculations.
class GeoCoordinates {
  final double latitude;
  final double longitude;

  const GeoCoordinates(this.latitude, this.longitude);

  static const GeoCoordinates cairo = GeoCoordinates(30.0444, 31.2357);
  static const GeoCoordinates alexandria = GeoCoordinates(31.2001, 29.9187);
  static const GeoCoordinates giza = GeoCoordinates(30.0131, 31.2089);
  static const GeoCoordinates makkah = GeoCoordinates(21.4225, 39.8262);
  static const GeoCoordinates madinah = GeoCoordinates(24.5247, 39.5692);
  static const GeoCoordinates riyadh = GeoCoordinates(24.7136, 46.6753);
}

/// Calculation parameters for prayer times.
class CalculationParameters {
  final double fajrAngle;
  final double ishaAngle;
  final int ishaIntervalMinutes; // If > 0, Isha is calculated as Maghrib + minutes
  final CalculationMethod method;
  final AsrMadhab madhab;

  const CalculationParameters({
    required this.fajrAngle,
    required this.ishaAngle,
    this.ishaIntervalMinutes = 0,
    this.method = CalculationMethod.egyptian,
    this.madhab = AsrMadhab.shafi,
  });

  factory CalculationParameters.egyptian({AsrMadhab madhab = AsrMadhab.shafi}) {
    return CalculationParameters(
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      method: CalculationMethod.egyptian,
      madhab: madhab,
    );
  }

  factory CalculationParameters.ummAlQura({AsrMadhab madhab = AsrMadhab.shafi}) {
    return CalculationParameters(
      fajrAngle: 18.5,
      ishaAngle: 0.0,
      ishaIntervalMinutes: 90,
      method: CalculationMethod.ummAlQura,
      madhab: madhab,
    );
  }

  factory CalculationParameters.muslimWorldLeague({
    AsrMadhab madhab = AsrMadhab.shafi,
  }) {
    return CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 17.0,
      method: CalculationMethod.muslimWorldLeague,
      madhab: madhab,
    );
  }

  factory CalculationParameters.karachi({AsrMadhab madhab = AsrMadhab.shafi}) {
    return CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 18.0,
      method: CalculationMethod.karachi,
      madhab: madhab,
    );
  }
}

/// High-precision Astronomical Solar Prayer Times Helper in Pure Dart.
class PrayersHelper {
  final GeoCoordinates coordinates;
  final CalculationParameters parameters;

  const PrayersHelper({
    this.coordinates = GeoCoordinates.cairo,
    CalculationParameters? parameters,
  }) : parameters = parameters ??
            const CalculationParameters(
              fajrAngle: 19.5,
              ishaAngle: 17.5,
              method: CalculationMethod.egyptian,
              madhab: AsrMadhab.shafi,
            );

  // ---------------------------------------------------------------------------
  // Astronomical Solar Mathematics
  // ---------------------------------------------------------------------------

  static double _degToRad(double deg) => deg * (math.pi / 180.0);
  static double _radToDeg(double rad) => rad * (180.0 / math.pi);

  static double _sinDeg(double deg) => math.sin(_degToRad(deg));
  static double _cosDeg(double deg) => math.cos(_degToRad(deg));
  static double _tanDeg(double deg) => math.tan(_degToRad(deg));
  static double _asinDeg(double x) => _radToDeg(math.asin(x.clamp(-1.0, 1.0)));
  static double _acosDeg(double x) => _radToDeg(math.acos(x.clamp(-1.0, 1.0)));
  static double _atanDeg(double x) => _radToDeg(math.atan(x));

  static double _fixAngle(double a) {
    a = a - 360.0 * (a / 360.0).floorToDouble();
    return a < 0 ? a + 360.0 : a;
  }

  static double _fixHour(double a) {
    a = a - 24.0 * (a / 24.0).floorToDouble();
    return a < 0 ? a + 24.0 : a;
  }

  static double _julianDate(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final a = (year / 100.0).floorToDouble();
    final b = 2.0 - a + (a / 4.0).floorToDouble();
    return (365.25 * (year + 4716)).floorToDouble() +
        (30.6001 * (month + 1)).floorToDouble() +
        day +
        b -
        1524.5;
  }

  /// Calculates Solar Declination and Equation of Time.
  static ({double declination, double equationOfTime}) _sunPosition(double jd) {
    final d = jd - 2451545.0;
    final g = _fixAngle(357.529 + 0.98560028 * d);
    final q = _fixAngle(280.459 + 0.98564736 * d);
    final l = _fixAngle(q + 1.915 * _sinDeg(g) + 0.020 * _sinDeg(2 * g));

    final e = 23.439 - 0.00000036 * d;
    final ra = _atanDeg(_cosDeg(e) * _tanDeg(l)) / 15.0;
    var raAdjusted = _fixHour(ra);

    final lQuadrant = (l / 90.0).floor() * 90.0;
    final raQuadrant = (raAdjusted * 15.0 / 90.0).floor() * 90.0;
    raAdjusted = raAdjusted + (lQuadrant - raQuadrant) / 15.0;

    final decl = _asinDeg(_sinDeg(e) * _sinDeg(l));
    final eqt = q / 15.0 - _fixHour(raAdjusted);

    return (declination: decl, equationOfTime: eqt);
  }

  /// Base calculation of prayer times as decimal hours in UTC.
  Map<String, double> _calculateTimes(DateTime date) {
    final jd = _julianDate(date.year, date.month, date.day);
    final sun = _sunPosition(jd);

    final decl = sun.declination;
    final eqt = sun.equationOfTime;
    final lat = coordinates.latitude;
    final lng = coordinates.longitude;

    // Solar noon in UTC hours
    final noon = _fixHour(12.0 - eqt - lng / 15.0);

    // Sun altitude for sunrise/sunset (refraction + radius = 0.833°)
    final sunAltitude = 0.833;

    // Hour angle for sunrise/sunset
    final sunriseHourAngle = (1.0 / 15.0) *
        _acosDeg(
          (-_sinDeg(sunAltitude) - _sinDeg(lat) * _sinDeg(decl)) /
              (_cosDeg(lat) * _cosDeg(decl)),
        );

    final sunrise = noon - sunriseHourAngle;
    final sunset = noon + sunriseHourAngle;

    // Fajr
    final fajrHourAngle = (1.0 / 15.0) *
        _acosDeg(
          (-_sinDeg(parameters.fajrAngle) - _sinDeg(lat) * _sinDeg(decl)) /
              (_cosDeg(lat) * _cosDeg(decl)),
        );
    final fajr = noon - fajrHourAngle;

    // Asr
    final shadowFactor = parameters.madhab == AsrMadhab.hanafi ? 2.0 : 1.0;
    final asrAltitude =
        -_atanDeg(1.0 / (shadowFactor + _tanDeg((lat - decl).abs())));
    final asrHourAngle = (1.0 / 15.0) *
        _acosDeg(
          (-_sinDeg(asrAltitude) - _sinDeg(lat) * _sinDeg(decl)) /
              (_cosDeg(lat) * _cosDeg(decl)),
        );
    final asr = noon + asrHourAngle;

    // Maghrib
    final maghrib = sunset;

    // Isha
    double isha;
    if (parameters.ishaIntervalMinutes > 0) {
      isha = maghrib + parameters.ishaIntervalMinutes / 60.0;
    } else {
      final ishaHourAngle = (1.0 / 15.0) *
          _acosDeg(
            (-_sinDeg(parameters.ishaAngle) - _sinDeg(lat) * _sinDeg(decl)) /
                (_cosDeg(lat) * _cosDeg(decl)),
          );
      isha = noon + ishaHourAngle;
    }

    return {
      'fajr': _fixHour(fajr),
      'sunrise': _fixHour(sunrise),
      'dhuhr': _fixHour(noon),
      'asr': _fixHour(asr),
      'maghrib': _fixHour(maghrib),
      'isha': _fixHour(isha),
    };
  }

  /// Converts UTC decimal hours to a local DateTime on the target date.
  DateTime _hourToDateTime(DateTime date, double decimalHour) {
    final totalSeconds = (decimalHour * 3600.0).round();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final utcTime = DateTime.utc(
      date.year,
      date.month,
      date.day,
      hours,
      minutes,
      seconds,
    );
    final localTime = utcTime.toLocal();

    // Anchor strictly to the requested local date with calculated local clock time
    return DateTime(
      date.year,
      date.month,
      date.day,
      localTime.hour,
      localTime.minute,
      localTime.second,
    );
  }

  /// Calculates all prayer times for a given date.
  Map<PrayerType, DateTime> getPrayerDateTimes(DateTime date) {
    final hours = _calculateTimes(date);
    return {
      PrayerType.fajr: _hourToDateTime(date, hours['fajr']!),
      PrayerType.dhuhr: _hourToDateTime(date, hours['dhuhr']!),
      PrayerType.asr: _hourToDateTime(date, hours['asr']!),
      PrayerType.maghrib: _hourToDateTime(date, hours['maghrib']!),
      PrayerType.isha: _hourToDateTime(date, hours['isha']!),
    };
  }

  /// Calculates sunrise time for a given date.
  DateTime getSunriseDateTime(DateTime date) {
    final hours = _calculateTimes(date);
    return _hourToDateTime(date, hours['sunrise']!);
  }

  /// Finds the next prayer, previous prayer, and next prayer DateTime.
  ({
    PrayerType nextType,
    DateTime nextTime,
    PrayerType previousType,
    DateTime previousTime,
  }) getNextPrayerInfo(DateTime now) {
    final todayPrayers = getPrayerDateTimes(now);

    final fajr = todayPrayers[PrayerType.fajr]!;
    final dhuhr = todayPrayers[PrayerType.dhuhr]!;
    final asr = todayPrayers[PrayerType.asr]!;
    final maghrib = todayPrayers[PrayerType.maghrib]!;
    final isha = todayPrayers[PrayerType.isha]!;

    if (now.isBefore(fajr)) {
      // Before Fajr: previous is yesterday's Isha, next is today's Fajr
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayIsha = getPrayerDateTimes(yesterday)[PrayerType.isha]!;
      return (
        nextType: PrayerType.fajr,
        nextTime: fajr,
        previousType: PrayerType.isha,
        previousTime: yesterdayIsha,
      );
    } else if (now.isBefore(dhuhr)) {
      return (
        nextType: PrayerType.dhuhr,
        nextTime: dhuhr,
        previousType: PrayerType.fajr,
        previousTime: fajr,
      );
    } else if (now.isBefore(asr)) {
      return (
        nextType: PrayerType.asr,
        nextTime: asr,
        previousType: PrayerType.dhuhr,
        previousTime: dhuhr,
      );
    } else if (now.isBefore(maghrib)) {
      return (
        nextType: PrayerType.maghrib,
        nextTime: maghrib,
        previousType: PrayerType.asr,
        previousTime: asr,
      );
    } else if (now.isBefore(isha)) {
      return (
        nextType: PrayerType.isha,
        nextTime: isha,
        previousType: PrayerType.maghrib,
        previousTime: maghrib,
      );
    } else {
      // After Isha: next is tomorrow's Fajr
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowFajr = getPrayerDateTimes(tomorrow)[PrayerType.fajr]!;
      return (
        nextType: PrayerType.fajr,
        nextTime: tomorrowFajr,
        previousType: PrayerType.isha,
        previousTime: isha,
      );
    }
  }

  /// Finds the currently active prayer window (15 minutes before to 15 minutes after prayer time).
  /// Returns null if [now] is outside all prayer windows.
  ({
    PrayerType type,
    DateTime prayerTime,
    DateTime windowStart,
    DateTime windowEnd,
    bool isPreAdhan,
    bool isPostAdhan,
  })? getActivePrayerWindow(DateTime now) {
    final todayPrayers = getPrayerDateTimes(now);

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayIsha = getPrayerDateTimes(yesterday)[PrayerType.isha]!;

    final tomorrow = now.add(const Duration(days: 1));
    final tomorrowFajr = getPrayerDateTimes(tomorrow)[PrayerType.fajr]!;

    final candidatePrayers = <({PrayerType type, DateTime time})>[
      (type: PrayerType.isha, time: yesterdayIsha),
      (type: PrayerType.fajr, time: todayPrayers[PrayerType.fajr]!),
      (type: PrayerType.dhuhr, time: todayPrayers[PrayerType.dhuhr]!),
      (type: PrayerType.asr, time: todayPrayers[PrayerType.asr]!),
      (type: PrayerType.maghrib, time: todayPrayers[PrayerType.maghrib]!),
      (type: PrayerType.isha, time: todayPrayers[PrayerType.isha]!),
      (type: PrayerType.fajr, time: tomorrowFajr),
    ];

    for (final item in candidatePrayers) {
      final windowStart = item.time.subtract(const Duration(minutes: 15));
      final windowEnd = item.time.add(const Duration(minutes: 15));

      if (!now.isBefore(windowStart) && !now.isAfter(windowEnd)) {
        final isPre = now.isBefore(item.time);
        return (
          type: item.type,
          prayerTime: item.time,
          windowStart: windowStart,
          windowEnd: windowEnd,
          isPreAdhan: isPre,
          isPostAdhan: !isPre,
        );
      }
    }

    return null;
  }

  /// Calculates progress (0.0 to 1.0) towards the next prayer.
  static double calculatePrayerProgress({
    required DateTime now,
    required DateTime previousTime,
    required DateTime nextTime,
  }) {
    final totalMillis =
        nextTime.millisecondsSinceEpoch - previousTime.millisecondsSinceEpoch;
    if (totalMillis <= 0) return 0.0;
    final elapsedMillis =
        now.millisecondsSinceEpoch - previousTime.millisecondsSinceEpoch;
    return (elapsedMillis / totalMillis).clamp(0.0, 1.0);
  }

  /// Generates PrayerTimeModel list for a specific date and notification settings.
  List<PrayerTimeModel> generatePrayerList({
    required DateTime date,
    required DateTime now,
    Map<PrayerType, bool>? notificationOverrides,
    Map<PrayerType, ({String? start, String? end})>? windowOverrides,
  }) {
    final times = getPrayerDateTimes(date);
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    return PrayerType.values.map((type) {
      final prayerDateTime = times[type]!;
      final isNotif = notificationOverrides?[type] ?? true;

      // Dynamic 15-minute window before and after prayer time
      final startWindowDt =
          prayerDateTime.subtract(const Duration(minutes: 15));
      final endWindowDt = prayerDateTime.add(const Duration(minutes: 15));

      final isNext = isToday &&
          !now.isBefore(startWindowDt) &&
          now.isBefore(prayerDateTime);

      final isCurrent = isToday &&
          !now.isBefore(prayerDateTime) &&
          !now.isAfter(endWindowDt);

      final startOverride = windowOverrides?[type]?.start;
      final endOverride = windowOverrides?[type]?.end;

      final startStr = (startOverride != null && startOverride.isNotEmpty)
          ? startOverride
          : formatTimeTo12Hour(startWindowDt, language: 'ar');
      final endStr = (endOverride != null && endOverride.isNotEmpty)
          ? endOverride
          : formatTimeTo12Hour(endWindowDt, language: 'ar');

      return PrayerTimeModel(
        type: type,
        time: formatTimeTo24Hour(prayerDateTime),
        dateTime: prayerDateTime,
        isNotificationEnabled: isNotif,
        isCurrent: isCurrent,
        isNext: isNext,
        startWindow: startStr,
        endWindow: endStr,
      );
    }).toList();
  }

  /// Formats DateTime to 12-hour formatted string (e.g. "05:30 ص" or "05:30 AM").
  static String formatTimeTo12Hour(DateTime time, {String language = 'ar'}) {
    return DateFormat('hh:mm a', language).format(time);
  }

  /// Formats DateTime to 24-hour formatted string (e.g. "05:30").
  static String formatTimeTo24Hour(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Formats day offset (0 = اليوم, 1 = غداً, -1 = أمس, etc.).
  static String formatDayOffset(int offset, DateTime date, {String language = 'ar'}) {
    if (offset == 0) {
      return language == 'ar' ? 'اليوم' : 'Today';
    } else if (offset == 1) {
      return language == 'ar' ? 'غداً' : 'Tomorrow';
    } else if (offset == -1) {
      return language == 'ar' ? 'أمس' : 'Yesterday';
    } else {
      return DateFormat('EEEE d MMMM', language).format(date);
    }
  }

  /// Gets localized prayer name.
  static String getPrayerName(PrayerType type, {String language = 'ar'}) {
    if (language == 'ar') {
      switch (type) {
        case PrayerType.fajr:
          return 'الفجر';
        case PrayerType.dhuhr:
          return 'الظهر';
        case PrayerType.asr:
          return 'العصر';
        case PrayerType.maghrib:
          return 'المغرب';
        case PrayerType.isha:
          return 'العشاء';
      }
    } else {
      switch (type) {
        case PrayerType.fajr:
          return 'Fajr';
        case PrayerType.dhuhr:
          return 'Dhuhr';
        case PrayerType.asr:
          return 'Asr';
        case PrayerType.maghrib:
          return 'Maghrib';
        case PrayerType.isha:
          return 'Isha';
      }
    }
  }

  /// Generates the full 30-day Ramadan Imsakiya prayer times schedule.
  List<RamadanImsakiyaDayModel> generateRamadanImsakiya({
    required DateTime ramadanStartDate,
    DateTime? now,
    int daysCount = 30,
  }) {
    final currentDate = now ?? DateTime.now();
    final result = <RamadanImsakiyaDayModel>[];

    for (int i = 0; i < daysCount; i++) {
      final targetDate = ramadanStartDate.add(Duration(days: i));
      final times = getPrayerDateTimes(targetDate);
      final isCurrent = targetDate.year == currentDate.year &&
          targetDate.month == currentDate.month &&
          targetDate.day == currentDate.day;

      result.add(
        RamadanImsakiyaDayModel(
          dayNumber: i + 1,
          date: targetDate,
          fajr: times[PrayerType.fajr]!,
          dhuhr: times[PrayerType.dhuhr]!,
          asr: times[PrayerType.asr]!,
          maghrib: times[PrayerType.maghrib]!,
          isha: times[PrayerType.isha]!,
          isCurrentDay: isCurrent,
        ),
      );
    }

    return result;
  }
}

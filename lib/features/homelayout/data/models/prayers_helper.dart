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
  dubai, // UAE / Dubai (Fajr 18.2°, Isha 18.2°)
  qatar, // Qatar (Fajr 18°, Isha 90 min)
  kuwait, // Kuwait (Fajr 18°, Isha 17.5°)
  turkey, // Diyanet, Turkey (Fajr 18°, Isha 17°)
  singapore, // MUIS Singapore / JAKIM Malaysia / Indonesia (Fajr 20°, Isha 18°)
  northAfrica, // Morocco / Algeria / Tunisia (Fajr 18°, Isha 17°)
}

/// Madhab for Asr calculation (shadow length ratio).
enum AsrMadhab {
  shafi, // Standard: Shafi'i, Maliki, Hanbali (Shadow factor = 1)
  hanafi, // Hanafi (Shadow factor = 2)
}

/// High latitude adjustment rules for locations where twilight persists.
enum HighLatitudeRule {
  none, // No adjustment
  middleOfTheNight, // Fajr/Isha capped at 1/2 of night duration
  seventhOfTheNight, // Fajr/Isha capped at 1/7 of night duration
  angleBased, // Fajr/Isha capped at (angle / 60) of night duration
  auto, // Automatically uses seventhOfTheNight (>=48°) or angleBased (<48°)
}

/// Per-prayer manual minute adjustments (precautionary or custom offsets).
class PrayerAdjustments {
  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;

  const PrayerAdjustments({
    this.fajr = 0,
    this.sunrise = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
  });
}

/// Geographic coordinates for prayer calculations.
class GeoCoordinates {
  final double latitude;
  final double longitude;

  /// Optional explicit UTC offset in hours (e.g. 2.0 for EET, 3.0 for Makkah, -5.0 for EST).
  /// When null, PrayersHelper resolves the timezone automatically for the target coordinates.
  final double? utcOffsetHours;

  /// Optional observer elevation in meters above sea level (used for horizon dip correction).
  final double elevation;

  const GeoCoordinates(
    this.latitude,
    this.longitude, {
    this.utcOffsetHours,
    this.elevation = 0.0,
  });

  static const GeoCoordinates cairo = GeoCoordinates(30.0444, 31.2357);
  static const GeoCoordinates alexandria = GeoCoordinates(31.2001, 29.9187);
  static const GeoCoordinates giza = GeoCoordinates(30.0131, 31.2089);
  static const GeoCoordinates makkah = GeoCoordinates(
    21.4225,
    39.8262,
    utcOffsetHours: 3.0,
  );
  static const GeoCoordinates madinah = GeoCoordinates(
    24.5247,
    39.5692,
    utcOffsetHours: 3.0,
  );
  static const GeoCoordinates riyadh = GeoCoordinates(
    24.7136,
    46.6753,
    utcOffsetHours: 3.0,
  );
}

/// Calculation parameters for prayer times.
class CalculationParameters {
  final double fajrAngle;
  final double ishaAngle;
  final int ishaIntervalMinutes; // If > 0, Isha is calculated as Maghrib + minutes
  final double maghribAngle; // If > 0, Maghrib is calculated by angle instead of sunset
  final int dhuhrMinutes; // Minutes added after solar zenith for Dhuhr
  final CalculationMethod method;
  final AsrMadhab madhab;
  final HighLatitudeRule highLatitudeRule;
  final PrayerAdjustments adjustments;

  const CalculationParameters({
    required this.fajrAngle,
    required this.ishaAngle,
    this.ishaIntervalMinutes = 0,
    this.maghribAngle = 0.0,
    this.dhuhrMinutes = 0,
    this.method = CalculationMethod.egyptian,
    this.madhab = AsrMadhab.shafi,
    this.highLatitudeRule = HighLatitudeRule.auto,
    this.adjustments = const PrayerAdjustments(),
  });

  factory CalculationParameters.egyptian({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      method: CalculationMethod.egyptian,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.ummAlQura({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 18.5,
      ishaAngle: 0.0,
      ishaIntervalMinutes: 90,
      method: CalculationMethod.ummAlQura,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.muslimWorldLeague({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 17.0,
      method: CalculationMethod.muslimWorldLeague,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.karachi({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 18.0,
      method: CalculationMethod.karachi,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.isna({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 15.0,
      ishaAngle: 15.0,
      method: CalculationMethod.isna,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.dubai({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 18.2,
      ishaAngle: 18.2,
      method: CalculationMethod.dubai,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.qatar({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 0.0,
      ishaIntervalMinutes: 90,
      method: CalculationMethod.qatar,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.kuwait({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 17.5,
      method: CalculationMethod.kuwait,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.turkey({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(
      sunrise: -7,
      dhuhr: 5,
      asr: 4,
      maghrib: 7,
    ),
  }) {
    return CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 17.0,
      method: CalculationMethod.turkey,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.singapore({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 20.0,
      ishaAngle: 18.0,
      method: CalculationMethod.singapore,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  factory CalculationParameters.northAfrica({
    AsrMadhab madhab = AsrMadhab.shafi,
    HighLatitudeRule highLatitudeRule = HighLatitudeRule.auto,
    PrayerAdjustments adjustments = const PrayerAdjustments(),
  }) {
    return CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 17.0,
      method: CalculationMethod.northAfrica,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
  }

  /// Automatically selects the standard regional calculation method for [coords].
  factory CalculationParameters.forCoordinates(
    GeoCoordinates coords, {
    AsrMadhab? madhab,
  }) {
    final lat = coords.latitude;
    final lng = coords.longitude;

    // 1. Egypt & Sudan (lat: 10..31.8, lng: 24.5..35.0)
    if (lat >= 10.0 && lat <= 31.8 && lng >= 24.5 && lng <= 35.0) {
      return CalculationParameters.egyptian(madhab: madhab ?? AsrMadhab.shafi);
    }

    // 2. Qatar (lat: 24.4..26.5, lng: 50.7..51.65)
    if (lat >= 24.4 && lat <= 26.5 && lng >= 50.7 && lng <= 51.65) {
      return CalculationParameters.qatar(madhab: madhab ?? AsrMadhab.shafi);
    }

    // 3. UAE & Oman (lat: 16..26.5, lng: 51.65..60.0)
    if (lat >= 16.0 && lat <= 26.5 && lng > 51.65 && lng <= 60.0) {
      return CalculationParameters.dubai(madhab: madhab ?? AsrMadhab.shafi);
    }

    // 4. Kuwait (lat: 28.5..30.2, lng: 46.5..48.5)
    if (lat >= 28.5 && lat <= 30.2 && lng >= 46.5 && lng <= 48.5) {
      return CalculationParameters.kuwait(madhab: madhab ?? AsrMadhab.shafi);
    }

    // 5. Saudi Arabia, Bahrain, Yemen (Arabian Peninsula)
    if (lat >= 12.0 && lat <= 32.2 && lng > 35.0 && lng <= 55.5) {
      return CalculationParameters.ummAlQura(madhab: madhab ?? AsrMadhab.shafi);
    }

    // 6. North Africa - Morocco, Algeria, Tunisia, Libya (lat: 19..37.6, lng: -17.5..24.5)
    if (lat >= 19.0 && lat <= 37.6 && lng >= -17.5 && lng < 24.5) {
      return CalculationParameters.northAfrica(
        madhab: madhab ?? AsrMadhab.shafi,
      );
    }

    // 7. Turkey (lat: 35.8..42.2, lng: 25.6..44.9)
    if (lat >= 35.8 && lat <= 42.2 && lng >= 25.6 && lng <= 44.9) {
      return CalculationParameters.turkey(madhab: madhab ?? AsrMadhab.shafi);
    }

    // 8. North America - USA & Canada (lat: 15..75, lng: -170..-50)
    if (lat >= 15.0 && lat <= 75.0 && lng >= -170.0 && lng <= -50.0) {
      return CalculationParameters.isna(madhab: madhab ?? AsrMadhab.shafi);
    }

    // 9. South Asia - Pakistan, India, Bangladesh, Afghanistan (lat: 5..38, lng: 60..93)
    if (lat >= 5.0 && lat <= 38.0 && lng > 60.0 && lng <= 93.0) {
      return CalculationParameters.karachi(madhab: madhab ?? AsrMadhab.hanafi);
    }

    // 10. Southeast Asia - Malaysia, Singapore, Indonesia, Brunei (lat: -11..8, lng: 95..141)
    if (lat >= -11.0 && lat <= 8.0 && lng >= 95.0 && lng <= 141.0) {
      return CalculationParameters.singapore(madhab: madhab ?? AsrMadhab.shafi);
    }

    // 11. Default global standard (Europe, Levant, East Asia, Sub-Saharan Africa, South America, Australia)
    return CalculationParameters.muslimWorldLeague(
      madhab: madhab ?? AsrMadhab.shafi,
    );
  }
}

/// High-precision Global Astronomical Solar Prayer Times Helper in Pure Dart.
class PrayersHelper {
  final GeoCoordinates coordinates;
  final CalculationParameters? _customParameters;
  final double? utcOffsetHours;

  const PrayersHelper({
    this.coordinates = GeoCoordinates.cairo,
    CalculationParameters? parameters,
    this.utcOffsetHours,
  }) : _customParameters = parameters;

  /// Active calculation parameters (uses explicit parameters if provided,
  /// otherwise auto-detects the official regional method for [coordinates]).
  CalculationParameters get parameters =>
      _customParameters ?? CalculationParameters.forCoordinates(coordinates);

  // ---------------------------------------------------------------------------
  // Astronomical Solar Mathematics (Jean Meeus / PrayTimes Iterative Engine)
  // ---------------------------------------------------------------------------

  static double _degToRad(double deg) => deg * (math.pi / 180.0);
  static double _radToDeg(double rad) => rad * (180.0 / math.pi);

  static double _sinDeg(double deg) => math.sin(_degToRad(deg));
  static double _cosDeg(double deg) => math.cos(_degToRad(deg));
  static double _tanDeg(double deg) => math.tan(_degToRad(deg));
  static double _asinDeg(double x) => _radToDeg(math.asin(x.clamp(-1.0, 1.0)));
  static double _atanDeg(double x) => _radToDeg(math.atan(x));
  static double _atan2Deg(double y, double x) => _radToDeg(math.atan2(y, x));

  static double _fixAngle(double a) {
    a = a - 360.0 * (a / 360.0).floorToDouble();
    return a < 0 ? a + 360.0 : a;
  }

  static double _fixHour(double a) {
    a = a - 24.0 * (a / 24.0).floorToDouble();
    return a < 0 ? a + 24.0 : a;
  }

  static double _timeDiff(double time1, double time2) {
    return _fixHour(time2 - time1);
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

  /// Calculates Solar Declination and Equation of Time at exact Julian instant [jd].
  static ({double declination, double equationOfTime}) _sunPosition(double jd) {
    final d = jd - 2451545.0;
    final g = _fixAngle(357.529 + 0.98560028 * d);
    final q = _fixAngle(280.459 + 0.98564736 * d);
    final l = _fixAngle(q + 1.915 * _sinDeg(g) + 0.020 * _sinDeg(2.0 * g));

    final e = 23.439 - 0.00000036 * d;
    final ra = _atan2Deg(_cosDeg(e) * _sinDeg(l), _cosDeg(l)) / 15.0;
    final eqt = q / 15.0 - _fixHour(ra);
    final decl = _asinDeg(_sinDeg(e) * _sinDeg(l));

    return (declination: decl, equationOfTime: eqt);
  }

  /// Calculates local solar midday (zenith) at Julian instant [jd].
  static double _midDay(double jd) {
    final eqt = _sunPosition(jd).equationOfTime;
    return _fixHour(12.0 - eqt);
  }

  /// Calculates local solar time when the sun reaches [angle] degrees below horizon.
  /// Returns `double.nan` if the sun never reaches [angle] on this date (high latitudes).
  double _sunAngleTime(
    double jd,
    double angle, {
    required bool isCounterClockwise,
  }) {
    final decl = _sunPosition(jd).declination;
    final noon = _midDay(jd);
    final lat = coordinates.latitude;

    final denom = _cosDeg(lat) * _cosDeg(decl);
    if (denom.abs() < 1e-10) return double.nan;

    final cosH = (-_sinDeg(angle) - _sinDeg(lat) * _sinDeg(decl)) / denom;
    if (cosH < -1.0 || cosH > 1.0) {
      return double.nan; // Sun does not reach this angle (High Latitude / Polar)
    }

    final hourAngle = _radToDeg(math.acos(cosH)) / 15.0;
    return noon + (isCounterClockwise ? -hourAngle : hourAngle);
  }

  /// Calculates Asr time in local solar hours for [shadowFactor] (1 = Shafi, 2 = Hanafi).
  double _asrTime(double jd, double shadowFactor) {
    final decl = _sunPosition(jd).declination;
    final lat = coordinates.latitude;
    final zenithAngle = (lat - decl).abs();
    if (zenithAngle >= 89.9) return double.nan;

    final angle = -_atanDeg(1.0 / (shadowFactor + _tanDeg(zenithAngle)));
    return _sunAngleTime(jd, angle, isCounterClockwise: false);
  }

  /// Horizon dip angle for sunrise/sunset (0.833° + elevation correction).
  double get _riseSetAngle {
    final elv = math.max(0.0, coordinates.elevation);
    return 0.833 + 0.0347 * math.sqrt(elv);
  }

  /// Computes the night portion fraction for high-latitude adjustments.
  double _nightPortion(
    double angle,
    double nightDuration,
    HighLatitudeRule rule,
  ) {
    final effectiveRule = rule == HighLatitudeRule.auto
        ? (coordinates.latitude.abs() >= 48.0
              ? HighLatitudeRule.seventhOfTheNight
              : HighLatitudeRule.angleBased)
        : rule;

    double portion;
    switch (effectiveRule) {
      case HighLatitudeRule.middleOfTheNight:
        portion = 0.5;
      case HighLatitudeRule.seventhOfTheNight:
        portion = 1.0 / 7.0;
      case HighLatitudeRule.angleBased:
      case HighLatitudeRule.auto:
        portion = angle / 60.0;
      case HighLatitudeRule.none:
        portion = 1.0;
    }
    return portion * nightDuration;
  }

  /// Base iterative calculation of prayer times as local clock hours [0..24].
  Map<String, double> _calculateTimes(
    DateTime date, {
    bool? forceRamadanOffset,
  }) {
    final activeParams = parameters;
    final jDate =
        _julianDate(date.year, date.month, date.day) -
        coordinates.longitude / (15.0 * 24.0);

    // Initial solar hour approximations
    var fajr = 5.0;
    var sunrise = 6.0;
    var dhuhr = 12.0;
    var asr = 13.0;
    var sunset = 18.0;
    var maghrib = 18.0;
    var isha = 18.0;

    final shadowFactor = activeParams.madhab == AsrMadhab.hanafi ? 2.0 : 1.0;
    final riseSetAngle = _riseSetAngle;

    // 2-pass iterative refinement for sub-second astronomical convergence
    for (int i = 0; i < 2; i++) {
      final dhuhrNext = _midDay(jDate + dhuhr / 24.0);
      final sunriseNext = _sunAngleTime(
        jDate + sunrise / 24.0,
        riseSetAngle,
        isCounterClockwise: true,
      );
      final sunsetNext = _sunAngleTime(
        jDate + sunset / 24.0,
        riseSetAngle,
        isCounterClockwise: false,
      );
      final fajrNext = _sunAngleTime(
        jDate + fajr / 24.0,
        activeParams.fajrAngle,
        isCounterClockwise: true,
      );
      final asrNext = _asrTime(jDate + asr / 24.0, shadowFactor);
      final maghribNext = activeParams.maghribAngle > 0.0
          ? _sunAngleTime(
              jDate + maghrib / 24.0,
              activeParams.maghribAngle,
              isCounterClockwise: false,
            )
          : sunsetNext;
      final ishaNext = activeParams.ishaIntervalMinutes > 0
          ? (maghribNext.isNaN ? sunset : maghribNext) +
                (activeParams.ishaIntervalMinutes / 60.0)
          : _sunAngleTime(
              jDate + isha / 24.0,
              activeParams.ishaAngle,
              isCounterClockwise: false,
            );

      dhuhr = dhuhrNext;
      if (!sunriseNext.isNaN) sunrise = sunriseNext;
      if (!sunsetNext.isNaN) sunset = sunsetNext;
      fajr = fajrNext;
      asr = asrNext;
      maghrib = maghribNext;
      isha = ishaNext;
    }

    // Polar circle safety (above 65° where sun may not rise or set for 24h)
    final checkSunrise = _sunAngleTime(
      jDate + 6.0 / 24.0,
      riseSetAngle,
      isCounterClockwise: true,
    );
    final checkSunset = _sunAngleTime(
      jDate + 18.0 / 24.0,
      riseSetAngle,
      isCounterClockwise: false,
    );
    if (checkSunrise.isNaN || checkSunset.isNaN) {
      sunrise = dhuhr - 6.0;
      sunset = dhuhr + 6.0;
      if (maghrib.isNaN || activeParams.maghribAngle <= 0.0) {
        maghrib = sunset;
      }
    }
    if (asr.isNaN) {
      asr = dhuhr + _timeDiff(dhuhr, sunset) * 0.55;
    }

    // High Latitude Adjustment for Fajr, Maghrib, and Isha
    if (activeParams.highLatitudeRule != HighLatitudeRule.none) {
      final nightTime = _timeDiff(sunset, sunrise);

      final maxFajrDiff = _nightPortion(
        activeParams.fajrAngle,
        nightTime,
        activeParams.highLatitudeRule,
      );
      if (fajr.isNaN || _timeDiff(fajr, sunrise) > maxFajrDiff) {
        fajr = sunrise - maxFajrDiff;
      }

      if (activeParams.maghribAngle > 0.0) {
        final maxMaghribDiff = _nightPortion(
          activeParams.maghribAngle,
          nightTime,
          activeParams.highLatitudeRule,
        );
        if (maghrib.isNaN || _timeDiff(sunset, maghrib) > maxMaghribDiff) {
          maghrib = sunset + maxMaghribDiff;
        }
      } else {
        maghrib = sunset;
      }

      if (activeParams.ishaIntervalMinutes <= 0) {
        final maxIshaDiff = _nightPortion(
          activeParams.ishaAngle,
          nightTime,
          activeParams.highLatitudeRule,
        );
        if (isha.isNaN || _timeDiff(sunset, isha) > maxIshaDiff) {
          isha = sunset + maxIshaDiff;
        }
      }
    } else {
      if (fajr.isNaN) fajr = sunrise - (activeParams.fajrAngle / 60.0) * 10.0;
      if (maghrib.isNaN) maghrib = sunset;
      if (isha.isNaN) isha = sunset + (activeParams.ishaAngle / 60.0) * 10.0;
    }

    // Handle fixed-interval Isha (e.g., Umm Al-Qura 90 min, or 120 min in Ramadan)
    if (activeParams.ishaIntervalMinutes > 0) {
      final isRamadan =
          forceRamadanOffset ??
          (activeParams.method == CalculationMethod.ummAlQura &&
              _isRamadanDate(date));
      final intervalMinutes =
          (activeParams.method == CalculationMethod.ummAlQura && isRamadan)
          ? 120
          : activeParams.ishaIntervalMinutes;
      isha = maghrib + (intervalMinutes / 60.0);
    }

    // Convert from Local Solar Time to Target Location Wall-Clock Time
    final tzOffset = _resolveTimeZoneOffset(date);
    final clockShift = tzOffset - (coordinates.longitude / 15.0);
    final adj = activeParams.adjustments;

    return {
      'fajr': _fixHour(fajr + clockShift + (adj.fajr / 60.0)),
      'sunrise': _fixHour(sunrise + clockShift + (adj.sunrise / 60.0)),
      'dhuhr': _fixHour(
        dhuhr +
            clockShift +
            ((activeParams.dhuhrMinutes + adj.dhuhr) / 60.0),
      ),
      'asr': _fixHour(asr + clockShift + (adj.asr / 60.0)),
      'maghrib': _fixHour(maghrib + clockShift + (adj.maghrib / 60.0)),
      'isha': _fixHour(isha + clockShift + (adj.isha / 60.0)),
    };
  }

  // ---------------------------------------------------------------------------
  // Global Timezone & Calendar Resolution
  // ---------------------------------------------------------------------------

  /// Resolves the accurate UTC offset (in hours) for [coordinates] on [date].
  double _resolveTimeZoneOffset(DateTime date) {
    // 1. Explicit override takes highest priority
    if (utcOffsetHours != null) return utcOffsetHours!;
    if (coordinates.utcOffsetHours != null) return coordinates.utcOffsetHours!;

    final localDate = DateTime(date.year, date.month, date.day, 12);
    final deviceTz = localDate.timeZoneOffset.inMinutes / 60.0;

    final regionTz = _estimateRegionalTimeZone(
      coordinates.latitude,
      coordinates.longitude,
      localDate,
    );

    // If we have an exact regional match:
    if (regionTz != null) {
      return regionTz.offset;
    }

    // Fallback for unlisted regions: if device clock aligns with solar longitude
    // (within ±2.25 hours), the user is physically in that timezone.
    final solarTz = coordinates.longitude / 15.0;
    if ((deviceTz - solarTz).abs() <= 2.25) {
      return deviceTz;
    }

    return solarTz.roundToDouble();
  }

  /// Estimates timezone offset and DST for major world regions when viewing remote cities.
  static ({double offset, bool isFixed})? _estimateRegionalTimeZone(
    double lat,
    double lng,
    DateTime date,
  ) {
    // Egypt (UTC+2 winter, UTC+3 summer from last Friday of April to last Thursday of Oct)
    if (lat >= 22.0 && lat <= 31.8 && lng >= 24.7 && lng <= 34.95) {
      final isDst = _isEgyptDst(date);
      return (offset: isDst ? 3.0 : 2.0, isFixed: false);
    }

    // Qatar (Fixed UTC+3)
    if (lat >= 24.4 && lat <= 26.5 && lng >= 50.7 && lng <= 51.65) {
      return (offset: 3.0, isFixed: true);
    }

    // UAE & Oman (Fixed UTC+4)
    if (lat >= 16.0 && lat <= 26.5 && lng > 51.65 && lng <= 60.0) {
      return (offset: 4.0, isFixed: true);
    }

    // Saudi Arabia, Bahrain, Kuwait, Iraq, Jordan, Syria, Yemen (Fixed UTC+3)
    if (lat >= 12.0 && lat <= 37.5 && lng >= 35.0 && lng <= 55.5) {
      return (offset: 3.0, isFixed: true);
    }

    // Turkey (Fixed UTC+3)
    if (lat >= 35.8 && lat <= 42.2 && lng >= 25.6 && lng <= 44.9) {
      return (offset: 3.0, isFixed: true);
    }

    // Morocco, Algeria, Tunisia (Fixed UTC+1)
    if (lat >= 20.0 && lat <= 37.5 && lng >= -17.0 && lng <= 11.6) {
      return (offset: 1.0, isFixed: true);
    }

    // UK, Ireland, Portugal (UTC+0 winter, UTC+1 EU DST)
    if (lat >= 36.5 && lat <= 61.0 && lng >= -10.5 && lng <= 1.8) {
      final isDst = _isEuDst(date);
      return (offset: isDst ? 1.0 : 0.0, isFixed: false);
    }

    // Central & Western Europe (UTC+1 winter, UTC+2 EU DST)
    if (lat >= 36.0 && lat <= 71.5 && lng > 1.8 && lng <= 20.0) {
      final isDst = _isEuDst(date);
      return (offset: isDst ? 2.0 : 1.0, isFixed: false);
    }

    // Eastern Europe (UTC+2 winter, UTC+3 EU DST)
    if (lat >= 35.0 && lat <= 70.0 && lng > 20.0 && lng <= 30.0) {
      final isDst = _isEuDst(date);
      return (offset: isDst ? 3.0 : 2.0, isFixed: false);
    }

    // Pakistan (Fixed UTC+5)
    if (lat >= 23.5 && lat <= 37.1 && lng >= 60.8 && lng <= 77.0) {
      return (offset: 5.0, isFixed: true);
    }

    // India & Sri Lanka (Fixed UTC+5.5)
    if (lat >= 5.9 && lat <= 35.5 && lng > 68.1 && lng <= 89.0) {
      return (offset: 5.5, isFixed: true);
    }

    // Bangladesh (Fixed UTC+6)
    if (lat >= 20.5 && lat <= 26.7 && lng > 88.0 && lng <= 92.7) {
      return (offset: 6.0, isFixed: true);
    }

    // Malaysia, Singapore, Brunei, China, Philippines, Western Australia (Fixed UTC+8)
    if (lat >= -35.0 && lat <= 53.5 && lng >= 100.0 && lng <= 126.0) {
      return (offset: 8.0, isFixed: true);
    }

    // Japan & South Korea (Fixed UTC+9)
    if (lat >= 30.0 && lat <= 46.0 && lng > 126.0 && lng <= 146.0) {
      return (offset: 9.0, isFixed: true);
    }

    // USA & Canada (DST from 2nd Sunday in March to 1st Sunday in November)
    if (lat >= 24.0 && lat <= 72.0 && lng >= -168.0 && lng <= -52.0) {
      final isDst = _isNorthAmericaDst(date);
      double baseOffset;
      if (lng < -114.0) {
        baseOffset = -8.0; // Pacific Time (LA, Seattle, Vancouver)
      } else if (lng < -101.0) {
        baseOffset = -7.0; // Mountain Time (Denver, Calgary)
      } else if (lng < -85.0) {
        baseOffset = -6.0; // Central Time (Chicago, Houston, Dallas)
      } else {
        baseOffset = -5.0; // Eastern Time (New York, Toronto, Miami)
      }
      return (offset: isDst ? baseOffset + 1.0 : baseOffset, isFixed: false);
    }

    return null;
  }

  static bool _isEgyptDst(DateTime date) {
    // Last Friday of April to Last Thursday of October
    final aprilLastDay = DateTime(date.year, 4, 30);
    final daysBackToFriday = (aprilLastDay.weekday - DateTime.friday + 7) % 7;
    final startDst = DateTime(date.year, 4, 30 - daysBackToFriday);

    final octLastDay = DateTime(date.year, 10, 31);
    final daysBackToThursday =
        (octLastDay.weekday - DateTime.thursday + 7) % 7;
    final endDst = DateTime(date.year, 10, 31 - daysBackToThursday);

    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(startDst) && d.isBefore(endDst);
  }

  static bool _isEuDst(DateTime date) {
    // Last Sunday of March to Last Sunday of October
    final marchLastDay = DateTime(date.year, 3, 31);
    final startDst = DateTime(
      date.year,
      3,
      31 - (marchLastDay.weekday % 7),
    );
    final octLastDay = DateTime(date.year, 10, 31);
    final endDst = DateTime(
      date.year,
      10,
      31 - (octLastDay.weekday % 7),
    );
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(startDst) && d.isBefore(endDst);
  }

  static bool _isNorthAmericaDst(DateTime date) {
    // Second Sunday in March to First Sunday in November
    final marchFirst = DateTime(date.year, 3, 1);
    final firstSundayMarch = 1 + ((7 - marchFirst.weekday) % 7);
    final secondSundayMarch = DateTime(date.year, 3, firstSundayMarch + 7);

    final novFirst = DateTime(date.year, 11, 1);
    final firstSundayNov = DateTime(
      date.year,
      11,
      1 + ((7 - novFirst.weekday) % 7),
    );

    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(secondSundayMarch) && d.isBefore(firstSundayNov);
  }

  /// Checks if [date] falls within Hijri month 9 (Ramadan) using the Kuwaiti/Tabular Hijri algorithm.
  static bool _isRamadanDate(DateTime date) {
    final jd = _julianDate(date.year, date.month, date.day).floor();
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) ~/ 10631);
    final l2 = l - 10631 * n + 354;
    final j =
        ((10985 - l2) ~/ 5316) * ((50 * l2) ~/ 17719) +
        (l2 ~/ 5670) * ((43 * l2) ~/ 15238);
    final l3 =
        l2 -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final hijriMonth = (24 * l3) ~/ 709;
    return hijriMonth == 9;
  }

  /// Converts target location decimal clock hours [0..24] to a DateTime on [date].
  DateTime _hourToDateTime(DateTime date, double decimalHour) {
    final totalSeconds = (decimalHour * 3600.0).round();
    final hours = (totalSeconds ~/ 3600) % 24;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return DateTime(
      date.year,
      date.month,
      date.day,
      hours,
      minutes,
      seconds,
    );
  }

  // ---------------------------------------------------------------------------
  // Public API (100% Backward Compatible with Existing UI & BLoC)
  // ---------------------------------------------------------------------------

  /// Calculates all prayer times for a given date.
  Map<PrayerType, DateTime> getPrayerDateTimes(
    DateTime date, {
    bool? forceRamadanOffset,
  }) {
    final hours = _calculateTimes(date, forceRamadanOffset: forceRamadanOffset);
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
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return PrayerType.values.map((type) {
      final prayerDateTime = times[type]!;
      final isNotif = notificationOverrides?[type] ?? true;

      // Dynamic 15-minute window before and after prayer time
      final startWindowDt = prayerDateTime.subtract(const Duration(minutes: 15));
      final endWindowDt = prayerDateTime.add(const Duration(minutes: 15));

      final isNext =
          isToday &&
          !now.isBefore(startWindowDt) &&
          now.isBefore(prayerDateTime);

      final isCurrent =
          isToday &&
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
  static String formatDayOffset(
    int offset,
    DateTime date, {
    String language = 'ar',
  }) {
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
      final times = getPrayerDateTimes(targetDate, forceRamadanOffset: true);
      final isCurrent =
          targetDate.year == currentDate.year &&
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

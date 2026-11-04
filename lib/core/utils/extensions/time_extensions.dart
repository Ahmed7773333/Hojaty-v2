import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayMinutesX on TimeOfDay {
  /// Returns the number of minutes since midnight (0–1439)
  int get minutesSinceMidnight => hour * 60 + minute;

  String get formatTimeOfDay {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat.jm().format(dt);
  }

  /// Formats TimeOfDay into localized 12-hour format with AM/PM according to current context locale.
  String formatLocalized(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return formatLocalizedByLocale(locale);
  }

  /// Formats TimeOfDay into localized 12-hour format with AM/PM for a given locale string ('ar' or 'en').
  String formatLocalizedByLocale(String localeCode) {
    final isArabic = localeCode == 'ar';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final hourStr = hour12.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    final period = hour < 12
        ? (isArabic ? 'ص' : 'AM')
        : (isArabic ? 'م' : 'PM');
    return '$hourStr:$minuteStr $period';
  }

  /// Parses a prayer window time string (e.g., '05:15ص', '01:15م', '05:15 AM', '01:15 PM', '13:15') into a TimeOfDay.
  static TimeOfDay parsePrayerWindowTime(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return const TimeOfDay(hour: 5, minute: 15);

    final isPm = trimmed.contains('م') ||
        trimmed.toLowerCase().contains('pm') ||
        trimmed.contains('مساء');
    final isAm = trimmed.contains('ص') ||
        trimmed.toLowerCase().contains('am') ||
        trimmed.contains('صباح');

    final match = RegExp(r'(\d{1,2})[:](\d{1,2})').firstMatch(trimmed);
    if (match != null) {
      int parsedHour = int.tryParse(match.group(1)!) ?? 0;
      final parsedMinute = int.tryParse(match.group(2)!) ?? 0;

      if (isPm) {
        if (parsedHour < 12) parsedHour += 12;
      } else if (isAm) {
        if (parsedHour == 12) parsedHour = 0;
      }
      return TimeOfDay(
        hour: parsedHour.clamp(0, 23),
        minute: parsedMinute.clamp(0, 59),
      );
    }
    return const TimeOfDay(hour: 5, minute: 15);
  }
}

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
}

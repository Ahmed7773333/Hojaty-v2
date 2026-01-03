import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../prayers/data/models/prayers/prayers_helper.dart';

/// Provider that manages prayer times for multiple days with caching.
/// Supports navigation between days (15 days before/after today).
class PrayerTimesProvider extends ChangeNotifier {
  final PrayersHelper _prayersHelper = PrayersHelper();

  // Current day offset from today (0 = today, -1 = yesterday, +1 = tomorrow)
  int _dayOffset = 0;

  // Cache for prayer times by date offset
  final Map<int, Map<String, DateTime>> _prayerTimesCache = {};

  // Loading state
  bool _isLoading = false;

  // Next prayer info (only relevant for today)
  MapEntry<String, DateTime>? _nextPrayer;

  // Getters
  int get dayOffset => _dayOffset;
  bool get isLoading => _isLoading;
  bool get isToday => _dayOffset == 0;
  MapEntry<String, DateTime>? get nextPrayer => _nextPrayer;

  /// Gets prayer times for the current selected day
  Map<String, DateTime>? get currentPrayerTimes =>
      _prayerTimesCache[_dayOffset];

  /// Gets the actual date for the current offset
  DateTime get currentDate => DateTime.now().add(Duration(days: _dayOffset));

  /// Formatted date string for display
  String get formattedDate {
    final date = currentDate;
    if (_dayOffset == 0) {
      return 'اليوم'; // Today
    } else if (_dayOffset == 1) {
      return 'غداً'; // Tomorrow
    } else if (_dayOffset == -1) {
      return 'أمس'; // Yesterday
    } else {
      return DateFormat('EEEE d MMMM', 'ar').format(date);
    }
  }

  /// Initialize and load prayer times for today and nearby days
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load today first
      await _loadPrayerTimesForOffset(0);

      // Load next prayer for today
      if (_prayerTimesCache[0] != null) {
        _nextPrayer = await _prayersHelper.getNextPrayerTime(
          _prayerTimesCache[0]!,
        );
      }

      // Pre-load adjacent days in background
      _preloadAdjacentDays();
    } catch (e) {
      debugPrint('Error initializing prayer times: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load prayer times for a specific day offset
  Future<void> _loadPrayerTimesForOffset(int offset) async {
    if (_prayerTimesCache.containsKey(offset)) return;

    final date = DateTime.now().add(Duration(days: offset));
    final prayerTimes = _prayersHelper.getPrayerTimes(date);

    _prayerTimesCache[offset] = {
      'الفجر': prayerTimes.fajr.toLocal(),
      'الشروق': prayerTimes.sunrise.toLocal(),
      'الظهر': prayerTimes.dhuhr.toLocal(),
      'العصر': prayerTimes.asr.toLocal(),
      'المغرب': prayerTimes.maghrib.toLocal(),
      'العشاء': prayerTimes.isha.toLocal(),
    };
  }

  /// Pre-load days before and after current
  void _preloadAdjacentDays() {
    // Load 15 days before and after
    for (int i = -15; i <= 15; i++) {
      if (i != 0) {
        _loadPrayerTimesForOffset(i);
      }
    }
  }

  /// Navigate to the next day
  Future<void> goToNextDay() async {
    if (_dayOffset >= 15) return; // Limit to 15 days ahead

    _dayOffset++;

    // Ensure data is loaded
    if (!_prayerTimesCache.containsKey(_dayOffset)) {
      _isLoading = true;
      notifyListeners();
      await _loadPrayerTimesForOffset(_dayOffset);
      _isLoading = false;
    }

    notifyListeners();
  }

  /// Navigate to the previous day
  Future<void> goToPreviousDay() async {
    if (_dayOffset <= -15) return; // Limit to 15 days back

    _dayOffset--;

    // Ensure data is loaded
    if (!_prayerTimesCache.containsKey(_dayOffset)) {
      _isLoading = true;
      notifyListeners();
      await _loadPrayerTimesForOffset(_dayOffset);
      _isLoading = false;
    }

    notifyListeners();
  }

  /// Go back to today
  Future<void> goToToday() async {
    if (_dayOffset == 0) return;

    _dayOffset = 0;

    // Refresh next prayer for today
    if (_prayerTimesCache[0] != null) {
      _nextPrayer = await _prayersHelper.getNextPrayerTime(
        _prayerTimesCache[0]!,
      );
    }

    notifyListeners();
  }

  /// Refresh next prayer (should be called periodically for today)
  Future<void> refreshNextPrayer() async {
    if (!isToday || _prayerTimesCache[0] == null) return;

    _nextPrayer = await _prayersHelper.getNextPrayerTime(_prayerTimesCache[0]!);
    notifyListeners();
  }
}

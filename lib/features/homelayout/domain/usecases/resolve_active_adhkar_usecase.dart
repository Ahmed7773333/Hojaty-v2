import 'package:hojaty/features/homelayout/data/models/athkar_category_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/domain/entities/active_adhkar_window.dart';

class ResolveActiveAdhkarUseCase {
  static const Duration postPrayerDuration = Duration(minutes: 15);

  const ResolveActiveAdhkarUseCase();

  ActiveAdhkarWindow call({
    required DateTime now,
    required GeoCoordinates coordinates,
    CalculationParameters? parameters,
  }) {
    final helper = PrayersHelper(
      coordinates: coordinates,
      parameters: parameters,
    );

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final todayPrayers = helper.getPrayerDateTimes(today);
    final yesterdayIsha = helper.getPrayerDateTimes(yesterday)[PrayerType.isha]!;
    final tomorrowFajr = helper.getPrayerDateTimes(tomorrow)[PrayerType.fajr]!;
    final todayFajr = todayPrayers[PrayerType.fajr]!;

    // Handle yesterday's Isha post-prayer window if it crosses midnight.
    final rawYesterdayIshaEnd = yesterdayIsha.add(postPrayerDuration);
    final yesterdayIshaEnd = rawYesterdayIshaEnd.isBefore(todayFajr)
        ? rawYesterdayIshaEnd
        : todayFajr;

    if (!now.isBefore(yesterdayIsha) && now.isBefore(yesterdayIshaEnd)) {
      return ActiveAdhkarWindow(
        categoryType: AthkarCategoryType.afterPrayer,
        categoryId: 27,
        nextBoundary: yesterdayIshaEnd,
        activePrayer: PrayerType.isha,
      );
    }

    if (now.isBefore(todayFajr)) {
      return ActiveAdhkarWindow(
        categoryType: AthkarCategoryType.sleep,
        categoryId: 2,
        nextBoundary: todayFajr,
      );
    }

    const orderedPrayers = PrayerType.values;
    for (int i = 0; i < orderedPrayers.length; i++) {
      final type = orderedPrayers[i];
      final prayerTime = todayPrayers[type]!;
      final nextPrayerStart = (i + 1 < orderedPrayers.length)
          ? todayPrayers[orderedPrayers[i + 1]]!
          : tomorrowFajr;

      final rawPostEnd = prayerTime.add(postPrayerDuration);
      final postEnd =
          rawPostEnd.isBefore(nextPrayerStart) ? rawPostEnd : nextPrayerStart;

      if (!now.isBefore(prayerTime) && now.isBefore(postEnd)) {
        return ActiveAdhkarWindow(
          categoryType: AthkarCategoryType.afterPrayer,
          categoryId: 27,
          nextBoundary: postEnd,
          activePrayer: type,
        );
      }

      if (!now.isBefore(postEnd) && now.isBefore(nextPrayerStart)) {
        final (categoryType, categoryId) = _adhkarForGapAfter(type);
        return ActiveAdhkarWindow(
          categoryType: categoryType,
          categoryId: categoryId,
          nextBoundary: nextPrayerStart,
        );
      }
    }

    return ActiveAdhkarWindow(
      categoryType: AthkarCategoryType.sleep,
      categoryId: 2,
      nextBoundary: tomorrowFajr,
    );
  }

  (AthkarCategoryType, int) _adhkarForGapAfter(PrayerType completedPrayer) {
    switch (completedPrayer) {
      case PrayerType.fajr:
      case PrayerType.dhuhr:
        return (AthkarCategoryType.morning, 1);
      case PrayerType.asr:
      case PrayerType.maghrib:
        return (AthkarCategoryType.evening, 133);
      case PrayerType.isha:
        return (AthkarCategoryType.sleep, 2);
    }
  }
}

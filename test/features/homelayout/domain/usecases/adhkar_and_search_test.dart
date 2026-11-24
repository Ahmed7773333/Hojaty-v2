import 'package:flutter_test/flutter_test.dart';
import 'package:hojaty/core/utils/arabic_text_normalizer.dart';
import 'package:hojaty/features/homelayout/data/datasources/local/settings_search_index.dart';
import 'package:hojaty/features/homelayout/data/models/athkar_category_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/domain/usecases/resolve_active_adhkar_usecase.dart';
import 'package:hojaty/features/homelayout/domain/usecases/search_settings_usecase.dart';

void main() {
  group('ResolveActiveAdhkarUseCase', () {
    const useCase = ResolveActiveAdhkarUseCase();
    const coords = GeoCoordinates.cairo;
    final helper = PrayersHelper(coordinates: coords);
    final baseDate = DateTime(2026, 11, 24);
    final times = helper.getPrayerDateTimes(baseDate);

    test('returns Sleep Adhkar before Fajr', () {
      final beforeFajr = times[PrayerType.fajr]!.subtract(
        const Duration(minutes: 30),
      );
      final result = useCase(now: beforeFajr, coordinates: coords);

      expect(result.categoryType, AthkarCategoryType.sleep);
      expect(result.categoryId, 2);
      expect(result.nextBoundary, times[PrayerType.fajr]);
    });

    test('returns Post-Prayer Adhkar during 15m window after Fajr', () {
      final afterFajr5m = times[PrayerType.fajr]!.add(
        const Duration(minutes: 5),
      );
      final result = useCase(now: afterFajr5m, coordinates: coords);

      expect(result.categoryType, AthkarCategoryType.afterPrayer);
      expect(result.categoryId, 27);
      expect(result.activePrayer, PrayerType.fajr);
      expect(
        result.nextBoundary,
        times[PrayerType.fajr]!.add(const Duration(minutes: 15)),
      );
    });

    test('returns Morning Adhkar after Fajr post-prayer window', () {
      final morning = times[PrayerType.fajr]!.add(const Duration(minutes: 20));
      final result = useCase(now: morning, coordinates: coords);

      expect(result.categoryType, AthkarCategoryType.morning);
      expect(result.categoryId, 1);
      expect(result.nextBoundary, times[PrayerType.dhuhr]);
    });

    test('returns Evening Adhkar after Asr post-prayer window', () {
      final evening = times[PrayerType.asr]!.add(const Duration(minutes: 20));
      final result = useCase(now: evening, coordinates: coords);

      expect(result.categoryType, AthkarCategoryType.evening);
      expect(result.categoryId, 133);
      expect(result.nextBoundary, times[PrayerType.maghrib]);
    });

    test('returns Sleep Adhkar after Isha post-prayer window', () {
      final night = times[PrayerType.isha]!.add(const Duration(minutes: 25));
      final tomorrowFajr = helper.getPrayerDateTimes(
        baseDate.add(const Duration(days: 1)),
      )[PrayerType.fajr]!;
      final result = useCase(now: night, coordinates: coords);

      expect(result.categoryType, AthkarCategoryType.sleep);
      expect(result.categoryId, 2);
      expect(result.nextBoundary, tomorrowFajr);
    });
  });

  group('ArabicTextNormalizer & SearchSettingsUseCase', () {
    const searchUseCase = SearchSettingsUseCase();

    test('normalizes hamza, taa marbuta, alif maqsura, and tashkeel', () {
      expect(
        ArabicTextNormalizer.normalize('أَذْكَارُ الْمَسَاءِ وَالصَّلَاةُ عَلَى النَّبِيِّ'),
        'اذكار المساء والصلاه علي النبي',
      );
    });

    test('maps colloquial queries to exact settings sections', () {
      final muezzin = searchUseCase('صوت المؤذن');
      expect(muezzin.first.routeOrSectionKey, SettingsSearchIndex.keyAdhanLibrary);

      final offsets = searchUseCase('تأخير الوقت');
      expect(offsets.first.routeOrSectionKey, SettingsSearchIndex.keyAdhanOffsets);

      final fajrSilent = searchUseCase('الفجر مش بيرن');
      expect(
        fajrSilent.first.routeOrSectionKey,
        SettingsSearchIndex.keyAdhanPermissions,
      );

      final madhab = searchUseCase('المذهب');
      expect(madhab.first.routeOrSectionKey, SettingsSearchIndex.keyAdhanMadhab);
    });
  });
}

import 'dart:developer';
import 'package:hojaty/features/homelayout/data/models/hijri_calendar_helper.dart';
import 'package:hojaty/features/homelayout/data/models/occasion_item_model.dart';
import 'package:hojaty/features/homelayout/data/models/ramadan_check_response_model.dart';

import '../../domain/datasources/occasions_local_data_source.dart';
import '../../domain/datasources/occasions_remote_data_source.dart';
import '../../domain/repositories/occasions_repository.dart';

class OccasionsRepositoryImpl implements OccasionsRepository {
  final OccasionsRemoteDataSource remote;
  final OccasionsLocalDataSource local;

  OccasionsRepositoryImpl({required this.remote, required this.local});

  @override
  Future<void> syncOccasionsData() async {
    try {
      // 1. Fetch Arabic payload
      final arResponse = await remote.fetchRamadanCheck(language: 'ar');
      await local.saveRamadanCheck(arResponse.data, language: 'ar');
      final occasionsAr = HijriCalendarHelper.calculateOccasions(
        arResponse.data.hijriDate,
        language: 'ar',
      );
      await local.saveOccasions(occasionsAr, language: 'ar');

      // 2. Fetch English payload
      final enResponse = await remote.fetchRamadanCheck(language: 'en');
      await local.saveRamadanCheck(enResponse.data, language: 'en');
      final occasionsEn = HijriCalendarHelper.calculateOccasions(
        enResponse.data.hijriDate,
        language: 'en',
      );
      await local.saveOccasions(occasionsEn, language: 'en');

      log(
        '✅ [OCCASIONS] Successfully synced Hijri and Ramadan data for AR & EN',
      );
    } catch (e, st) {
      log(
        '⚠️ [OCCASIONS] Network sync failed (offline or server error): $e\n$st',
      );
    }
  }

  @override
  Future<RamadanCheckData> getRamadanCheck({required String language}) async {
    final cached = await local.getRamadanCheck(language: language);
    if (cached != null) {
      return cached;
    }

    try {
      final remoteRes = await remote.fetchRamadanCheck(language: language);
      await local.saveRamadanCheck(remoteRes.data, language: language);
      return remoteRes.data;
    } catch (_) {
      return RamadanCheckData.fallback(language: language);
    }
  }

  @override
  Future<List<OccasionItemModel>> getOccasions({
    required String language,
  }) async {
    final cached = await local.getOccasions(language: language);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final ramadanData = await getRamadanCheck(language: language);
    final calculated = HijriCalendarHelper.calculateOccasions(
      ramadanData.hijriDate,
      language: language,
    );
    await local.saveOccasions(calculated, language: language);
    return calculated;
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/datasources/occasions_local_data_source.dart';
import '../../models/occasion_item_model.dart';
import '../../models/ramadan_check_response_model.dart';

class OccasionsLocalDataSourceImpl implements OccasionsLocalDataSource {
  static const String boxName = 'occasionsBox';

  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return await Hive.openBox(boxName);
  }

  @override
  Future<void> saveRamadanCheck(
    RamadanCheckData data, {
    required String language,
  }) async {
    final box = await _getBox();
    await box.put('ramadanCheck_$language', data.toJson());
    await box.put('hijriDate_$language', data.hijriDate.toJson());
    await box.put('nextRamadan_$language', data.nextRamadan.toJson());
  }

  @override
  Future<RamadanCheckData?> getRamadanCheck({
    required String language,
  }) async {
    final box = await _getBox();
    final raw = box.get('ramadanCheck_$language');
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      return RamadanCheckData.fromJson(map);
    }
    return null;
  }

  @override
  Future<void> saveOccasions(
    List<OccasionItemModel> occasions, {
    required String language,
  }) async {
    final box = await _getBox();
    final list = occasions.map((e) => e.toJson()).toList();
    await box.put('occasions_$language', list);
  }

  @override
  Future<List<OccasionItemModel>?> getOccasions({
    required String language,
  }) async {
    final box = await _getBox();
    final raw = box.get('occasions_$language');
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => OccasionItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return null;
  }
}

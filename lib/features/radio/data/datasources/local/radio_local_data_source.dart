import 'package:hive_flutter/hive_flutter.dart';
import '../../models/readers_response.dart';

abstract class RadioLocalDataSource {
  Future<ReadersResponseModel?> getCachedReciters(String language);
  Future<void> cacheReciters(String language, ReadersResponseModel data);
}

class RadioLocalDataSourceImpl implements RadioLocalDataSource {
  static const String boxName = 'reciters_box';

  Future<Box<ReadersResponseModel>> get _box async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<ReadersResponseModel>(boxName);
    } else {
      return await Hive.openBox<ReadersResponseModel>(boxName);
    }
  }

  @override
  Future<ReadersResponseModel?> getCachedReciters(String language) async {
    final box = await _box;
    return box.get(language);
  }

  @override
  Future<void> cacheReciters(String language, ReadersResponseModel data) async {
    final box = await _box;
    await box.put(language, data);
  }
}

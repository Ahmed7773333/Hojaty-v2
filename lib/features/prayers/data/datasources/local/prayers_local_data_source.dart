import '../../models/prayersmodel.dart';

// abstract class PrayersLocalDataSource {
//   Future<void> save(PrayersModel model);
//   Future<PrayersModel?> load();
// }

class PrayersLocalDataSource {
  // final FlutterSecureStorage storage;
  // PrayersLocalDataSource({required this.storage});
  
  PrayersModel? _cache;

  Future<void> save(PrayersModel model) async {
    _cache = model;
  }

  Future<PrayersModel?> load() async {
    return _cache;
  }
}

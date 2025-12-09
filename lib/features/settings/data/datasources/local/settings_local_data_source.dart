import '../../models/settingsmodel.dart';

// abstract class SettingsLocalDataSource {
//   Future<void> save(SettingsModel model);
//   Future<SettingsModel?> load();
// }

class SettingsLocalDataSource {
  // final FlutterSecureStorage storage;
  // SettingsLocalDataSource({required this.storage});
  
  SettingsModel? _cache;

  Future<void> save(SettingsModel model) async {
    _cache = model;
  }

  Future<SettingsModel?> load() async {
    return _cache;
  }
}

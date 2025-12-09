import '../../models/azkarmodel.dart';

// abstract class AzkarLocalDataSource {
//   Future<void> save(AzkarModel model);
//   Future<AzkarModel?> load();
// }

class AzkarLocalDataSource {
  // final FlutterSecureStorage storage;
  // AzkarLocalDataSource({required this.storage});
  
  AzkarModel? _cache;

  Future<void> save(AzkarModel model) async {
    _cache = model;
  }

  Future<AzkarModel?> load() async {
    return _cache;
  }
}

import '../../models/quraanmodel.dart';

// abstract class QuraanLocalDataSource {
//   Future<void> save(QuraanModel model);
//   Future<QuraanModel?> load();
// }

class QuraanLocalDataSource {
  // final FlutterSecureStorage storage;
  // QuraanLocalDataSource({required this.storage});
  
  QuraanModel? _cache;

  Future<void> save(QuraanModel model) async {
    _cache = model;
  }

  Future<QuraanModel?> load() async {
    return _cache;
  }
}

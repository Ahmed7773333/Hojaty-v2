import '../../models/homemodel.dart';

// abstract class HomeLocalDataSource {
//   Future<void> save(HomeModel model);
//   Future<HomeModel?> load();
// }

class HomeLocalDataSource {
  // final FlutterSecureStorage storage;
  // HomeLocalDataSource({required this.storage});
  
  HomeModel? _cache;

  Future<void> save(HomeModel model) async {
    _cache = model;
  }

  Future<HomeModel?> load() async {
    return _cache;
  }
}

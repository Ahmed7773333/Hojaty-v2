import '../../../domain/datasources/homelayout_local_data_source.dart';
import '../../models/homelayoutmodel.dart';

class HomelayoutLocalDataSourceImpl implements HomelayoutLocalDataSource {
  // final FlutterSecureStorage storage;
  // HomelayoutLocalDataSourceImpl({required this.storage});
  
  HomelayoutModel? _cache;

  @override
  Future<void> save(HomelayoutModel model) async {
    _cache = model;
  }

  @override
  Future<HomelayoutModel?> load() async {
    return _cache;
  }
}

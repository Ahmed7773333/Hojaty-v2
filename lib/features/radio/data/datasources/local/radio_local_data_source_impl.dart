import '../../../domain/datasources/radio_local_data_source.dart';
import '../../models/radiomodel.dart';

class RadioLocalDataSourceImpl implements RadioLocalDataSource {
  // final FlutterSecureStorage storage;
  // RadioLocalDataSourceImpl({required this.storage});
  
  RadioModel? _cache;

  @override
  Future<void> save(RadioModel model) async {
    _cache = model;
  }

  @override
  Future<RadioModel?> load() async {
    return _cache;
  }
}

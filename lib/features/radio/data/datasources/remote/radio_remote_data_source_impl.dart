import '../../../domain/datasources/radio_remote_data_source.dart';
import '../../models/radiomodel.dart';

class RadioRemoteDataSourceImpl implements RadioRemoteDataSource {
  // final ApiConsumer apiConsumer;
  // RadioRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<RadioModel> fetch() async {
    // final response = await apiConsumer.get('/radio');
    // return RadioModel.fromJson(response);
    await Future.delayed(const Duration(milliseconds: 300));
    return RadioModel.fake();
  }
}

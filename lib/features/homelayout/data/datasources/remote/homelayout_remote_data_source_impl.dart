import '../../../domain/datasources/homelayout_remote_data_source.dart';
import '../../models/homelayoutmodel.dart';

class HomelayoutRemoteDataSourceImpl implements HomelayoutRemoteDataSource {
  // final ApiConsumer apiConsumer;
  // HomelayoutRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<HomelayoutModel> fetch() async {
    // final response = await apiConsumer.get('/homelayout');
    // return HomelayoutModel.fromJson(response);
    await Future.delayed(const Duration(milliseconds: 300));
    return HomelayoutModel.fake();
  }
}

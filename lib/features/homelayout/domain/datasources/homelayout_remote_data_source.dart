import '../../data/models/homelayoutmodel.dart';

abstract class HomelayoutRemoteDataSource {
  Future<HomelayoutModel> fetch();
}

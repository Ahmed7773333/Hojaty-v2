import 'package:hojaty/features/homelayout/data/models/homelayoutmodel.dart';

abstract class HomelayoutRemoteDataSource {
  Future<HomelayoutModel> fetch();
}

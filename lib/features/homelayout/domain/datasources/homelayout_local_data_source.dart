import 'package:hojaty/features/homelayout/data/models/homelayoutmodel.dart';

abstract class HomelayoutLocalDataSource {
  Future<void> save(HomelayoutModel model);
  Future<HomelayoutModel?> load();
}

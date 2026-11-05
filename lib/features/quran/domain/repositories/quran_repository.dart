import '../../data/models/page_data_model.dart';
import '../entities/qirat_type.dart';

abstract class QuranRepository {
  Future<List<PageDataModel>> getQuranPages();
  Future<int> getLastPage({QiratType? qirat});
  Future<void> saveLastPage(int pageNumber, {QiratType? qirat});
  Future<Map<QiratType, int>> getAllLastPages();
  Future<QiratType> getSelectedQirat();
  Future<void> saveSelectedQirat(QiratType qirat);
  Stream<QiratType> watchSelectedQirat();
}

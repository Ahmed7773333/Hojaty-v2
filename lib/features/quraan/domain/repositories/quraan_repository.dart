import '../../data/models/page_data.dart';
import '../entities/qirat_type.dart';

abstract class QuraanRepository {
  Future<List<PageData>> getQuranPages();
  Future<int> getLastPage();
  Future<void> saveLastPage(int pageNumber);
  Future<QiratType> getSelectedQirat();
  Future<void> saveSelectedQirat(QiratType qirat);
  Stream<QiratType> watchSelectedQirat();
}

import 'package:hojaty/features/quran/data/models/page_data_model.dart';
import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';

abstract class QuranRepository {
  Future<List<PageDataModel>> getQuranPages();
  Future<int> getLastPage({QiratType? qirat});
  Future<void> saveLastPage(int pageNumber, {QiratType? qirat});
  Future<Map<QiratType, int>> getAllLastPages();
  Future<QiratType> getSelectedQirat();
  Future<void> saveSelectedQirat(QiratType qirat);
  Stream<QiratType> watchSelectedQirat();
}

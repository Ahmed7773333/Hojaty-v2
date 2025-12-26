import '../../data/models/page_data.dart';

abstract class QuraanRepository {
  Future<List<PageData>> getQuranPages();
  Future<int> getLastPage();
  Future<void> saveLastPage(int pageNumber);
}

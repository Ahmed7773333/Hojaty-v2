import '../../data/models/page_data.dart';
import '../../domain/repositories/quraan_repository.dart';
import '../datasources/local/quraan_local_data_source.dart';

class QuraanRepositoryImpl implements QuraanRepository {
  final QuraanLocalDataSource local;

  QuraanRepositoryImpl({required this.local});

  @override
  Future<List<PageData>> getQuranPages() async {
    // Ensure initialized
    await local.init();
    return local.getPages();
  }

  @override
  Future<int> getLastPage() async {
    await local.init();
    return local.getLastPage();
  }

  @override
  Future<void> saveLastPage(int pageNumber) async {
    await local.init();
    await local.saveLastPage(pageNumber);
  }
}

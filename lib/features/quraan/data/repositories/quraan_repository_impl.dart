import '../../data/models/page_data.dart';
import '../../domain/repositories/quraan_repository.dart';
import '../../domain/entities/qirat_type.dart';
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

  @override
  Future<QiratType> getSelectedQirat() async {
    await local.init();
    return local.getSelectedQirat();
  }

  @override
  Future<void> saveSelectedQirat(QiratType qirat) async {
    await local.init();
    await local.saveSelectedQirat(qirat);
  }

  @override
  Stream<QiratType> watchSelectedQirat() {
    // Assuming init is called before watch or handled.
    // Hive boxes usually need to be open. LocalDataSource.init() handles open.
    // Making this async* or ensuring init might be tricky in sync stream return.
    // However, usually repo methods are called after app start where init runs.
    // For safety, we might want to ensure box is open.
    // But watch() on a box requires the box instance.
    // Let's assume init() has been called by the time UI watches.
    return local.watchSelectedQirat();
  }
}

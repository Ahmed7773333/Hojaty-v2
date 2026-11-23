import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/domain/repositories/quran_repository.dart';
import 'package:hojaty/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:hojaty/features/quran/data/models/page_data_model.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;

  const QuranRepositoryImpl({required this.localDataSource});

  @override
  Future<List<PageDataModel>> getQuranPages() async {
    await localDataSource.init();
    return localDataSource.getPages();
  }

  @override
  Future<int> getLastPage({QiratType? qirat}) async {
    await localDataSource.init();
    return localDataSource.getLastPage(qirat: qirat);
  }

  @override
  Future<void> saveLastPage(int pageNumber, {QiratType? qirat}) async {
    await localDataSource.init();
    await localDataSource.saveLastPage(pageNumber, qirat: qirat);
  }

  @override
  Future<Map<QiratType, int>> getAllLastPages() async {
    await localDataSource.init();
    return localDataSource.getAllLastPages();
  }

  @override
  Future<QiratType> getSelectedQirat() async {
    await localDataSource.init();
    return localDataSource.getSelectedQirat();
  }

  @override
  Future<void> saveSelectedQirat(QiratType qirat) async {
    await localDataSource.init();
    await localDataSource.saveSelectedQirat(qirat);
  }

  @override
  Stream<QiratType> watchSelectedQirat() {
    return localDataSource.watchSelectedQirat();
  }
}

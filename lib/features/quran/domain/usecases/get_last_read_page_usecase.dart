import '../entities/qirat_type.dart';
import '../repositories/quran_repository.dart';

class GetLastReadPageUseCase {
  final QuranRepository repository;

  const GetLastReadPageUseCase(this.repository);

  Future<int> call({QiratType? qirat}) async {
    return repository.getLastPage(qirat: qirat);
  }
}

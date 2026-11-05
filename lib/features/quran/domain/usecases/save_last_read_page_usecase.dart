import '../entities/qirat_type.dart';
import '../repositories/quran_repository.dart';

class SaveLastReadPageUseCase {
  final QuranRepository repository;

  const SaveLastReadPageUseCase(this.repository);

  Future<void> call(int pageNumber, {QiratType? qirat}) async {
    return repository.saveLastPage(pageNumber, qirat: qirat);
  }
}

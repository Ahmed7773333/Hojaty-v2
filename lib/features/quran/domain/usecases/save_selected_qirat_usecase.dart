import '../entities/qirat_type.dart';
import '../repositories/quran_repository.dart';

class SaveSelectedQiratUseCase {
  final QuranRepository repository;

  const SaveSelectedQiratUseCase(this.repository);

  Future<void> call(QiratType qirat) async {
    return repository.saveSelectedQirat(qirat);
  }
}

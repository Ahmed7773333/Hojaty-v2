import '../entities/qirat_type.dart';
import '../repositories/quran_repository.dart';

class GetSelectedQiratUseCase {
  final QuranRepository repository;

  const GetSelectedQiratUseCase(this.repository);

  Future<QiratType> call() async {
    return repository.getSelectedQirat();
  }
}

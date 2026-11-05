import '../entities/qirat_type.dart';
import '../repositories/quran_repository.dart';

class GetAllLastPagesUseCase {
  final QuranRepository repository;

  const GetAllLastPagesUseCase(this.repository);

  Future<Map<QiratType, int>> call() async {
    return repository.getAllLastPages();
  }
}


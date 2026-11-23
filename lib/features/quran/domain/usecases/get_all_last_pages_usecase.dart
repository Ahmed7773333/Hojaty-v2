import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/domain/repositories/quran_repository.dart';

class GetAllLastPagesUseCase {
  final QuranRepository repository;

  const GetAllLastPagesUseCase(this.repository);

  Future<Map<QiratType, int>> call() async {
    return repository.getAllLastPages();
  }
}


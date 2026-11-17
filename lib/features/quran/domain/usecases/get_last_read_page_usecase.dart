import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/domain/repositories/quran_repository.dart';

class GetLastReadPageUseCase {
  final QuranRepository repository;

  const GetLastReadPageUseCase(this.repository);

  Future<int> call({QiratType? qirat}) async {
    return repository.getLastPage(qirat: qirat);
  }
}

import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/domain/repositories/quran_repository.dart';

class SaveLastReadPageUseCase {
  final QuranRepository repository;

  const SaveLastReadPageUseCase(this.repository);

  Future<void> call(int pageNumber, {QiratType? qirat}) async {
    return repository.saveLastPage(pageNumber, qirat: qirat);
  }
}

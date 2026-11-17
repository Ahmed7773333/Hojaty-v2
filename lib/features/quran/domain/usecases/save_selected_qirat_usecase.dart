import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/domain/repositories/quran_repository.dart';

class SaveSelectedQiratUseCase {
  final QuranRepository repository;

  const SaveSelectedQiratUseCase(this.repository);

  Future<void> call(QiratType qirat) async {
    return repository.saveSelectedQirat(qirat);
  }
}

import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:hojaty/features/quran/domain/repositories/quran_repository.dart';

class GetSelectedQiratUseCase {
  final QuranRepository repository;

  const GetSelectedQiratUseCase(this.repository);

  Future<QiratType> call() async {
    return repository.getSelectedQirat();
  }
}

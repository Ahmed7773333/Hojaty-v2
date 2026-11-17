import 'package:hojaty/features/quran/data/models/page_data_model.dart';
import 'package:hojaty/features/quran/domain/repositories/quran_repository.dart';

class GetQuranPagesUseCase {
  final QuranRepository repository;

  const GetQuranPagesUseCase(this.repository);

  Future<List<PageDataModel>> call() async {
    return repository.getQuranPages();
  }
}

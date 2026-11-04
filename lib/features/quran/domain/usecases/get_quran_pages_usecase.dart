import '../../data/models/page_data_model.dart';
import '../repositories/quran_repository.dart';

class GetQuranPagesUseCase {
  final QuranRepository repository;

  const GetQuranPagesUseCase(this.repository);

  Future<List<PageDataModel>> call() async {
    return repository.getQuranPages();
  }
}

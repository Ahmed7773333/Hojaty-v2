import '../repositories/quran_repository.dart';

class SaveLastReadPageUseCase {
  final QuranRepository repository;

  const SaveLastReadPageUseCase(this.repository);

  Future<void> call(int pageNumber) async {
    return repository.saveLastPage(pageNumber);
  }
}

import '../repositories/quran_repository.dart';

class GetLastReadPageUseCase {
  final QuranRepository repository;

  const GetLastReadPageUseCase(this.repository);

  Future<int> call() async {
    return repository.getLastPage();
  }
}

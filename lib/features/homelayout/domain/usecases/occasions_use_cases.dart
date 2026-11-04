import '../../data/models/occasion_item_model.dart';
import '../../data/models/ramadan_check_response_model.dart';
import '../repositories/occasions_repository.dart';

class GetRamadanCheckUseCase {
  final OccasionsRepository repository;

  GetRamadanCheckUseCase(this.repository);

  Future<RamadanCheckData> call({required String language}) {
    return repository.getRamadanCheck(language: language);
  }
}

class GetOccasionsListUseCase {
  final OccasionsRepository repository;

  GetOccasionsListUseCase(this.repository);

  Future<List<OccasionItemModel>> call({required String language}) {
    return repository.getOccasions(language: language);
  }
}

class SyncOccasionsDataUseCase {
  final OccasionsRepository repository;

  SyncOccasionsDataUseCase(this.repository);

  Future<void> call() {
    return repository.syncOccasionsData();
  }
}

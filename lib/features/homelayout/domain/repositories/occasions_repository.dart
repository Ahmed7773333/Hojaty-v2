import '../../data/models/occasion_item_model.dart';
import '../../data/models/ramadan_check_response_model.dart';

abstract class OccasionsRepository {
  Future<RamadanCheckData> getRamadanCheck({required String language});
  Future<List<OccasionItemModel>> getOccasions({required String language});
  Future<void> syncOccasionsData();
}

import '../../data/models/occasion_item_model.dart';
import '../../data/models/ramadan_check_response_model.dart';

abstract class OccasionsLocalDataSource {
  Future<void> saveRamadanCheck(RamadanCheckData data, {required String language});
  Future<RamadanCheckData?> getRamadanCheck({required String language});
  Future<void> saveOccasions(List<OccasionItemModel> occasions, {required String language});
  Future<List<OccasionItemModel>?> getOccasions({required String language});
}

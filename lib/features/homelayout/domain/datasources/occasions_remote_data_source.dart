import '../../data/models/ramadan_check_response_model.dart';

abstract class OccasionsRemoteDataSource {
  Future<RamadanCheckResponseModel> fetchRamadanCheck({required String language});
}

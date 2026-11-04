import '../../models/reciter_model.dart';

abstract class RadioRemoteDataSource {
  Future<List<ReciterModel>> getReciters({required String language});
}


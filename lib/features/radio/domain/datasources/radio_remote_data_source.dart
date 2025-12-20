import '../../data/models/radiomodel.dart';

abstract class RadioRemoteDataSource {
  Future<RadioModel> fetch();
}

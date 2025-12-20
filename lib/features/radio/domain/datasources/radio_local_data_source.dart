import '../../data/models/radiomodel.dart';

abstract class RadioLocalDataSource {
  Future<void> save(RadioModel model);
  Future<RadioModel?> load();
}

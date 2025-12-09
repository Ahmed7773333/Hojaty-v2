import '../../data/models/settingsmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class SettingsRepository {
  // Future<Either<Failure, SettingsModel>> getSettings();
  Future<SettingsModel> getSettings();
}

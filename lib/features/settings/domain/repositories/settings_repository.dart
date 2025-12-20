import '../../../home/data/models/user_db.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class SettingsRepository {
  // Future<Either<Failure, SettingsModel>> getSettings();
  Future<User?> getSettings();
}

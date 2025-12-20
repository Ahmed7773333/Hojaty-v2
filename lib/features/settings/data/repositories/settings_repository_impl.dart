import '../../domain/repositories/settings_repository.dart';
import '../../../home/data/models/user_db.dart';
import '../../../home/data/models/user_db_helper.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl();

  @override
  Future<User?> getSettings() async {
    return UserDbHelper.getById();
  }
}

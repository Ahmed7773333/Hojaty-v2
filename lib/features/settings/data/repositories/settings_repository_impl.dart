import '../../domain/repositories/settings_repository.dart';
import '../datasources/remote/settings_remote_data_source.dart';
import '../datasources/local/settings_local_data_source.dart';
import '../models/settingsmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remote;
  final SettingsLocalDataSource local;

  SettingsRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<SettingsModel> getSettings() async {
    // In a real app, you'd use dartz Either for error handling:
    // Future<Either<Failure, SettingsModel>> getSettings() async {
    // try {
    //   final cached = await local.load();
    //   if (cached != null) return Right(cached);
    //
    //   final data = await remote.fetch();
    //   await local.save(data);
    //   return Right(data);
    // } on ServerException catch (e) {
    //   return Left(ServerFailure(e.message));
    // } on CacheException catch (e) {
    //   return Left(CacheFailure(e.message));
    // }
    // }
    
    final cached = await local.load();
    if (cached != null) return cached;

    final data = await remote.fetch();
    await local.save(data);
    return data;
  }
}

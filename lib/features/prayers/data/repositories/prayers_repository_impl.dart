import '../../domain/repositories/prayers_repository.dart';
import '../datasources/remote/prayers_remote_data_source.dart';
import '../datasources/local/prayers_local_data_source.dart';
import '../models/prayersmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class PrayersRepositoryImpl implements PrayersRepository {
  final PrayersRemoteDataSource remote;
  final PrayersLocalDataSource local;

  PrayersRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<PrayersModel> getPrayers() async {
    // In a real app, you'd use dartz Either for error handling:
    // Future<Either<Failure, PrayersModel>> getPrayers() async {
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

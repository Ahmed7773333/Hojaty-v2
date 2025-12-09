import '../../domain/repositories/azkar_repository.dart';
import '../datasources/remote/azkar_remote_data_source.dart';
import '../datasources/local/azkar_local_data_source.dart';
import '../models/azkarmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class AzkarRepositoryImpl implements AzkarRepository {
  final AzkarRemoteDataSource remote;
  final AzkarLocalDataSource local;

  AzkarRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<AzkarModel> getAzkar() async {
    // In a real app, you'd use dartz Either for error handling:
    // Future<Either<Failure, AzkarModel>> getAzkar() async {
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

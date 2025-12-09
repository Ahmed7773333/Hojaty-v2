import '../../domain/repositories/quraan_repository.dart';
import '../datasources/remote/quraan_remote_data_source.dart';
import '../datasources/local/quraan_local_data_source.dart';
import '../models/quraanmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class QuraanRepositoryImpl implements QuraanRepository {
  final QuraanRemoteDataSource remote;
  final QuraanLocalDataSource local;

  QuraanRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<QuraanModel> getQuraan() async {
    // In a real app, you'd use dartz Either for error handling:
    // Future<Either<Failure, QuraanModel>> getQuraan() async {
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

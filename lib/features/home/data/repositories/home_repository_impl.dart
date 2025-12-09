import '../../domain/repositories/home_repository.dart';
import '../datasources/remote/home_remote_data_source.dart';
import '../datasources/local/home_local_data_source.dart';
import '../models/homemodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;
  final HomeLocalDataSource local;

  HomeRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<HomeModel> getHome() async {
    // In a real app, you'd use dartz Either for error handling:
    // Future<Either<Failure, HomeModel>> getHome() async {
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

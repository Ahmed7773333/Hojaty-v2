import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
// import '../../../../core/network/network_info.dart';
import '../../domain/repositories/radio_repository.dart';
import '../datasources/local/radio_local_data_source.dart';
import '../datasources/remote/radio_remote_data_source.dart';
import '../models/readers_response.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioRemoteDataSource remoteDataSource;
  final RadioLocalDataSource localDataSource;

  RadioRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> getRadio() async {
    // Legacy placeholder
    return const Right(null);
  }

  @override
  Future<Either<Failure, ReadersResponseModel>> getReciters({
    required String language,
  }) async {
    try {
      // Map 'en' to 'eng' for API if needed
      final apiLanguage = language == 'en' ? 'eng' : language;

      final cached = await localDataSource.getCachedReciters(apiLanguage);
      if (cached != null) {
        return Right(cached);
      }

      // If missing, fetch BOTH 'ar' and 'eng' to ensure we have data for language switching
      // We run these concurrently for better performance
      final results = await Future.wait([
        remoteDataSource.getReciters(language: 'ar'),
        remoteDataSource.getReciters(language: 'eng'),
      ]);

      final arData = results[0];
      final enData = results[1];

      // Cache both
      await localDataSource.cacheReciters('ar', arData);
      await localDataSource.cacheReciters('eng', enData);

      // Return the requested one
      if (apiLanguage == 'head' || apiLanguage == 'ar') return Right(arData);
      return Right(enData);
    } catch (e) {
      // If offline and no cache, return failure
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/readers_response.dart';

abstract class RadioRepository {
  Future<Either<Failure, void>> getRadio();
  Future<Either<Failure, ReadersResponseModel>> getReciters({
    required String language,
  });
}

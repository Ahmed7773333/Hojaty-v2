import '../../data/models/azkarmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class AzkarRepository {
  // Future<Either<Failure, AzkarModel>> getAzkar();
  Future<AzkarModel> getAzkar();
}

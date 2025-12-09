import '../../data/models/prayersmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class PrayersRepository {
  // Future<Either<Failure, PrayersModel>> getPrayers();
  Future<PrayersModel> getPrayers();
}

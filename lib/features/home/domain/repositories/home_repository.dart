import '../../data/models/homemodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  // Future<Either<Failure, HomeModel>> getHome();
  Future<HomeModel> getHome();
}

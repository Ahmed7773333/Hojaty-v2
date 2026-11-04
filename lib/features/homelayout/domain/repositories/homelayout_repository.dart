import '../../data/models/homelayoutmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class HomelayoutRepository {
  // Future<Either<Failure, HomelayoutModel>> getHomelayout();
  Future<HomelayoutModel> getHomelayout();
}

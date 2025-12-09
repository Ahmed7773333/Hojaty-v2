import '../../data/models/quraanmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class QuraanRepository {
  // Future<Either<Failure, QuraanModel>> getQuraan();
  Future<QuraanModel> getQuraan();
}

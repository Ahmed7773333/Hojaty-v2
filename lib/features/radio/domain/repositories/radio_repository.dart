import '../../data/models/radiomodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class RadioRepository {
  // Future<Either<Failure, RadioModel>> getRadio();
  Future<RadioModel> getRadio();
}

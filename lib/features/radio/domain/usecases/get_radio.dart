import '../repositories/radio_repository.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/radio.dart';

class GetRadioUseCase {
  final RadioRepository repository;

  GetRadioUseCase(this.repository);

  Future call() => repository.getRadio();
}

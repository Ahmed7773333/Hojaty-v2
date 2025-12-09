import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_azkar.dart';
import 'azkar_event.dart';
import 'azkar_state.dart';

class AzkarBloc extends Bloc<AzkarEvent, AzkarState> {
  final GetAzkarUseCase getAzkar;

  AzkarBloc({required this.getAzkar})
      : super(const AzkarState()) {
    on<LoadAzkarEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
      LoadAzkarEvent event, Emitter<AzkarState> emit) async {
    emit(state.copyWith(status: AzkarStatus.loading));
    try {
      // final result = await getAzkar();
      // result.fold(
      //   (failure) => emit(state.copyWith(
      //       status: AzkarStatus.error, message: failure.message)),
      //   (entity) => emit(state.copyWith(
      //       status: AzkarStatus.loaded, entity: entity)),
      // );
      
      await getAzkar(); // simple version
      emit(state.copyWith(status: AzkarStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: AzkarStatus.error, message: e.toString()));
    }
  }
}

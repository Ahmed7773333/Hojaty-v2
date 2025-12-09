import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase getHome;

  HomeBloc({required this.getHome})
      : super(const HomeState()) {
    on<LoadHomeEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
      LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      // final result = await getHome();
      // result.fold(
      //   (failure) => emit(state.copyWith(
      //       status: HomeStatus.error, message: failure.message)),
      //   (entity) => emit(state.copyWith(
      //       status: HomeStatus.loaded, entity: entity)),
      // );
      
      await getHome(); // simple version
      emit(state.copyWith(status: HomeStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, message: e.toString()));
    }
  }
}

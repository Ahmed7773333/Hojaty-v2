import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_onboarding.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingUseCase getOnboarding;

  OnboardingBloc({required this.getOnboarding})
      : super(const OnboardingState()) {
    on<LoadOnboardingEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
      LoadOnboardingEvent event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    try {
      await getOnboarding(); // simple version
      emit(state.copyWith(status: OnboardingStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: OnboardingStatus.error, message: e.toString()));
    }
  }
}

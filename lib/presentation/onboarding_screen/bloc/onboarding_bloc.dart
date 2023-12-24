import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../models/onboarding_model.dart';
import '/core/app_export.dart';

part 'onboarding_event.dart';

part 'onboarding_state.dart';

/// A bloc that manages the state of a Splash according to the event that is dispatched to it.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(super.initialState) {
    on<OnboardingInitialEvent>(_onInitialize);
  }

  _onInitialize(
    OnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (event is OnboardingOpenHomeEvent) {
      NavigatorService.popAndPushNamed(
        AppRoutes.homePage,
      );
    }
  }
}

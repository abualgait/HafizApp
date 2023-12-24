// ignore_for_file: must_be_immutable

part of 'onboarding_bloc.dart';

/// Represents the state of Splash in the application.
class OnboardingState extends Equatable {
  OnboardingState({this.onboardingModel});

  OnboardingModel? onboardingModel;

  @override
  List<Object?> get props => [
    onboardingModel,
      ];
  OnboardingState copyWith({OnboardingModel? onboardingModel}) {
    return OnboardingState(
      onboardingModel: onboardingModel ?? this.onboardingModel,
    );
  }
}

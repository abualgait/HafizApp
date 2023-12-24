// ignore_for_file: must_be_immutable

part of 'onboarding_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///Splash widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class OnboardingEvent extends Equatable {}

/// Event that is dispatched when the Splash widget is first created.
class OnboardingInitialEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];
}

class OnboardingOpenHomeEvent extends OnboardingEvent {
  @override
  List<Object?> get props => [];
}

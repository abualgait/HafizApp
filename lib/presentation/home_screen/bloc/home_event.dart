// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class HomeEvent extends Equatable {}

class HomeInitialEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeShowLastSurahEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

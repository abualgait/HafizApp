// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

/// Represents the state of Splash in the application.
class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class InitialSurahState extends HomeState {}

class UpdateLastReadSurah extends HomeState {
  final Surah? surah;

  const UpdateLastReadSurah({required this.surah});

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return 'UpdateLastReadSurah{surah: $surah}';
  }
}

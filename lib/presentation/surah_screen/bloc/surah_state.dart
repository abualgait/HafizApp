// ignore_for_file: must_be_immutable

part of 'surah_bloc.dart';

class SurahState extends Equatable {
  const SurahState();

  @override
  List<Object> get props => [];
}

class InitialSurahState extends SurahState {}

class LoadingSurahState extends SurahState {}

class SuccessSurahState extends SurahState {
  final List<Chapter> chapters;

  const SuccessSurahState({required this.chapters});

  @override
  List<Object> get props => [chapters];

  @override
  String toString() {
    return 'SuccessSurahState{chapters: $chapters}';
  }
}

class FailureSurahState extends SurahState {
  final String errorMessage;

  const FailureSurahState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'FailureSurahState{errorMessage: $errorMessage}';
  }
}

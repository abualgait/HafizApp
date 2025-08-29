// ignore_for_file: must_be_immutable

part of 'surah_bloc.dart';

abstract class SurahEvent extends Equatable {
  const SurahEvent();
}

class LoadSurahEvent extends SurahEvent {
  final String surahId;

  const LoadSurahEvent({required this.surahId});

  @override
  List<Object> get props => [surahId];

  @override
  String toString() {
    return 'LoadSurahEvent{surahId: $surahId}';
  }
}

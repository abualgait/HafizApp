// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:hafiz_app/core/quran_index/quran_surah.dart';

class HomeModel extends Equatable {
  HomeModel({this.surah, this.ayah});

  Surah? surah;
  int? ayah;

  HomeModel copyWith(Surah? surah, int? ayah) {
    return HomeModel(surah: surah ?? this.surah, ayah: ayah ?? this.ayah);
  }

  @override
  List<Object?> get props => [];
}

import 'package:equatable/equatable.dart';

import 'surah_model.dart';

class QuranModel extends Equatable {
  final DataModel? data;

  const QuranModel({this.data});

  factory QuranModel.fromJson(Map<String, dynamic> json) {
    return QuranModel(
      data: json['data'] != null ? DataModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'data': data?.toJson(),
    };
  }

  QuranModel copyWith({DataModel? data}) {
    return QuranModel(
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data];
}

class DataModel extends Equatable {
  final List<SurahModel>? surahs;

  const DataModel({this.surahs});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      surahs: (json['surahs'] as List<dynamic>?)
          ?.map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'surahs': surahs?.map((e) => e.toJson()).toList(),
    };
  }

  DataModel copyWith({List<SurahModel>? surahs}) {
    return DataModel(
      surahs: surahs ?? this.surahs,
    );
  }

  @override
  List<Object?> get props => [surahs];
}

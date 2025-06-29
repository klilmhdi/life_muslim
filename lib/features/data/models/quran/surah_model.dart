import 'package:equatable/equatable.dart';

import 'ayah_model.dart';

class SurahModel extends Equatable {
  final int? number;
  final String? name;
  final String? englishName;
  final String? englishNameTranslation;
  final String? revelationType;
  final List<AyahsModel>? ayahs;

  const SurahModel({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.revelationType,
    this.ayahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int?,
      name: json['name'] as String?,
      englishName: json['englishName'] as String?,
      englishNameTranslation: json['englishNameTranslation'] as String?,
      revelationType: json['revelationType'] as String?,
      ayahs: (json['ayahs'] as List<dynamic>?)
          ?.map((e) => AyahsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'ayahs': ayahs?.map((e) => e.toJson()).toList(),
    };
  }

  SurahModel copyWith({
    int? number,
    String? name,
    String? englishName,
    String? englishNameTranslation,
    String? revelationType,
    List<AyahsModel>? ayahs,
  }) {
    return SurahModel(
      number: number ?? this.number,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      englishNameTranslation: englishNameTranslation ?? this.englishNameTranslation,
      revelationType: revelationType ?? this.revelationType,
      ayahs: ayahs ?? this.ayahs,
    );
  }

  @override
  List<Object?> get props =>
      [number, name, englishName, englishNameTranslation, revelationType, ayahs];
}

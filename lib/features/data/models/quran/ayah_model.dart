import 'package:equatable/equatable.dart';

class AyahsModel extends Equatable {
  final int? number;
  final String? audio;
  final List<String>? audioSecondary;
  final String? text;
  final String? ayaTextEmlaey;
  final int? numberInSurah;
  final int? juz;
  final int? manzil;
  final int? page;
  final int? pageInSurah;
  final int? ruku;
  final int? hizbQuarter;
  final bool? sajda;
  final String? codeV2;

  const AyahsModel({
    this.number,
    this.audio,
    this.audioSecondary,
    this.text,
    this.ayaTextEmlaey,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.pageInSurah,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
    this.codeV2,
  });

  factory AyahsModel.fromJson(Map<String, dynamic> json) {
    return AyahsModel(
      number: json['number'] as int?,
      audio: json['audio'] as String?,
      audioSecondary: json['audioSecondary'] != null
          ? List<String>.from(json['audioSecondary'])
          : null,
      text: json['text'] as String?,
      ayaTextEmlaey: json['aya_text_emlaey'] as String?,
      numberInSurah: json['numberInSurah'] as int?,
      juz: json['juz'] as int?,
      manzil: json['manzil'] as int?,
      page: json['page'] as int?,
      pageInSurah: json['pageInSurah'] as int?,
      ruku: json['ruku'] as int?,
      hizbQuarter: json['hizbQuarter'] as int?,
      sajda: json['sajda'] is bool ? json['sajda'] as bool? : false,
      codeV2: json['code_v2'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['audio'] = audio;
    data['audioSecondary'] = audioSecondary;
    data['text'] = text;
    data['aya_text_emlaey'] = ayaTextEmlaey;
    data['numberInSurah'] = numberInSurah;
    data['juz'] = juz;
    data['manzil'] = manzil;
    data['page'] = page;
    data['pageInSurah'] = pageInSurah;
    data['ruku'] = ruku;
    data['hizbQuarter'] = hizbQuarter;
    data['sajda'] = sajda ?? false;
    data['code_v2'] = codeV2;
    return data;
  }

  AyahsModel copyWith({
    int? number,
    String? audio,
    List<String>? audioSecondary,
    String? text,
    String? ayaTextEmlaey,
    int? numberInSurah,
    int? juz,
    int? manzil,
    int? page,
    int? pageInSurah,
    int? ruku,
    int? hizbQuarter,
    bool? sajda,
    String? codeV2,
  }) {
    return AyahsModel(
      number: number ?? this.number,
      audio: audio ?? this.audio,
      audioSecondary: audioSecondary ?? this.audioSecondary,
      text: text ?? this.text,
      ayaTextEmlaey: ayaTextEmlaey ?? this.ayaTextEmlaey,
      numberInSurah: numberInSurah ?? this.numberInSurah,
      juz: juz ?? this.juz,
      manzil: manzil ?? this.manzil,
      page: page ?? this.page,
      pageInSurah: pageInSurah ?? this.pageInSurah,
      ruku: ruku ?? this.ruku,
      hizbQuarter: hizbQuarter ?? this.hizbQuarter,
      sajda: sajda ?? this.sajda,
      codeV2: codeV2 ?? this.codeV2,
    );
  }

  @override
  List<Object?> get props => [
        number,
        audio,
        audioSecondary,
        text,
        ayaTextEmlaey,
        numberInSurah,
        juz,
        manzil,
        page,
        pageInSurah,
        ruku,
        hizbQuarter,
        sajda,
        codeV2,
      ];
}

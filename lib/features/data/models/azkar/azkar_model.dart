import 'package:quran_life_muslim/features/data/models/azkar/array_azkar_model.dart';

class AzkarModel {
  int? id;
  String? category;
  String? audio;
  String? filename;
  List<ArrayAzkarModel>? array;

  AzkarModel({this.id, this.category, this.audio, this.filename, this.array});

  AzkarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    audio = json['audio'];
    filename = json['filename'];
    if (json['array'] != null) {
      array = <ArrayAzkarModel>[];
      json['array'].forEach((v) {
        array!.add(ArrayAzkarModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['audio'] = audio;
    data['filename'] = filename;
    if (array != null) {
      data['array'] = array!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

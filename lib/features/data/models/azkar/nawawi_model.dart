class NawawiModel {
  String? description;
  String? hadith;

  NawawiModel({this.description, this.hadith});

  NawawiModel.fromJson(Map<String, dynamic> json) {
    hadith = json['hadith'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['hadith'] = hadith;

    return data;
  }
}

class QuranAzkarModel {
  String? id;
  String? text;
  String? info;

  QuranAzkarModel({this.id, this.text, this.info});

  QuranAzkarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['info'] = info;
    return data;
  }
}

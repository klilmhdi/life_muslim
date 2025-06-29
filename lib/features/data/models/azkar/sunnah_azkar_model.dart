class SunnahAzkarModel {
  String? id;
  String? text;

  SunnahAzkarModel({this.id, this.text});

  SunnahAzkarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    return data;
  }
}

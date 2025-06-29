class RoqaiaModel {
  String? id;
  String? text;
  String? info;
  int? repeat;

  RoqaiaModel({this.id, this.text, this.info});

  RoqaiaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    info = json['info'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['info'] = info;
    data['repeat'] = repeat;
    return data;
  }
}

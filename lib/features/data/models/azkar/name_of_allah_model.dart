class NameOfAllahModel {
  int? id;
  String? name;
  String? text;

  NameOfAllahModel({this.id, this.name, this.text});

  NameOfAllahModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['text'] = text;
    return data;
  }
}

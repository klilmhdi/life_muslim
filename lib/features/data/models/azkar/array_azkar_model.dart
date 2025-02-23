class ArrayAzkarModel {
  int? id;
  String? text;
  int? count;
  String? audio;
  String? filename;

  ArrayAzkarModel({this.id, this.text, this.count, this.audio, this.filename});

  ArrayAzkarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    text = json['text'] ?? "";
    count = json['count'] ?? 0;
    audio = json['audio'] ?? "";
    filename = json['filename'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['count'] = count;
    data['audio'] = audio;
    data['filename'] = filename;
    return data;
  }
}

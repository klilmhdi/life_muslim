class HijjahModel {
  String? title;
  String? source;

  HijjahModel({this.title, this.source});

  HijjahModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['source'] = source;

    return data;
  }
}

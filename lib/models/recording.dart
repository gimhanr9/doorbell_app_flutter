class Recording {
  String? id;
  String? name;
  String? date;
  String? url;

  Recording({this.id, this.name, this.date, this.url});

  Recording.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['date'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['date'] = date;
    data['url'] = url;
    return data;
  }
}

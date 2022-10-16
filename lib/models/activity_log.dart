class ActivityLog {
  String? id;
  String? name;
  String? date;
  String? time;
  String? imageUrl;

  ActivityLog({this.id, this.name, this.date, this.time, this.imageUrl});

  ActivityLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['date'];
    time = json['time'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fname'] = date;
    data['lname'] = time;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

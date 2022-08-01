class SavedVisitor {
  String? id;
  String? fname;
  String? lname;
  String? imageUrl;

  SavedVisitor({this.id, this.fname, this.lname, this.imageUrl});

  SavedVisitor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['fname'];
    lname = json['lname'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['fname'] = fname;
    data['lname'] = lname;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? password;
  int? otp;
  int? failedAttempts;

  User({this.name, this.email, this.password, this.otp, this.failedAttempts});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    otp = json['otp'];
    failedAttempts = json['failedAttempts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['otp'] = otp;
    data['failedAttempts'] = failedAttempts;
    return data;
  }
}

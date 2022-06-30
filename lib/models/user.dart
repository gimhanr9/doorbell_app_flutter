class User {
  String? name;
  String email;
  String? password;
  int? otp;
  int? failedAttempts;

  User(
      {this.name,
      required this.email,
      this.password,
      this.otp,
      this.failedAttempts});
}

class LoginResponse {
  final bool user;
  final String otp;
  final String token;

  LoginResponse({
    required this.user,
    required this.otp,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: json["user"] ?? false,
      otp: json["otp"]?.toString() ?? "",
      token: json["token"]?["access"] ?? "",
    );
  }
}

class Login {
  final String token;
  final String type;
  final int expiresAt;

  Login({
    required this.token,
    required this.type,
    required this.expiresAt,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      token: json['token'] as String,
      type: json['type'] as String,
      expiresAt: json['expires_at'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
      'expires_at': expiresAt,
    };
  }
}

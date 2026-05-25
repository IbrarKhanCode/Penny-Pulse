class ProfileResponse {
  const ProfileResponse({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.lastLogin,
  });

  final int id;
  final String email;
  final DateTime createdAt;
  final DateTime lastLogin;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLogin: DateTime.parse(json['last_login'] as String),
    );
  }
}

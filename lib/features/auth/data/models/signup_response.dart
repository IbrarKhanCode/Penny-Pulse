class SignupResponse {
  const SignupResponse({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  final int id;
  final String email;
  final DateTime createdAt;

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'created_at': createdAt.toIso8601String(),
      };
}
